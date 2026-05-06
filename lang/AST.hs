module AST where

import Control.Monad
import Control.Monad.Trans.Reader
import Data.Bifunctor
import Data.Maybe(fromJust)
import Data.List(sort)

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
  -- rec {t.tau} tau' (x.e1; e2)
  | Rec Name Type Type Name Expr Expr

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
    guard $ sort [l | Pattern l _ _ <- ps] == sort (map fst ss) -- check that sum and patterns have same labels
    -- for each pattern, bind to var and check exp for given type
    forM_ ps $ \(Pattern lk xk ek) -> do
      withGamma xk (fromJust $ lookup lk ss) $ check ek t
    return t
  (LitBool _) -> return TBool
  (Fold t tau e) -> do
    let tind = TInd t tau
    okType tind
    check e $ subst t tind tau
    return tind
  (Rec t tau tauR x e1 e2) -> do
    let tind = TInd t tau
    okType tind
    check e2 tind
    withGamma x (subst t tauR tau) $ check e1 tauR
    return tauR
  (Distr t) -> do
    distType t
    return $ TDist t
  (Bind x e1 e2) -> do
    (TDist t) <- synth e1
    withGamma x t $ synth e2
  (Guard p e) -> do
    check p TBool
    synth e
  (Plus e1 e2) -> do
    t <- synth e1
    check e2 t
    return t
  (Return e) ->
    TDist <$> synth e

check :: Expr -> Type -> Check ()
check exp typ = undefined


okType :: Type -> Check ()
okType t = undefined

distType :: Type -> Check ()
distType t = undefined

subst :: Name -> Type -> Type -> Type
subst x s t = undefined -- TODO: subst x for s in t

