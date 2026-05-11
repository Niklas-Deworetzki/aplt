Files that are "generated" somehow we ignore. 

AST defines the abstract syntax tree (a haskell algebraic datatype representing the abstract syntax of the expression language, and the type language) 
TODO AST also contains the type checker right now, which we wish to factor out. 

Evaluator defines how distributions behave and how typechecked programs evaluate to a value. It also defines the values. 

