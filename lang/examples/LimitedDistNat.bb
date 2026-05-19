--iter { < Z : Nat , distr <> : Distr Nat >  ; x ; { first : x | oneMore : <>}}



rangeHelper = (\n :: Nat  -> iter { 
  < currentNumber : Z , currentDistr : return Z > ; 
  x ; 
  < currentNumber : S (x .currentNumber) , 
    currentDistr  : (return S(x .currentNumber) + (x . currentDistr) ) > } (n)) in 

range = (\ n :: Nat -> (rangeHelper (n)) . currentDistr) in 

range S((S (S (S (S (S (Z)))))))

--fin 0 = <>
--fin (S n) = {first : fin n | newone : <> }
