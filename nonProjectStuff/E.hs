import Data.Maybe(fromMaybe)


data Type = Num
          | Str
          | Arr Type Type
          deriving (Show, Eq)

data Exp = NumLit Int
         | StrLit String
         | Plus Exp Exp
         | Concat Exp Exp
         | Length Exp
         | Var String
         | Let Exp String Exp
         | Lambda String Type Exp
         | App Exp Exp
         deriving (Show, Eq)

type Env = [(String, Type)]

synth :: Env -> Exp -> Maybe Type
synth ctx e = case e of
  (NumLit _) -> return Num
  (StrLit _) -> return Str
  (Plus e1 e2) -> if' (check ctx e1 Num && check ctx e2 Num) $ return Num
  (Concat e1 e2) -> if' (check ctx e1 Str && check ctx e2 Str) $ return Str
  (Length e) -> if' (check ctx e Str) $ return Num
  (Var x) -> lookup x ctx
  (Let e1 x e2) -> do
    t <- synth ctx e1
    synth (extend ctx x t) e2
  (Lambda x t e) -> Arr t <$> synth (extend ctx x t) e
  (App f e) -> synth ctx f >>= \t -> case t of
    Arr t1 t2 -> if' (check ctx e t1) $ return t2
    _ -> Nothing

check :: Env -> Exp -> Type -> Bool
check ctx e t = Just t == synth ctx e

eval :: Exp -> Exp
eval e = case e of
  (Plus e1 e2) -> let NumLit n1 = eval e1
                      NumLit n2 = eval e2
                  in NumLit $ n1 + n2
  (Concat e1 e2) -> let StrLit s1 = eval e1
                        StrLit s2 = eval e2
                    in StrLit $ s1 ++ s2
  (Length e) -> let StrLit s = eval e in NumLit $ length s
  (Let e1 x e2) -> let v = eval e1 in eval $ subst x v e2
  _ -> e

subst :: String -> Exp -> Exp -> Exp
subst x s e = case e of
  (Plus e1 e2) -> Plus (subst x s e1) (subst x s e2)
  (Concat e1 e2) -> Concat (subst x s e1) (subst x s e2)
  (Length e) -> Length $ subst x s e
  (Var y) -> if x == y then s else e
  (Let e1 y e2) -> let e1' = subst x s e1 in
                     if x == y then Let e1' y e2
                     else Let e1' y (subst x s e2)
  _ -> e

if' :: Bool -> Maybe a -> Maybe a
if' True = id
if' False = const Nothing

extend :: Env -> String -> Type -> Env
extend ctx x t = (x, t) : ctx

