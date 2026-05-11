import System.Exit        (exitFailure)
import System.IO
import System.Environment(getArgs)
import Lang.Par(pGen, myLexer)
import AST
import Evaluator

-- | Parse, type check, and interpret a program given by the @String@.

run :: String -> [String] -> IO ()
run s args = do
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
            let arg = if null args then Nothing else Just (read (head args))
            let v = evaluate arg cTree
            mapM_ (hPutStrLn stdout . show) v
            
       

-- | Main: read file passed by only command line argument and call 'run'.
main :: IO ()
main = do
  file <- getContents
  args <- getArgs
  run file args



