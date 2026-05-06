module AST where

import Control.Monad
import Control.Monad.Trans.Reader
import Data.Bifunctor
import Data.Maybe(fromJust)
import Data.List(sort, sortOn)

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

instance Eq Type where
  t1 == t2 = matchTypes [] t1 t2

type Check = ReaderT (Gamma, Delta) Maybe

type Gamma = [(Name, Type)]
type Delta = [Name]

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
withDelta t = local $ second (t :)


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
check exp t = do
  t' <- synth exp
  guard $ t == t'

okType :: Type -> Check ()
okType (TVar x) = delta >>= guard . elem x
okType (TInd x t) = withDelta x $ okType t
okType (TAll x t) = withDelta x $ okType t
okType (TSum ss) = forM_ ss $ okType . snd
okType (TProd ps) = forM_ ps okType
okType (TArr t1 t2) = okType t1 >> okType t2
okType (TDist t) = okType t
okType TBool = return ()

distType :: Type -> Check ()
distType TBool = return ()
distType (TInd x t) = withDelta x $ distType t
distType (TSum ss) = forM_ ss $ distType . snd
distType (TProd ps) = forM_ ps distType
distType (TVar x) = delta >>= guard . elem x
distType _ = mzero

subst :: Name -> Type -> Type -> Type
subst x s t = case t of
  TBool -> TBool
  (TDist t') -> TDist (subst x s t')
  (TArr t1 t2) -> TArr (subst x s t1) (subst x s t2)
  (TVar x') -> if x == x' then s else t
  (TInd x' t') -> if x == x' then t else TInd x' (subst x s t')
  (TAll x' t') -> if x == x' then t else TAll x' (subst x s t')
  (TSum ss) -> TSum $ map (second $ subst x s) ss
  (TProd ps) -> TProd $ map (subst x s) ps

matchTypes :: [(Name, Name)] -> Type -> Type -> Bool
matchTypes _ TBool TBool = True
matchTypes ms (TArr la lr) (TArr ra rr) = matchTypes ms la ra && matchTypes ms lr rr
matchTypes ms (TDist l) (TDist r) = matchTypes ms l r
matchTypes ms (TProd ls) (TProd rs) = and $ zipWith (matchTypes ms) ls rs
matchTypes ms (TSum ls) (TSum rs) =
  let f (ll, lt) (rl, rt) = ll == rl && matchTypes ms lt rt
  in and $ zipWith f (sortOn fst ls) (sortOn fst rs)
matchTypes ms (TInd lx lt) (TInd rx rt) = let ms' = (lx, rx) : ms in matchTypes ms' lt rt
matchTypes ms (TAll lx lt) (TAll rx rt) = let ms' = (lx, rx) : ms in matchTypes ms' lt rt
matchTypes ms (TVar l) (TVar r) = lookup l ms == Just r
matchTypes _ _ _ = False

