import System.Exit        (exitFailure)
import System.IO
import System.Environment(getArgs)
import Lang.Par(pGen, myLexer)
import AST
import Evaluator

-- | Parse, type check, and interpret a program given by the @String@.

run :: String -> [String] -> IO ()
run s args = do
  -- "s" is a program in surface syntax
  --print $ "content of file" ++ s
  case pGen (myLexer s) of
  -- pGen comes from BCNF generated stuff. 
    Left err  -> do
        hPutStrLn stderr "Syntax error:"
        hPutStrLn stderr err
        hFlush stderr
        exitFailure
    Right tree -> do 
       let cTree = convert tree
       -- cTree is our abstract syntax representation
       print $ "AST corresponding to file: " cTree
       -- converts parsed tree to the haskell AST. 
       case typecheck cTree of 
       -- TODO replace with typeCheck after refactoring
          Left message -> do
            hPutStrLn stderr message
          Right t -> do 
            let arg = if null args then Nothing else Just (read (head args))
            let v = evaluate arg cTree
            if null v then hPutStrLn stdout "No values in the distribution" else mapM_ (hPutStrLn stdout . show) v
            
       

-- | Main: read file passed by only command line argument and call 'run'.
main :: IO ()
main = do
  file <- getContents
  args <- getArgs
  run file args



