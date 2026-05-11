-- generator for 1-, 2- and 3-letter words


distr {
OneW : <L1 : {A : <> | B : <>  | C : <>  | D : <>  | E : <>  | F : <> }> | 
TwoW : <L1: {A : <>  | B : <>  | C : <>  | D : <>  | E : <>  | F : <> }, L2: {A : <>  | B : <>  | C : <>  | D : <>  | E : <>  | F : <> }> |
ThreeW : <L1: {A : <>  | B : <>  | C : <>  | D : <>  | E : <>  | F : <> }, L2 : {A : <> | B : <>  | C : <>  | D : <>  | E : <>  | F : <> }, L3 : {A : <>  | B : <>  | C : <>  | D : <>  | E : <>  | F : <> }> 
} 

-- distr < L1 : True , L2 : False >  
-- Suppose 
-- Letters = A | B | C |D |E |F
-- Words = oneW Letters | twoW Letters Letters | threeW Letters Letters Letters 
-- The above example then does this. 

