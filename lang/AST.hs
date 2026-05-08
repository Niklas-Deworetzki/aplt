{-# LANGUAGE LambdaCase #-}
module AST where

import Control.Monad
import Control.Monad.Trans.Reader
import Control.Monad.Trans.Class (lift)
import Data.Bifunctor
import Data.Maybe(fromJust)
import Data.List(sort, sortOn)
import Lang.Abs

type Name = String

-- forall a . my t . (Cons: a (t a) | Nil: Unit) in Exp
-- my t . Unit | Unit * t

data Expr
  = Var Name
  -- x = e1 in e2
  | Let Name Expr Expr
  -- \x :: T -> e
  | Lambda Name Type Expr
  -- f x
  | App Expr Expr
  -- /\x => e
  | LambdaT Name Expr
  -- e[T]
  | AppT Type Expr
  -- < l1: e1 , ln: en >
  | Prod [(Name, Expr)]
  -- e.name
  | Proj Name Expr
  -- inj T { l: e }
  | Sum Type Name Expr
  -- case e of T { l1 x1 -> e1 | ln xn -> en }
  | Case Expr Type [Pattern]

  -- True False
  | LitBool Bool
  -- if e1 e2 e3
  | If Expr Expr Expr


  -- Z
  | Zero
  -- S (e)
  | Succ Expr
  -- iter { e1 ; x. e2 } (e3)
  | Iter Expr Name Expr Expr

  -- inductive types are dead (for now)
  -- fold [t.T] ( e )
  -- | Fold Name Type Expr
  -- rec [t.T] T' {x.e1} (e2)
  -- | Rec Name Type Type Name Expr Expr

  -- distr [T]
  | Distr Type
  -- x ~ T in e
  | Bind Name Expr Expr
  -- filter e1 in e2
  | Guard Expr Expr
  -- e1 + e2
  | Plus Expr Expr
  -- return e
  | Return Expr
  deriving Show

data Pattern
  = Pattern Name Name Expr
  deriving Show

-- forall a . my t . (Cons: a (t a) | Nil: Unit) in Exp
-- my t . Unit | Unit * t
data Type
  = TBool
  | TNat
  | TArr Type Type

  -- ind types are dead
  -- | TInd Name Type
  | TSum [(Name, Type)]
  | TProd [(Name, Type)]

  | TAll Name Type
  | TVar Name

  | TDist Type
  deriving Show

instance Eq Type where
  t1 == t2 = matchTypes [] t1 t2

type Check = ReaderT (Gamma, Delta) Maybe

type Gamma = [(Name, Type)]
type Delta = [Name]

-- Taken from https://hackage-content.haskell.org/package/extra-1.8.1/docs/src/Data.Tuple.Extra.html#secondM
secondM :: Functor m => (b -> m b') -> (a, b) -> m (a, b')
secondM f ~(a,b) = (a,) <$> f b

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

typecheck :: Expr -> Either String Type
typecheck e = case runReaderT (synth e) ([], []) of
  Just t -> Right t
  Nothing -> Left "type error"

synth :: Expr -> Check Type
synth exp = case exp of
  (Var x) -> lookupGamma x
  (Let x e1 e2) -> do
    t1 <- synth e1
    withGamma x t1 $ synth e2
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
    TProd <$> forM es (secondM synth)
  (Proj k e) -> do
    (TProd ts) <- synth e
    lift $ lookup k ts
  (Sum t x e) -> do
    okType t -- t has to be a type
    let TSum ss = t -- and a sum type
    tk <- lift (lookup x ss)
    check e tk
    return t
  (Case e t ps) -> do
    okType t
    (TSum ss) <- synth e -- scrutinized must be sum
    guard $ sort [l | Pattern l _ _ <- ps] == sort (map fst ss) -- check that sum and patterns have same labels
    -- for each pattern, bind to var and check exp for given type
    forM_ ps $ \(Pattern lk xk ek) -> do
      withGamma xk (fromJust $ lookup lk ss) $ check ek t
    return t
  (LitBool _) -> return TBool
  (If c t f) -> do
    check c TBool
    tau <- synth t
    check f tau
    return tau
  Zero -> return TNat
  (Succ e) -> check e TNat >> return TNat
  (Iter eb x ei e) -> do
    check e TNat
    tau <- synth eb
    withGamma x tau $ check ei tau
    return tau
  {-(Fold t tau e) -> do
    let tind = TInd t tau
    okType tind
    check e $ subst t tind tau
    return tind
  (Rec t tau tauR x e1 e2) -> do
    let tind = TInd t tau
    okType tind
    check e2 tind
    withGamma x (subst t tauR tau) $ check e1 tauR
    return tauR -}
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
-- okType (TInd x t) = withDelta x $ okType t
okType (TAll x t) = withDelta x $ okType t
okType (TSum ss)  = forM_ ss $ okType . snd
okType (TProd ps) = forM_ ps $ okType . snd
okType (TArr t1 t2) = okType t1 >> okType t2
okType (TDist t) = okType t
okType TBool = return ()

distType :: Type -> Check ()
distType TBool = return ()
-- distType (TInd x t) = withDelta x $ distType t
distType (TSum ss)  = forM_ ss $ distType . snd
distType (TProd ps) = forM_ ps $ distType . snd
distType (TVar x) = delta >>= guard . elem x
distType _ = mzero

subst :: Name -> Type -> Type -> Type
subst x s t = case t of
  TBool -> TBool
  TNat -> TNat
  (TDist t') -> TDist (subst x s t')
  (TArr t1 t2) -> TArr (subst x s t1) (subst x s t2)
  (TVar x') -> if x == x' then s else t
  -- (TInd x' t') -> if x == x' then t else TInd x' (subst x s t')
  (TAll x' t') -> if x == x' then t else TAll x' (subst x s t')
  (TSum ss)  -> TSum  $ map (second $ subst x s) ss
  (TProd ps) -> TProd $ map (second $ subst x s) ps

matchTypes :: [(Name, Name)] -> Type -> Type -> Bool
matchTypes _ TBool TBool = True
matchTypes _ TNat TNat = True
matchTypes ms (TArr la lr) (TArr ra rr) = matchTypes ms la ra && matchTypes ms lr rr
matchTypes ms (TDist l) (TDist r) = matchTypes ms l r
matchTypes ms (TProd ls) (TProd rs) = matchLabels ms ls rs
matchTypes ms (TSum ls)  (TSum rs)  = matchLabels ms ls rs
-- matchTypes ms (TInd lx lt) (TInd rx rt) = let ms' = (lx, rx) : ms in matchTypes ms' lt rt
matchTypes ms (TAll lx lt) (TAll rx rt) = let ms' = (lx, rx) : ms in matchTypes ms' lt rt
matchTypes ms (TVar l) (TVar r) = lookup l ms == Just r
matchTypes _ _ _ = False

matchLabels :: [(Name, Name)] -> [(Name, Type)] -> [(Name, Type)] -> Bool
matchLabels ms ls rs = and $ zipWith f (sortOn fst ls) (sortOn fst rs)
  where f (ll, lt) (rl, rt) = ll == rl && matchTypes ms lt rt




-- CONVERTER
convert (Gen exp) = convertExp exp

convertExp = \case
    PLet (Ident ident) e1 e2 -> Let ident (convertExp e1) (convertExp e2)
    PBind (Ident ident) e1 e2 -> Bind ident (convertExp e1) (convertExp e2)
    PIf e1 e2 e3 -> If (convertExp e1) (convertExp e2) (convertExp e3)
    PLambda (Ident ident) t e -> Lambda ident (convertType t) (convertExp e)
    PLambdaT (Ident ident) e -> LambdaT ident (convertExp e)
    PPlus e1 e2 -> Plus (convertExp e1) (convertExp e2)
    PReturn e -> Return (convertExp e)
    PDistr t -> Distr (convertType t)
    PProj e (Ident ident) -> Proj ident (convertExp e)
    PAppT e t -> AppT (convertType t) (convertExp e)
    PProd es -> Prod (map (\(PLabExp (Ident ident) e) -> (ident, convertExp e)) es)
    PSum t (PLabExp (Ident ident) e) -> Sum (convertType t) ident (convertExp e)
    PCase e t patts -> Case (convertExp e) (convertType t) (map convertPattern patts)
    PRec e1 (Ident ident) e2 e3 -> Iter (convertExp e1) ident (convertExp e2) (convertExp e3)
    PApp e1 e2 -> App (convertExp e1) (convertExp e2)
    PBoolT -> LitBool True
    PBoolF -> LitBool False
    PVar (Ident ident) -> Var ident
    PZero -> Zero
    PSucc e -> Succ (convertExp e)

    where convertPattern (PCaseExp (Ident ident1) (Ident ident2) e) = Pattern ident1 ident2 (convertExp e)

convertType = \case
    PTBool -> TBool
    PTVar (Ident ident) -> TVar ident
    PTArr t1 t2 -> TArr (convertType t1) (convertType t2)
    PTDist t -> TDist (convertType t)
    PTProd members -> TSum (map convertMember members)
    PTSum members -> TProd (map convertMember members)
    PTAll (Ident ident) t -> TAll ident (convertType t)

    where
        convertMember = \case
            TMember (Ident ident) t -> (ident, convertType t)
            TMember1 (Ident ident) t -> (ident, convertType t)



