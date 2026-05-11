import Data.Function(fix)

newtype D = D (D -> D)


(·) :: D -> D -> D
x · y = case x of D f -> f y


k :: D
k = D $ \x -> D $ \y -> x

s :: D
s = D $ \x -> D $ \y -> D $ \z -> (x · z) · (y · z)

i :: D
i = D $ \x -> x



newtype Rec f = Rec (f (Rec f))

type Mu f = Rec f

rec :: Functor f => Mu f -> (f t -> t) -> t
rec (Rec t) f = f (fmap (`rec` f) t)

fold :: f (Mu f) -> Mu f
fold = Rec


type Nu f = Rec f

gen :: Functor f => rho -> (rho -> f rho) -> Nu f
gen seed step = Rec (fmap (`gen` step) (step seed))

unfold :: Nu f -> f (Nu f)
unfold (Rec f) = f

