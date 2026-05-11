import System.Exit        (exitFailure)
import System.IO
import Lang.Par(pGen, myLexer)
import AST
import Evaluator

-- | Parse, type check, and interpret a program given by the @String@.

run :: String -> IO ()
run s = do
  case pGen (myLexer s) of
    Left err  -> do
        hPutStrLn stderr "Syntax error:"
        hPutStrLn stderr err
        hFlush stderr
        exitFailure
    Right tree -> do 
       let cTree = convert tree
       case typecheck cTree of 
          Left _ -> do
            hPutStrLn stderr "TYPE ERROR"
            -- hPutStrLn stderr err2
          Right t -> do 
            let v = evaluate cTree
            hPutStrLn stdout (show v)
       

-- | Main: read file passed by only command line argument and call 'run'.
main :: IO ()
main = do
  file <- getContents
  run file



