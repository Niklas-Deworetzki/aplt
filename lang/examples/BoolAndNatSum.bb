db = (b ~ distr Bool in 
  return (inj { left : Nat | right : Bool} {right : b})) in 

dn = (n ~ distr Nat in 
  return (inj { left : Nat | right : Bool} {left : n})) in 

dn + db 
