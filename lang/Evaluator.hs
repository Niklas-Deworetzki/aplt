{-# LANGUAGE LambdaCase #-}
module Evaluator where

import Control.Monad
import Control.Monad.Reader
import Control.Monad.Logic
import Data.Bifunctor
import Data.Maybe(fromJust)
import Data.List(intercalate)

import AST

type Distr t = Logic t

fromList :: [a] -> Logic a
fromList xs = LogicT $ \cons nil -> foldr cons nil xs

interleaveN :: [Distr a] -> Distr a
interleaveN = msum

fairProduct :: [Distr a] -> Distr [a]
fairProduct = sequence

data Value
  = VBool Bool
  | VInt Int
  | VProd [(Name, Value)]
  | VSum Name Value
  | VDist (Distr Value)
  | VExpr Expr

instance Show Value where
  show (VBool v) = show v
  show (VInt v) = show v
  show (VProd vs) = concat
    [ "<"
    , intercalate ", " [k ++ "·" ++ show v | (k, v) <- vs]
    , ">"
    ]
  show (VSum k v) = concat
    [ "{"
    , k
    , "·"
    , show v
    , "}"
    ]
  show (VDist _) = "<distribution value>"
  show (VExpr e) = "(" ++ show e ++ ")"

type Env = [(Name, Value)]

type Eval = Reader Env

evaluate :: Maybe Int -> Expr ->  [Value]
evaluate arg e = case runReader (eval e) [] of
    (VDist d) -> maybe observeAll observeMany arg d
    v -> [v]


withEnv :: Name -> Value -> Eval a -> Eval a
withEnv x v = local ((x, v) :)

eval :: Expr -> Eval Value
eval (Var x) =
  asks (fromJust . lookup x)
eval (Let x e1 e2) = do
  v <- eval e1
  withEnv x v $ eval e2
eval (App f a) = eval f >>= \case
  (VExpr (Lambda x _ b)) -> do
    v <- eval a
    withEnv x v $ eval b
eval (AppT t e) = eval e >>= \case
  (VExpr (LambdaT x b)) ->
    eval $ substT x t b
eval (Prod es) = do
  es' <- forM es $ secondM eval
  return $ VProd es'
eval (Proj x e) = eval e >>= \case
  (VProd vs) -> return $ fromJust $ lookup x vs
eval (Sum _ x e) = do
  v <- eval e
  return $ VSum x v
eval (Case e _ ps) = eval e >>= \case
  (VSum n v) ->
    let (x, b) = findCase ps n
    in withEnv x v $ eval b
eval (LitBool b) =
  return $ VBool b
eval (If c t e) = eval c >>= \case
  (VBool b) ->
    eval (if b then t else e)
eval Zero =
  return $ VInt 0
eval (Succ e) = eval e >>= \case
  (VInt n) ->
    return $ VInt (n + 1)
eval (Iter eb x ei e) = eval e >>= \case
  (VInt n) ->
    let ind = \v -> withEnv x v $ eval ei
    in iterate (>>= ind) (eval eb) !! n -- apply ind n times to (eval eb)
eval (Distr t) =
  return $ VDist $ iterInstances t
eval (Bind x e1 e2) = eval e1 >>= \case
  (VDist d) -> do
    let unval = \(VDist d) -> d
    let f = \sample -> withEnv x sample $ eval e2
    d' <- traverse f d
    return $ VDist $ msum $ unval <$> d'
eval (Guard p e) = do
  p' <- eval p
  case p' of
    VBool True -> eval e
    VBool False -> return $ VDist mempty
eval (Plus e1 e2) = do
  e1' <- eval e1
  e2' <- eval e2
  case (e1', e2') of
    (VDist d1, VDist d2) -> return $ VDist $ interleave d1 d2
eval (Return e) =
  VDist . return <$> eval e
eval e = return $ VExpr e


findCase :: [Pattern] -> Name -> (Name, Expr)
findCase ((Pattern n x e):ps) name =
  if n == name then (x, e) else findCase ps name

iterInstances :: Type -> Distr Value
iterInstances TBool = fromList $ VBool <$> [True, False]
iterInstances TNat = fromList $ VInt <$> [0..]
iterInstances (TSum cs) = interleaveN [VSum l <$> iterInstances t | (l, t) <- cs]
iterInstances (TProd []) = return $ VProd []
iterInstances (TProd cs) =
  let names = map fst cs
      instances = fairProduct $ map (iterInstances . snd) cs
  in VProd . zip names <$> instances
iterInstances _ = error "iterInstances called on something that shouldn't be distributiable". 

substT :: Name -> Type -> Expr -> Expr
substT r tau = \case
  (Let x e1 e2) ->
    let e1' = substT r tau e1
        e2' = substT r tau e2
    in Let x e1' e2'
  (Lambda x t e) ->
    let e' = substT r tau e
        t' = subst r tau t
    in Lambda x t' e'
  (App f a) -> do
    let f' = substT r tau f
        a' = substT r tau a
      in App f' a'
  (LambdaT x e) ->
    if r == x then LambdaT x e
    else LambdaT x (substT r tau e)
  (AppT t e) -> do
    let t' = subst r tau t
        e' = substT r tau e
      in AppT t' e'
  (Prod es) ->
    Prod $ map (second $ substT r tau) es
  (Proj k e) ->
    Proj k (substT r tau e)
  (Sum t x e) ->
    let t' = subst r tau t
        e' = substT r tau e
    in Sum t' x e'
  (Case e t ps) ->
    let e' = substT r tau e
        t' = subst r tau t
        ps' = map (\(Pattern a b ec) -> Pattern a b $ substT r tau ec) ps
    in Case e' t' ps'
  (If c t f) ->
    let c' = substT r tau c
        t' = substT r tau t
        f' = substT r tau f
    in If c' t' f'
  (Succ e) ->
    Succ (substT r tau e)
  (Iter eb x ei e) ->
    let eb' = substT r tau eb
        ei' = substT r tau ei
        e' = substT r tau e
    in Iter eb' x ei' e'
  (Distr t) ->
    Distr $ subst r tau t
  (Bind x e1 e2) ->
    let e1' = substT r tau e1
        e2' = substT r tau e2
    in Bind x e1' e2'
  (Guard p e) ->
    let p' = substT r tau p
        e' = substT r tau e
    in Guard p' e'
  (Plus e1 e2) ->
    let e1' = substT r tau e1
        e2' = substT r tau e2
    in Plus e1' e2'
  (Return e) ->
    Return $ substT r tau e
  e -> e

