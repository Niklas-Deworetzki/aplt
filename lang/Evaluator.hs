module Evaluator where

import Data.Bifunctor

import AST

newtype Distr t = List t

data Value
  = VBool Bool
  | TInt Int
  | VProd [(Name, Value)]
  | VSum Name Value
  | VDist (Distr Value)
  | VExpr Expr

eval :: Expr -> Value
eval (Let x e1 e2) = eval $ substE x e1 e2
eval (App f a) =
  let (VExpr (Lambda x _ b)) = eval f
  in eval $ substE x a b
eval (AppT t e) =
  let (VExpr (LambdaT x e)) = eval e
  in eval $ substT x t e
eval (Prod es) =
  let es' = map (second eval) es
  in VProd es'
eval e = VExpr e



substE :: Name -> Expr -> Expr -> Expr
substE = undefined

substT :: Name -> Type -> Expr -> Expr
substT = undefined

