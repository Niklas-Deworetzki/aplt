repeat = /\ T => \t :: T -> (x ~ distr Nat in return t) in 
((repeat [Nat]) Z) + ((repeat [Nat]) (S (Z)))

