isbiggerthenZero = \m :: Nat-> iter { False ; n ; True } (m) in 
isZero = \m :: Nat-> iter { True ; n ; False} (m) in 

b ~ distr Nat in
filter (isbiggerthenZero (b)) in
return b
