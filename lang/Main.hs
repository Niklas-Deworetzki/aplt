import System.Exit        (exitFailure)
import System.IO
import Lang.Par(pGen, myLexer)

-- | Parse, type check, and interpret a program given by the @String@.

check :: String -> IO ()
check s = do
  case pGen (myLexer s) of
    Left err  -> do
        hPutStrLn stderr "Syntax error"
        hPutStrLn stderr err
        hFlush stderr
        exitFailure
    Right tree -> do 
        hPutStrLn stderr "OK" 
        hFlush stderr
        return ()

-- | Main: read file passed by only command line argument and call 'check'.

main :: IO ()
main = do
  file <- getContents
  check file



