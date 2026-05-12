--x ~ distr Bool in (return (if x then Z else (S (Z))))
--x ~ distr Bool in (y ~ distr Bool in (return (<fst : x , snd : y >)) )
x ~ distr (<fst: Bool , snd: Bool>) in return x


--(if False then Z else (S (Z)))
-- do 
--  x <- distr Bool 
--  return (if x then Z else (S Z))

