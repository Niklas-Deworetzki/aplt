-- iter {Z ; a ; S (S (S (a)))} (S (Z))


add = \x:: Nat -> \y:: Nat -> iter { y ; n ; S(n) } (x) in
mul = \x:: Nat -> \y:: Nat -> iter { Z ; n ; add(x)(n) } (y) in
pow = \x:: Nat -> \y:: Nat -> iter { S(Z) ; n ; mul(x)(n) } (y) in

d2 = S(S(Z)) in
d4 = pow(d2)(d2) in
d256 = pow(d4)(d4) in
pow(d256)(d2)

