import Data.Maybe(fromJust)
import Control.Monad(guard,forever)
import Data.Void
import Text.Megaparsec
import Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L

main :: IO ()
main = forever $ getLine >>= putStrLn . parseCheckEval

parseCheckEval :: String -> String
parseCheckEval inp = case parse parseExpression "stdin" inp of
  Left _ -> "syntax error"
  Right exp -> case synth [] exp of
    Nothing -> "type error"
    Just _ -> show $ eval [] exp

data Type = Nat
          | Arr Type Type
          deriving (Eq, Show)

type Name = String

data Exp = Var Name
         | Zero
         | Succ Exp
         | Rec Exp Exp String String Exp
         | Lambda Name Type Exp
         | App Exp Exp
         deriving Show

type Context = [(Name, Type)]

type Env = [(Name, Val)]


synth :: Context -> Exp -> Maybe Type
synth ctx Zero = return Nat
synth ctx (Succ _) = return Nat
synth ctx (Var x) = lookup x ctx
synth ctx (Lambda x t e) = Arr t <$> synth (extend ctx x t) e
synth ctx (App arr arg) = do
  argT <- synth ctx arg
  arrT <- synth ctx arr
  case arrT of
    Arr iT oT | iT == argT -> return oT
    _ -> Nothing
synth ctx (Rec e base x y ind) = do
  guard $ check ctx e Nat
  baseType <- synth ctx base
  indType <- synth (extend (extend ctx x Nat) y baseType) ind
  guard $ baseType == indType
  return baseType


check :: Context -> Exp -> Type -> Bool
check ctx e t = Just t == synth ctx e



data N = Z | S N deriving Show
data Val = NatVal N
         | FunVal (Val -> Val)

instance Show Val where
  show (NatVal n) = show $ recursor n 0 (const (+ 1))
  show (FunVal _) = "fun"


eval :: Env -> Exp -> Val
eval rho (Var x) = fromJust $ lookup x rho
eval rho Zero = NatVal Z
eval rho (Succ e) = case eval rho e of
  NatVal n -> NatVal $ S n
eval rho (App e1 e2) = case eval rho e1 of
  FunVal f -> f $ eval rho e2
eval rho (Lambda x t e) = FunVal $ \arg ->
  eval (extend rho x arg) e
eval rho (Rec er e0 x y ei) =
  let NatVal n = eval rho er in
    recursor n (eval rho e0) $
      \b i -> let rho' = extend (extend rho x i) y (NatVal b) in eval rho' ei

recursor :: N -> t -> (N -> t -> t) -> t
recursor Z base ind = base
recursor (S n) base ind = ind n (recursor n base ind)

extend :: [(String, a)] -> String -> a -> [(String, a)]
extend m k v = (k, v) : m



type Parser = Parsec Void String

sc :: Parser ()
sc = L.space
  space1
  (L.skipLineComment "//")
  (L.skipBlockComment "/*" "*/")

lexeme :: Parser a -> Parser a
lexeme = L.lexeme sc

symbol :: String -> Parser String
symbol = L.symbol sc

parens :: Parser a -> Parser a
parens = between (symbol "(") (symbol ")")

identifier = lexeme $ (:) <$> letterChar <*> many alphaNumChar


parseExpression :: Parser Exp
parseExpression = foldl (<|>) (parens parseExpression)
  [ parseZero
  , parseSucc
  , parseLambda
  , parseApplication
  , parseRec
  , parseVariable
  ]
  where
    parseVariable = Var <$> identifier
    parseZero = Zero <$ symbol "z"
    parseSucc = Succ <$ symbol "s" <*> parseExpression
    parseLambda = Lambda <$> (symbol "\\" *> identifier) <*> (symbol ":" *> parseType) <*> (symbol "->" *> parseExpression)
    parseApplication = App <$> parseExpression <*> parseExpression
    parseRec = do
      symbol "rec"
      n <- parseExpression
      symbol "{"
      zero <- parseExpression
      symbol "|"
      x <- identifier
      y <- identifier
      symbol "->"
      ind <- parseExpression
      symbol "}"
      return $ Rec n zero x y ind
    parseType = foldl1 (<|>) [Nat <$ symbol "nat", Arr <$> parseType <*> (symbol "->" *> parseType), parens parseType] <?> "type"

