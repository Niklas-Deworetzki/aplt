(/\ T => inj { Just : T | Nothing : <> } {Nothing : <> })

-- this still works:
--inj { Just : Bool | Nothing : <> } {Nothing : <> }
-- So I think there's a bug in the equality checking with TVar "T". 
