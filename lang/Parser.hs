module Parser where

import Control.Monad (void, liftM2, forM_)
import Data.Void
import System.Environment (getArgs)

import Text.Megaparsec
import Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L

import AST

type Parser = Parsec Void String

main = do
  args <- getArgs
  forM_ args $ \arg -> do
    putStrLn arg
    txt <- readFile arg
    case doParse arg txt of
      (Right prog) -> print prog
      (Left err) -> putStrLn $ errorBundlePretty err

doParse = parse (pExpr <* eof)

sc :: Parser ()
sc = L.space space1 empty empty

lexeme :: Parser a -> Parser a
lexeme = L.lexeme sc

symbol :: String -> Parser ()
symbol = void . L.symbol sc

mellan :: String -> String -> Parser a -> Parser a
mellan l r = between (symbol l) (symbol r)

--------------------------------------------------
-- Identifiers
--------------------------------------------------

kwFromAlts = choice . map symbol

kwLambda = kwFromAlts ["lambda", "\\"]
kwArrow = kwFromAlts ["->", "."]
kwLambdaT = kwFromAlts ["Lambda", "/\\"]
kwArrowT = kwFromAlts ["=>", "."]
kwLabel = kwFromAlts [":", "·"]
kwAlternatives = kwFromAlts [",", "|"]

typeArgs = mellan "[" "]"
exprArgs = mellan "{" "}"

reserved :: [String]
reserved =
  [ "in", "inj", "case", "fold", "rec", "if"
  , "dist", "filter", "return"
  , "True", "False"
  , "Bool", "Distr", "Arr"
  , "forall", "my"
  ]

identifier :: Parser String
identifier = lexeme $ do
  x <- letterChar
  xs <- many alphaNumChar
  let name = x:xs
  if name `elem` reserved
    then fail "reserved word"
    else return name

--------------------------------------------------
-- Expressions
--------------------------------------------------

pExpr :: Parser Expr
pExpr = choice
  [ pLambda
  , pApp
  , pLambdaT
  , pAppT
  , pProj
  , pExp
  ]

pExp :: Parser Expr
pExp = choice
  [ try pVar
  , try pLet
  , try pBind
  , pProd
  , pSum
  , pCase
  , pLiteral
  , pFold
  , pRec
  , pDistr
  , pBind
  , pGuard
  , pReturn
  , mellan "(" ")" pExpr
  , try pPlus
  ]

pVar :: Parser Expr
pVar = Var <$> identifier

pLet :: Parser Expr
pLet = do
  x <- identifier
  e1 <- pExpr
  e2 <- symbol "in" *> pExpr
  return $ Let x e1 e2

pLambda :: Parser Expr
pLambda = do
  void kwLambda
  x <- identifier
  t <- symbol ":" *> pType
  void kwArrow
  e <- pExpr
  return $ Lambda x t e

pApp :: Parser Expr
pApp = App <$> pExpr <*> pExpr

pLambdaT :: Parser Expr
pLambdaT = do
  void kwLambdaT
  x <- identifier
  void kwArrowT
  e <- pExpr
  return $ LambdaT x e

pAppT :: Parser Expr
pAppT = do
  e <- pExpr
  t <- typeArgs pType
  return $ AppT t e

pProd :: Parser Expr
pProd = Prod <$> mellan "<" ">" (pLabelWithExpression `sepBy` kwAlternatives)

pSum :: Parser Expr
pSum = do
  symbol "inj"
  t <- pType
  symbol "{"
  l <- identifier <* kwLabel
  e <- pExpr
  symbol "}"
  return $ Sum t l e

pProj :: Parser Expr
pProj = flip Proj <$> pExpr <*> (symbol "." *> identifier)

pCase :: Parser Expr
pCase = do
  symbol "case"
  e <- pExpr
  symbol "of"
  t <- pType
  ps <- exprArgs (pPattern `sepBy` kwAlternatives)
  return $ Case e t ps
  where
    pPattern = Pattern <$> identifier <*> (identifier <* kwLabel) <*> pExpr

pLabelWithExpression :: Parser (Name, Expr)
pLabelWithExpression =
  (,) <$> (identifier <* kwLabel) <*> pExpr

pLiteral :: Parser Expr
pLiteral = choice
  [ LitBool True <$ symbol "True"
  , LitBool False <$ symbol "False"
  ]

pIf :: Parser Expr
pIf = do
  symbol "if"
  If <$> pExpr <*> pExpr <*> pExpr

pFold :: Parser Expr
pFold = do
  symbol "fold"
  symbol "["
  t <- identifier
  symbol "."
  tau <- pType
  symbol "]"
  e <- mellan "(" ")" pExpr
  return $ Fold t tau e

pRec :: Parser Expr
pRec = do
  symbol "rec"
  symbol "["
  t <- identifier
  symbol "."
  tau <- pType
  symbol "]"
  tau' <- pType
  symbol "{"
  x <- identifier
  symbol "."
  e1 <- pExpr
  symbol "}"
  e2 <- mellan "(" ")" pExpr
  return $ Rec t tau tau' x e1 e2

pDistr :: Parser Expr
pDistr = do
  symbol "dist"
  Distr <$> typeArgs pType

pBind :: Parser Expr
pBind = do
  x <- identifier
  symbol "~"
  e1 <- pExpr
  symbol "in"
  e2 <- pExpr
  return $ Bind x e1 e2

pGuard :: Parser Expr
pGuard = do
  symbol "filter"
  e1 <- pExpr
  symbol "in"
  e2 <- pExpr
  return $ Guard e1 e2

pPlus :: Parser Expr
pPlus = do
  e1 <- pExpr
  symbol "+"
  e2 <- pExpr
  return $ Plus e1 e2

pReturn :: Parser Expr
pReturn = Return <$> (symbol "return" *> pExpr)


--------------------------------------------------
-- Types
--------------------------------------------------

pType :: Parser Type
pType = choice
  [ TBool <$ symbol "Bool"
  , pTProd
  , try pTSum
  , TVar <$> identifier
  , TDist <$> (symbol "Distr" *> pType)
  , pTArrow
  , pTInd
  , pTAll
  , mellan "(" ")" pType
  ]

pTProd :: Parser Type
pTProd = TProd <$> mellan "<" ">" (pTypeWithLabel `sepBy` kwAlternatives)

pTSum :: Parser Type
pTSum = TSum <$> pTypeWithLabel `sepBy2` symbol "|"
  where
    sepBy2 p sep = liftM2 (:) p (some (sep >> p))

pTArrow :: Parser Type
pTArrow = do
  symbol "Arr"
  TArr <$> pType <*> pType

pTInd :: Parser Type
pTInd = do
  symbol "my"
  x <- identifier
  symbol "."
  t <- pType
  return $ TInd x t

pTAll :: Parser Type
pTAll = do
  symbol "forall"
  x <- identifier
  symbol "."
  t <- pType
  return $ TAll x t


pTypeWithLabel :: Parser (Name, Type)
pTypeWithLabel = (,) <$> identifier <*> (kwLabel *> pType)

