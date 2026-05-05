{-# LANGUAGE RankNTypes #-}

data Ex f = Ex (forall u. (forall t. f t -> u) -> u)

open :: Ex f -> (forall t. f t -> tau2) -> tau2
open (Ex f) = f

pack :: f rho -> Ex f
pack fa = Ex (\g -> g fa)




data Nu f = forall t. Nu (t -> f t, t)

gen :: tau2 -> (tau2 -> f tau2) -> Nu f
gen = flip $ curry Nu
--gen seed step = Nu (step, seed)

unfold :: Functor f => Nu f -> f (Nu f)
unfold (Nu (step, seed)) = fmap (\t -> Nu (step, t)) (step seed)


{-
data Nu f = forall t . Nu (t -> f t) t

gen :: tau -> (tau -> f tau) -> Nu f
gen = flip Nu

unfold (Nu step seed) = fmap (Nu step) (step seed)
-}


data Neu where
  App :: Neu -> NF -> Neu
  Var :: String -> Neu

data NF where
  Lam :: String -> NF -> NF
  Emb :: Neu -> NF

app :: NF -> NF -> NF
app (Lam x s) t = subst x t s
app (Emb s) t = Emb (App s t)

subst' :: String -> NF -> Neu -> NF
subst' x s (App f t) = let f' = subst' x s f
                           t' = subst x s t
                       in app f' t'
subst' x s (Var y) | x == y = s
subst' x s (Var y) = Emb $ Var y

subst :: String -> NF -> NF -> NF
subst x s (Lam y t) | x == y = Lam y t
subst x s (Lam y t) = Lam y (subst x s t)
subst x s (Emb t) = subst' x s t




