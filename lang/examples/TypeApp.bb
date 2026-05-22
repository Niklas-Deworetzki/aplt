just = /\ T => \t :: T -> inj { Just : T | Nothing : <> } {Just : t} in 
(just [Nat]) Z

-- Also works, but stupid: 
--just = /\ t => \t :: t -> inj { Just : t | Nothing : <> } {Just : t} in 
