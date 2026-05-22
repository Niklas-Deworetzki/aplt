Installation requirements:
bnfc
alex
haskell 
happy

to install: 
run "make" in the top directory. 

to run examples:
run "./int <lang/examples/FILENAME.bb" where FILENAME.bb is one of the files in the examples directory

some explanation of the file structure:
The translation of some code in the bb language to haskell AST happens using Lang.cf, which is called by a bnf converter in MakeFile (which is in the main directory). 

AST defines the abstract syntax tree (a haskell algebraic datatype representing the abstract syntax of the expression language, and the type language) 

Evaluator defines how distributions behave and how typechecked programs evaluate to a value. It also defines the values. 

examples contains examples of the bb language. 

