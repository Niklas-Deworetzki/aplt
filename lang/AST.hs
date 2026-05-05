module AST where

import Control.Monad(guard)
import Data.Function((&))

type Name = String

data Expr
  = Var Name
  | Let Name Expr Expr
  | Lambda [(Name, Type)] Expr
  | App Expr [Expr]
  | LambdaT [Name] Expr
  | AppT [Type] Expr
  -- Literals
  | LitBool Bool
  -- ADTs
  | DataType Name [Constructor] Expr
  | Fold Type Expr [Pattern]
  | ConApp Name [Expr]
  | TypeDistr Type
  -- distributions
  | Bind Name Expr Expr
  | Guard Expr Expr
  | Plus Expr Expr
  | Return Expr

data Pattern
  = Pattern Name [Name] Expr

data Type
  = TBool
  | TFun [Type] Type

  | TData Name [Constructor]

  | TAll [Name] Type
  | TVar Name

  | TDist Type

data Constructor = Constructor
  { ctorName :: Name
  , ctorArgs :: [Type]
  }


type Gamma = [(Name, Type)]
type Delta = [Type]

synth :: Delta -> Gamma -> Expr -> Maybe Type
synth delta gamma exp = case exp of
  (Var x) -> lookup x gamma
  (App f args) -> do
    -- f is a function
    (TFun tExpected tRes) <- synth delta gamma f
    -- parameter and argument count matches
    guard $ length tExpected == length args
    -- parameter and argument types match
    sequence $ zipWith (check delta gamma) args tExpected
    return tRes
  (Lambda pars b) -> do
    let gamma' = pars ++ gamma
    tRet <- synth delta gamma' b
    let tPars = map snd pars
    return $ TFun tPars tRet
  (Let x e1 e2) -> do
    tBound <- synth delta gamma e1
    let gamma' = (x, tBound) : gamma
    synth delta gamma' e2
  (LitBool _) -> return TBool

  (LambdaT xs e) -> do
    let delta' = (map TVar xs) ++ delta
    t <- synth delta' gamma e
    return $ TAll xs t
  (AppT ts e) -> do
    -- Ensure all type args are fine
    ts' <- sequence $ map (okType delta) ts
    (TAll xs t) <- synth delta gamma e
    guard $ length ts' == length xs
    -- Substitute all type variables
    return $ foldl (&) t (zipWith tsubst xs ts')

  (DataType name cons e) -> do
    let delta' = _
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
okType delta t = undefined
-- TODO: Return TData if TVar with name in env

equiv :: Type -> Type -> Bool
equiv = undefined

tsubst :: Name -> Type -> Type -> Type
tsubst x s t = undefined -- TODO: subst x for s in t

findConstructor :: Delta -> Name -> Maybe (Constructor, Type)
findConstructor delta name = undefined -- TODO: find constructor with name

