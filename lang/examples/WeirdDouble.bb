double = (\ n :: Nat -> (iter {Z ; a ; S S (a)} ((n)))) in 
double (S S S Z)

-- We need two pairs of brackets around n. One to make sure that iter has brackets in it's last argument, and one to transform the typeVar n from an Expr to Expr7. 
