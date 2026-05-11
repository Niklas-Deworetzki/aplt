Installation requirements:
bnfc
haskell 

to install: 
run "make" in the top directory. 

to run examples:
run "./int <lang/examples/exn.bb" where n in [1,2,3,4,5]


some explanation of the file structure:
The translation of some code in the bb language to haskell AST happens using Lang.cf, which is called by a bnf converter in MakeFile (which is in the main directory). This generates some files, which we ignore. 


AST defines the abstract syntax tree (a haskell algebraic datatype representing the abstract syntax of the expression language, and the type language) 
TODO AST also contains the type checker right now, which we wish to factor out. 

Evaluator defines how distributions behave and how typechecked programs evaluate to a value. It also defines the values. 

examples contains examples of the bb language. 

the directory Lang is generated stuff. 
Lang.cf is a grammar file describing 

there's a cabal file 
main.hs is what runs the program. 
to run an example in the language, 
one should run
runhaskell Main.hs FILENAME.bb



