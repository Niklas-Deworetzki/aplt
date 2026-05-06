module AST where

import Control.Monad
import Control.Monad.Trans.Reader
import Data.Bifunctor
import Data.Maybe(fromJust)

type Name = String

data List a = Cons a (List a) | Nil

data Expr
  = Var Name
  | Let Name Expr Expr
  | Lambda Name Type Expr
  | App Expr Expr
  | LambdaT Name Expr
  | AppT Type Expr
  | Prod [Expr]
  | Proj Int Expr
  | Sum Type Name Expr
  | Case Expr Type [Pattern]

  -- Literals
  | LitBool Bool

  -- Inductive shit
  -- tlet List = forall a . my t . (Cons: a (t a) | Nil: Unit) in Exp
  -- my t . Unit | Unit * t
  | Fold Name Type Expr
  | Rec Name Type Name Expr Expr
  -- distributions
  | Distr Type
  | Bind Name Expr Expr
  | Guard Expr Expr
  | Plus Expr Expr
  | Return Expr

data Pattern
  = Pattern Name Name Expr

data Type
  = TBool
  | TArr Type Type

  | TInd Name Type
  | TSum [(Name, Type)]
  | TProd [Type]

  | TAll Name Type
  | TVar Name

  | TDist Type


type Check = ReaderT (Gamma, Delta) Maybe

type Gamma = [(Name, Type)]
type Delta = [Type]

gamma :: Check Gamma
gamma = asks fst

delta :: Check Delta
delta = asks snd

lookupGamma :: Name -> Check Type
lookupGamma x = do
  g <- gamma
  maybe mzero return (lookup x g)

withGamma :: Name -> Type -> Check a -> Check a
withGamma x t = local $ first ((x, t) :)

withDelta :: Name -> Check a -> Check a
withDelta t = local $ second (TVar t :)


synth :: Expr -> Check Type
synth exp = case exp of
  (Var x) -> lookupGamma x
  (Let x e1 e2) -> do
    t1 <- synth e1
    t2 <- withGamma x t1 $ synth e2
    return t2
  (Lambda x t e) -> do
    okType t
    t' <- withGamma x t $ synth e
    return $ TArr t t'
  (App f a) -> do
    (TArr ta tr) <- synth f
    check a ta
    return tr
  (LambdaT x e) -> do
    t <- withDelta x $ synth e
    return $ TAll x t
  (AppT t e) -> do
    okType t
    (TAll x t') <- synth e
    return $ subst x t t'
  (Prod es) ->
    TProd <$> mapM synth es
  (Proj k e) -> do
    (TProd ts) <- synth e
    guard $ k `elem` [0 .. length ts]
    return $ ts !! k
  (Sum t x e) -> do
    okType t -- t has to be a type
    let TSum ss = t -- and a sum type
    case lookup x ss of
      Just tk -> check e tk >> return t
      Nothing -> mzero
  (Case e t ps) -> do
    okType t
    (TSum ss) <- synth e -- scrutinized must be sum
    guard $ [l | Pattern l _ _ <- ps] == map fst ss -- check that sum and patterns have same labels
    -- for each pattern, bind to var and check exp for given type
    forM_ ps $ \(Pattern lk xk ek) -> do
      withGamma xk (fromJust $ lookup lk ss) $ check ek t
    return t

check :: Expr -> Type -> Check ()
check exp typ = undefined


okType :: Type -> Check ()
okType t = undefined

subst :: Name -> Type -> Type -> Type
subst x s t = undefined -- TODO: subst x for s in t

{-
synth delta gamma exp = case exp of
  (Var x) -> lookup x gamma
  (App f arg) -> do
    -- f is a function
    (TFun tPar tRes) <- synth delta gamma f
    -- parameter and argument types match
    check delta gamma arg tPar
    return tRes
  (Lambda x t b) -> do
    let gamma' = (x, t) : gamma
    tRet <- synth delta gamma' b
    return $ TFun t tRet
  (Let x e1 e2) -> do
    tBound <- synth delta gamma e1
    let gamma' = (x, tBound) : gamma
    synth delta gamma' e2
  (LitBool _) -> return TBool

  (LambdaT x e) -> do
    let delta' = (x, TVar x) : delta
    t <- synth delta' gamma e
    return $ TAll x t
  (AppT t1 e) -> do
    -- Ensure all type args are fine
    okType delta t1
    (TAll x t2) <- synth delta gamma e
    -- Substitute all type variables
    return $ tsubst x t1 t2

  (DataType name cons e) -> do
    let delta' = (name, TData name cons) : delta
    synth delta' gamma e
  (Fold t e pats) -> do
    t'@(TData name cons) <- okType delta t
    check delta gamma e t'
    -- TODO: check all patterns have same type
    -- TODO: check if all constructors are covered
    -- TODO: return pattern type
    _

  (ConApp tname es) -> do
    (con, tdata) <- findConstructor delta tname
    guard $ length es == length (ctorArgs con)
    sequence $ zipWith (check delta gamma) es (ctorArgs con)
    return tdata
  (TypeDistr t) ->
    TDist <$> okType delta t
    -- TODO: Check that we can randomly generate type

  (Bind x e1 e2) -> do
    (TDist t) <- synth delta gamma e1
    let gamma' = (x, t) : gamma
    synth delta gamma' e2
  (Guard pred e) -> do
    check delta gamma pred TBool
    synth delta gamma e
  (Plus e1 e2) -> do
    t1 <- synth delta gamma e1
    check delta gamma e2 t1
    return t1
  (Return e) -> do
    t <- synth delta gamma e
    return $ TDist t

check :: Delta -> Gamma -> Expr -> Type -> Maybe ()
check delta gamma exp typ =
  fmap (equiv typ) (synth delta gamma exp) >>= guard

okType :: Delta -> Type -> Maybe Type
okType delta t = case t of
  (TFun tp tr) -> do
    tp' <- okType delta tp
    tr' <- okType delta tr
    return $ TFun tp' tr'
  (TAll )
-- TODO: Return TData if TVar with name in env

equiv :: Type -> Type -> Bool
equiv = undefined

tsubst :: Name -> Type -> Type -> Type
tsubst x s t = undefined -- TODO: subst x for s in t

findConstructor :: Delta -> Name -> Maybe (Constructor, Type)
findConstructor delta name = undefined -- TODO: find constructor with name

-}
