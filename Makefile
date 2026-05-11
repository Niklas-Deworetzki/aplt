# Generated in the PLT course by Katya. 
GHC        = ghc
HAPPY      = happy
HAPPY_OPTS = --info --ghc --coerce
ALEX       = alex
ALEX_OPTS  = --ghc
files = lang/Main.hs lang/Lang.cf lang/Lang/Abs.hs lang/Lang/Lex.hs lang/Lang/Par.hs lang/Lang/Print.hs lang/Lang/Test.hs

# List of goals not corresponding to file names.
.PHONY : all clean distclean
# Default goal.
all : int
# Rules for building the parser.
lang/Lang/Abs.hs lang/Lang/Lex.hs lang/Lang/Par.hs lang/Lang/Print.hs lang/Lang/Test.hs: lang/Lang.cf
	cd lang && bnfc -d Lang.cf
	# The above line translates the grammer to the haskell file. 
%.hs : lang/Lang/%.y
	${HAPPY} ${HAPPY_OPTS} $<
%.hs : lang/Lang/%.x
	${ALEX} ${ALEX_OPTS} $<
lang/Lang/Test : lang/Lang/Abs.hs lang/Lang/Lex.hs lang/Lang/Par.hs lang/Lang/Print.hs lang/Lang/Test.hs
	${GHC} ${GHC_OPTS} $@
# Rules for making an executable
int: $(files)
	cd lang && cabal install --installdir=. --install-method=copy --overwrite-policy=always
	mv lang/int .

# Rules for cleaning generated files.
clean :
	-rm -f lang/Lang/*.hi lang/Lang/*.o lang/Lang/*.log lang/Lang/*.aux lang/Lang/*.dvi int lang/*.hi lang/*.o
distclean : clean
	-rm -f lang/Lang/Abs.hs lang/Lang/Abs.hs.bak lang/Lang/ComposOp.hs lang/Lang/ComposOp.hs.bak lang/Lang/Doc.txt lang/Lang/Doc.txt.bak Jlang/avalette/ErrM.hs lang/Lang/ErrM.hs.bak lang/Lang/Layout.hs lang/Lang/Layout.hs.bak lang/Lang/Lex.x lang/Lang/Lex.x.bak lang/Lang/Par.y lang/Lang/Par.y.bak lang/Lang/Print.hs lang/Lang/Print.hs.bak lang/Lang/Skel.hs lang/Lang/Skel.hs.bak lang/Lang/Test.hs lang/Lang/Test.hs.bak lang/Lang/XML.hs lang/Lang/XML.hs.bak lang/Lang/AST.agda lang/Lang/AST.agda.bak lang/Lang/Parser.agda lang/Lang/Parser.agda.bak lang/Lang/IOLib.agda lang/Lang/IOLib.agda.bak lang/Lang/Main.agda lang/Lang/Main.agda.bak lang/Lang/Javalette.dtd lang/Lang/Javalette.dtd.bak lang/Lang/Test lang/Lang/Lex.hs lang/Lang/Par.hs lang/Lang/Par.info lang/Lang/ParData.hs Makefile
	-rmdir -pr lang/Lang/
