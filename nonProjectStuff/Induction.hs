


data Nu (f :: * -> *)


gen :: rho -> (rho -> f rho) -> Nu f
gen = undefined

unfold :: Functor f => Nu f -> f (Nu f)
unfold = undefined



data S a t = S a t deriving Functor
type Stream a = Nu (S a)

first (S x s) = x
rest  (S x s) = s

ex1 :: (Int -> a) -> Stream a
ex1 f =
  -- gen 0 (\i -> S (f i) (i + 1))
  gen f (\s -> S (s 0) (\n -> s (n + 1)))

ex2 :: Stream a -> (Int -> a)
ex2 s 0 = first $ unfold s
ex2 s n = ex2 (rest $ unfold s) (n - 1)



mapStream :: (a -> b) -> Stream a -> Stream b
mapStream f x = gen x $ \s -> let S h t = unfold s in S (f h) t

zipStream :: Stream a -> Stream b -> Stream (a, b)
zipStream a b = gen (a, b) $ \(sa, sb) ->
  let S ah at = unfold sa
      S bh bt = unfold sb
  in S (ah, bh) (at, bt)

rs_latch :: (Stream Bool, Stream Bool) -> (Stream Bool, Stream Bool)
rs_latch (sa, sb) = undefined

