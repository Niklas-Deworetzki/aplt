{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TupleSections #-}
module AST where

import Control.Monad
import Control.Monad.Trans.Reader
import Control.Monad.Error.Class
import Data.Bifunctor
import Data.List(sort, nub)
import Lang.Abs
import Data.Tuple.Extra (secondM)

type Name = String

--data TypeClass = DistributableType | GenericType

data Expr
  = Var Name
  -- x = e1 in e2
  | Let Name Expr Expr
  -- \x :: T -> e
  | Lambda Name Type Expr
  -- f x
  | App Expr Expr
  -- /\x => e
--VARIANTWITHTYPECLASSES  | LambdaT TypeClass Name Expr
--VARIANTWITHTYPECLASSES  | AppT TypeClass Type Expr
  | LambdaT Name Expr
  -- e[T]
  | AppT Type Expr
  -- < l1: e1 , ln: en >
  | Prod [(Name, Expr)]
  -- e.name
  | Proj Name Expr
  -- inj T { l: e }
  | Sum Type Name Expr

  -- case e of T { l1 x1 -> e1 | ln xn -> en }
  | Case Expr Type [Pattern]
  -- Do we need the type in the case analysis? 

  -- True False
  | LitBool Bool
  -- if e1 e2 e3
  | If Expr Expr Expr


  -- Z
  | Zero
  -- S (e)
  | Succ Expr
  -- iter { e1 ; x. e2 } (e3)
  | Iter Expr Name Expr Expr

  -- inductive types are dead (for now)
  -- fold [t.T] ( e )
  -- | Fold Name Type Expr
  -- rec [t.T] T' {x.e1} (e2)
  -- | Rec Name Type Type Name Expr Expr

  -- distr [T]
  | Distr Type

  -- x ~ T in e
  | Bind Name Expr Expr

  -- filter e1 in e2
  -- in Guard e1 e2 , is it those things in e2 such that e1 is true or such that Ap e1 e2 is true? 
  | Guard Expr Expr

  -- e1 + e2
  | Plus Expr Expr

  -- return e
  | Return Expr
  deriving Show

data Pattern
  = Pattern Name Name Expr
  deriving Show

type Index = [(Name , Type)]


-- forall a . my t . (Cons: a (t a) | Nil: Unit) in Exp
-- my t . Unit | Unit * t
data Type
  = TBool
  | TNat
  | TArr Type Type

  -- ind types are dead
  -- | TInd Name Type
  | TSum  Index
  | TProd Index

  | TAll Name Type
  | TVar Name

  | TDist Type
  deriving Show


type TypeCheck = ReaderT Context (Either String)

data Context = Ctxt { typeVars :: TypeContext , termVars :: TermContext }

type TermContext = [(Name , Type)]
type TypeContext = [Name]

-- context extensions
emptyCtxt :: Context
emptyCtxt = Ctxt [] []

putTermInContext :: Name -> Type -> Context -> Context 
putTermInContext x t (Ctxt types terms) = Ctxt types ((x, t) : terms)

putTypeInContext :: Name -> Context -> Context
putTypeInContext t (Ctxt types terms) = Ctxt (t : types) terms

withTermVar  :: Name -> Type -> TypeCheck a -> TypeCheck a
withTermVar x t = local $ putTermInContext x t 

withTypeVar :: Name -> TypeCheck a -> TypeCheck a
withTypeVar t = local $ putTypeInContext t


-- Error messaging 
lookupTypeDeclaration :: Name -> TypeCheck Type
lookupTypeDeclaration varName = do 
    ctxt <- asks termVars
    let varLookup = lookup varName ctxt 
    let errorMsg  = varNotFoundMsg varName ctxt
    tryWithMessage varLookup errorMsg

isDeclaredType :: Name -> TypeCheck ()
isDeclaredType t = do 
  types <- asks typeVars 
  let isDeclared = elem t types
  unless isDeclared $ throwError $ 
   "The type " ++ show t ++ " was not found in the context " ++ show types 
tryWithMessage :: Maybe a -> String -> TypeCheck a
tryWithMessage Nothing  s = throwError s
tryWithMessage (Just x) _ = pure x

varNotFoundMsg :: Name -> TermContext -> String
varNotFoundMsg x ctx = "The term " ++ show x ++ " was not found in the context " ++ show ctx 

expectedEqualMsg :: (Show a) => a -> a -> String
expectedEqualMsg x y = "Expected " ++ show x ++ " and " ++ show y ++ " to be equal, but they're not"

expectedEqualError :: (Show a) => a -> a -> TypeCheck b
expectedEqualError s t = throwError $ expectedEqualMsg s t 

catchWhenEqualityChecking :: (Show b) => b -> b -> TypeCheck a -> TypeCheck a
catchWhenEqualityChecking s t c = catchError c $ \errorMsg -> throwError $ 
  errorMsg ++ "\n \nwhile checking the equality " ++ show s ++ " = " ++ show t

catchWhenEvaluating :: Expr -> TypeCheck a -> TypeCheck a
catchWhenEvaluating e c = catchError c $ \errorMsg -> throwError $ 
  errorMsg ++ "\n \nwhile synthesizing the type of " ++ show e

catchWhenChecking :: Expr -> Type -> TypeCheck a -> TypeCheck a
catchWhenChecking e t check = catchError check $ \errorMSG -> throwError $ 
  errorMSG ++ "\n \nwhile checking that " ++ show e ++ " has type " ++ show t

isFormError :: Type -> String -> TypeCheck Type
isFormError t expectedTypeName = throwError $ "Expected something of form " ++ expectedTypeName ++ ". Actual type: " ++ show t 

notOfTypeError :: Expr -> Type -> TypeCheck ()
notOfTypeError expr expectedType = throwError $ "Expected " ++ show expr ++ " to be of type " ++ show expectedType ++ " but it has the wrong form."

instance {-# OVERLAPS #-} MonadFail TypeCheck where
  fail e = throwError $ " Haskell error: " ++ e
  
isTDist :: Type -> TypeCheck Type
isTDist (TDist t) = return $ TDist t
isTDist t = isFormError t "TDist"

isTArr :: Type -> TypeCheck Type
isTArr (TArr t1 t2) = return $ TArr t1 t2
isTArr t = isFormError t "TArr"

isTAll :: Type -> TypeCheck Type
isTAll (TAll x t) = return $ TAll x t 
isTAll t = isFormError t "TAll"

isTProd :: Type -> TypeCheck Type
isTProd (TProd ts) = return $ TProd ts
isTProd t = isFormError t "TProd"

isTSum :: Type -> TypeCheck Type
isTSum (TSum ts) = return $ TSum ts
isTSum t = isFormError t "TSum"


-- Checker for equality of types
checkEqualityOfTypes :: Type -> Type -> TypeCheck ()
checkEqualityOfTypes TBool TBool = return ()
checkEqualityOfTypes TNat TNat   = return ()
checkEqualityOfTypes (TVar x) (TVar y) = do 
  unless (x == y) $ expectedEqualError x y 
  return ()
checkEqualityOfTypes (TDist l) (TDist r) = checkEqualityOfTypes l r 
checkEqualityOfTypes lType@(TProd ls) rType@(TProd rs) = 
  catchWhenEqualityChecking lType rType $ indexEquality ls rs 
checkEqualityOfTypes lType@(TSum  ls) rType@(TSum  rs) = 
  catchWhenEqualityChecking lType rType $ 
  indexEquality ls rs 
checkEqualityOfTypes lType@(TAll lx lt) rType@(TAll rx rt) = 
  catchWhenEqualityChecking lType rType $ 
  checkEqualityOfTypes lt (renameTypeVar rx lx rt)
checkEqualityOfTypes lType@(TArr ldom lcod) rType@(TArr rdom rcod) = 
  catchWhenEqualityChecking lType rType $ 
  checkEqualityOfTypes ldom rdom >> checkEqualityOfTypes lcod rcod
checkEqualityOfTypes s t = expectedEqualError s t 

isValidIndexType :: Index -> TypeCheck ()
isValidIndexType ss = do 
  let labels = map fst ss 
  let types = map snd ss 
  unless (containsNoDuplicates labels) $ throwError $ "Duplicates in the labels of " ++ show ss
  forM_ types $ isAType

isSubIndex :: Index -> Index -> TypeCheck ()
isSubIndex index1 index2 =  do 
  forM_ index1 $ \(label , typeIn1) -> do 
    let errorMsg = "the label " ++ show label ++ "is not found in " ++ show index2
    typeIn2 <- tryWithMessage (lookup label index2) errorMsg
    checkEqualityOfTypes typeIn1 typeIn2

indexEquality :: Index -> Index -> TypeCheck ()
indexEquality ss ts = catchWhenEqualityChecking ss ts $ do 
  isValidIndexType ss 
  isValidIndexType ts 
  isSubIndex ss ts 
  isSubIndex ts ss

-- Type Checker
typeCheck :: Expr -> Either String Type
typeCheck e = runReaderT (synthesizeType e) emptyCtxt

exprHasType :: Expr -> Type -> TypeCheck ()
-- exprHasType e t ensures that e has type t, and otherwise would throw an error. 
exprHasType expr@(Let x e1 e2) supposedType = catchWhenChecking expr supposedType $ do 
  t1 <- synthesizeType e1 
  withTermVar x t1 $ exprHasType e2 supposedType

exprHasType expr@(Lambda x t e) supposedType@(TArr t1 t2) = catchWhenChecking expr supposedType $ do 
  checkEqualityOfTypes t t1
  withTermVar x t1 $ exprHasType e t2

exprHasType expr@(Lambda _ _ _) supposedType = catchWhenChecking expr supposedType $ 
  notOfTypeError expr supposedType

exprHasType expr@(App f arg) supposedType = catchWhenChecking expr supposedType $ do 
  argType <- synthesizeType arg
  exprHasType f (TArr argType supposedType)

exprHasType expr@(LambdaT x e) supposedType@(TAll y t) = catchWhenChecking expr supposedType $ do 
  withTypeVar x $ exprHasType e (renameTypeVar y x t)
exprHasType expr@(LambdaT _ _) supposedType = catchWhenChecking expr supposedType $ 
  notOfTypeError expr supposedType

exprHasType expr@(Prod es) supposedType@(TProd ts) = catchWhenChecking expr supposedType $ do 
  let exprNames = sort $ map fst es 
  let typeNames = sort $ map fst ts 
  unless (exprNames == typeNames) $ throwError "names in product expression and types mismatch"
  forM_ exprNames \name -> do 
    e <- tryWithMessage (lookup name es) ("(SHOULD BE IMPOSSIBLE) Cannot find " ++ show name ++ " in " ++ show es)
    t <- tryWithMessage (lookup name ts) ("(SHOULD BE IMPOSSIBLE) Cannot find " ++ show name ++ " in " ++ show ts)
    exprHasType e t 
exprHasType expr@(Prod _) supposedType = catchWhenChecking expr supposedType $ 
  notOfTypeError expr supposedType

exprHasType expr@(Sum t x e) supposedType@(TSum ts) = catchWhenChecking expr supposedType $ do 
  checkEqualityOfTypes t supposedType
  eType <- tryWithMessage (lookup x ts) $ "couldn't find " ++ show x ++ " in " ++ show ts
  exprHasType e eType 

exprHasType expr@(Sum _ _ _) supposedType = catchWhenChecking expr supposedType $ 
  notOfTypeError expr supposedType


exprHasType expr@(Case e t patternList) supposedType = catchWhenChecking expr supposedType $ do
  checkEqualityOfTypes t supposedType
  --unless (t == supposedType) $ notOfTypeError expr supposedType
  eType <- synthesizeType e 
  TSum eCases <- isTSum eType 
  let patternLabels = sort [ l | Pattern l _ _ <- patternList]
  let eLabels = sort $ map fst eCases
  let labelsMatch = patternLabels == eLabels
  unless labelsMatch $ throwError $ 
    "the labels in " ++ show eLabels ++ " and " ++ show patternLabels ++ "don't match."
  forM_ patternList $ \(Pattern label varNamei expri) -> do 
    let labelLookup = lookup label eCases
    let errorMsg  = "the label " ++ show label ++ "was not found in the sum " ++ show eCases
    typei <- tryWithMessage labelLookup errorMsg
    withTermVar varNamei typei $ exprHasType expri t

exprHasType expr@(If condition trueCase falseCase) supposedType = catchWhenChecking expr supposedType $ do
  exprHasType condition TBool
  exprHasType trueCase supposedType
  exprHasType falseCase supposedType

exprHasType expr@(Iter baseCase varName inductiveCase n) supposedType = catchWhenChecking expr supposedType $ do 
  exprHasType n TNat
  exprHasType baseCase supposedType
  withTermVar varName supposedType $ exprHasType inductiveCase supposedType

exprHasType expr@(Bind x e1 e2) supposedType@(TDist t2) = catchWhenChecking expr supposedType $ do 
  e1Type <- synthesizeType e1 
  TDist t1 <- isTDist e1Type
  withTermVar x t1 $ exprHasType e2 t2
exprHasType expr@(Bind _ _ _) supposedType = catchWhenChecking expr supposedType $ 
  notOfTypeError expr supposedType

exprHasType expr@(Guard p e) supposedType = catchWhenChecking expr supposedType $ do
  exprHasType p TBool
  -- withTermVar varName supposedType $ exprHasType p TBool
  -- IF you want Guard to take a function e -> Bool
  exprHasType e supposedType

exprHasType expr@(Plus e1 e2) supposedType = catchWhenChecking expr supposedType $ do 
  exprHasType e1 supposedType
  exprHasType e2 supposedType

exprHasType expr@(Return e) supposedType@(TDist t) = catchWhenChecking expr supposedType $ exprHasType e t
exprHasType expr@(Return _) supposedType = catchWhenChecking expr supposedType $ 
  notOfTypeError expr supposedType

exprHasType e supposedType = catchWhenChecking e supposedType $ do 
  realType <- synthesizeType e
  checkEqualityOfTypes realType supposedType 

-- synthesizing types
synthesizeType :: Expr -> TypeCheck Type
synthesizeType (Var t) = lookupTypeDeclaration t

synthesizeType expr@(Let x e1 e2) = catchWhenEvaluating expr $ do 
  t1 <- synthesizeType e1
  withTermVar x t1 $ synthesizeType e2

synthesizeType expr@(Lambda x t e) = catchWhenEvaluating expr $ do 
  isAType t
  t' <- withTermVar x t $ synthesizeType e
  return $ TArr t t'

synthesizeType expr@(App f a) = catchWhenEvaluating expr $ do 
  fType <- synthesizeType f 
  (TArr t1 t2) <- isTArr fType
  exprHasType a t1 
  return t2

synthesizeType n@(LambdaT x e) = catchWhenEvaluating n $ do 
  t <- withTypeVar x $ synthesizeType e
  return $ TAll x t

synthesizeType n@(AppT t e) = catchWhenEvaluating n $ do 
  isAType t
  eType <- synthesizeType e
  (TAll x t') <- isTAll eType
  return $ substType x t t'

synthesizeType expr@(Prod es) = catchWhenEvaluating expr $ 
  TProd <$> forM es (secondM synthesizeType)

synthesizeType expr@(Proj k e) = catchWhenEvaluating expr $ do 
  eType <- synthesizeType e 
  (TProd ts) <- isTProd eType 
  let errormessage = "projected to " ++ show k ++ ", which isn't present in the product " ++ show ts
  tryWithMessage (lookup k ts) errormessage

synthesizeType expr@(Sum t _ _) = catchWhenEvaluating expr $ do 
  isAType t 
  (TSum _) <- isTSum t
  exprHasType expr t
  return t

synthesizeType expr@(Case _ t _) = catchWhenEvaluating expr $ do 
  isAType t 
  exprHasType expr t 
  return t

synthesizeType (LitBool _) = return TBool

synthesizeType n@(If condition trueCase falseCase) = catchWhenEvaluating n $ do 
  exprHasType condition TBool
  typeTrueCase <- synthesizeType trueCase
  catchError (exprHasType falseCase typeTrueCase) (\err -> throwError $
    "In an if expression, we need the types of " ++ (show trueCase) ++ " and " ++ (show falseCase) ++ " to be equal. We think the first types equals " ++ (show typeTrueCase) ++ "but when checking the second type is the same, we got the error " ++ err)
  return typeTrueCase

synthesizeType Zero = return TNat
synthesizeType (Succ e) = exprHasType e TNat >> return TNat

synthesizeType x@(Iter baseCase varName inductiveCase n) = catchWhenEvaluating x $ do 
  exprHasType n TNat
  baseCaseType <- synthesizeType baseCase
  catchError (withTermVar varName baseCaseType $ exprHasType inductiveCase baseCaseType) (\err -> throwError $
    "In an iterative construction, we infered the type of " ++ show baseCase ++ " to be " ++ show baseCaseType ++ "but then if we make " ++ show varName ++ " of that type, we also need " ++ show inductiveCase ++ " of the same type, but we got the following error" ++ err)
  return baseCaseType

synthesizeType x@(Distr t) = catchWhenEvaluating x $ do 
  isDistType t 
  return $ TDist t

synthesizeType n@(Bind x e1 e2) = catchWhenEvaluating n $ do 
  e1Type <- synthesizeType e1
  (TDist t) <- isTDist e1Type
  e2Type <- withTermVar x t $ synthesizeType e2
  isTDist e2Type

synthesizeType n@(Guard p e) = catchWhenEvaluating n $ do 
  -- CONFUSION shouldn't p be a function e -> Bool, so 
  -- Guard varName filterCondition expr
  -- withTermVar varName expr 
  exprHasType p TBool
  synthesizeType e >>= isTDist

synthesizeType n@(Plus e1 e2) = catchWhenEvaluating n $ do 
  t1 <- synthesizeType e1
  _ <- isTDist t1
  exprHasType e2 t1
  return t1
synthesizeType (Return e) = TDist <$> synthesizeType e

containsNoDuplicates :: Eq a => [a] -> Bool
containsNoDuplicates as = nub as == as 


isAType :: Type -> TypeCheck () 
isAType (TVar t)     = isDeclaredType t
isAType (TAll x t)   = withTypeVar x $ isAType t
isAType (TSum ss)    = isValidIndexType ss
isAType (TProd ps)   = isValidIndexType ps
isAType (TArr t1 t2) = isAType t1 >> isAType t2
isAType (TDist t)    = isAType t 
isAType TBool        = return ()
isAType TNat         = return ()

isDistType :: Type -> TypeCheck ()
isDistType TBool = return ()
isDistType TNat = return ()
isDistType (TSum ss)  = forM_ ss $ isDistType . snd
isDistType (TProd ps) = forM_ ps $ isDistType . snd
isDistType t = throwError $ "We expected " ++ show t ++ "to be a distType, but it's not"

substType :: Name -> Type -> Type -> Type
substType x s t = case t of
  TBool -> TBool
  TNat -> TNat
  (TDist t') -> TDist (substType x s t')
  (TArr t1 t2) -> TArr (substType x s t1) (substType x s t2)
  (TVar x') -> if x == x' then s else t
  -- (TInd x' t') -> if x == x' then t else TInd x' (substType x s t')
  (TAll x' t') -> if x == x' then t else TAll x' (substType x s t')
  -- Note that the above line is correct: If x = x', we don't want to substitute anything in t' and just return TAll x' t' (which is t). 
  (TSum ss)  -> TSum  $ map (second $ substType x s) ss
  (TProd ps) -> TProd $ map (second $ substType x s) ps

renameTypeVar :: Name -> Name -> Type -> Type
renameTypeVar oldName newName = substType oldName (TVar newName)


-- CONVERTER
-- Niklas wrote typechecker before grammar. 
-- This translates BFC datatypes to our datatypes (defined on top of this file)
convert :: Gen -> Expr
convert (Gen expr) = convertExp expr

convertExp :: PExp -> Expr
convertExp = \case
    PLet (Ident ident) e1 e2 -> Let ident (convertExp e1) (convertExp e2)
    PBind (Ident ident) e1 e2 -> Bind ident (convertExp e1) (convertExp e2)
    PIf e1 e2 e3 -> If (convertExp e1) (convertExp e2) (convertExp e3)
    PGuard e1 e2 -> Guard (convertExp e1) (convertExp e2)
    PLambda (Ident ident) t e -> Lambda ident (convertType t) (convertExp e)
    PLambdaT (Ident ident) e -> LambdaT ident (convertExp e)
    PPlus e1 e2 -> Plus (convertExp e1) (convertExp e2)
    PReturn e -> Return (convertExp e)
    PDistr t -> Distr (convertType t)
    PProj e (Ident ident) -> Proj ident (convertExp e)
    PAppT e t -> AppT (convertType t) (convertExp e)
    PProd es -> Prod (map (\(PLabExp (Ident ident) e) -> (ident, convertExp e)) es)
    PSum t (PLabExp (Ident ident) e) -> Sum (convertType t) ident (convertExp e)
    PCase e t patts -> Case (convertExp e) (convertType t) (map convertPattern patts)
    PRec e1 (Ident ident) e2 e3 -> Iter (convertExp e1) ident (convertExp e2) (convertExp e3)
    PApp e1 e2 -> App (convertExp e1) (convertExp e2)
    PBoolT -> LitBool True
    PBoolF -> LitBool False
    PVar (Ident ident) -> Var ident
    PZero -> Zero
    PSucc e -> Succ (convertExp e)
    PPar e -> convertExp e

    where convertPattern (PCaseExp (Ident ident1) (Ident ident2) e) = Pattern ident1 ident2 (convertExp e)

convertType :: PTyp -> Type
convertType = \case
    PTBool -> TBool
    PTNat -> TNat
    PTVar (Ident ident) -> TVar ident
    PTArr t1 t2 -> TArr (convertType t1) (convertType t2)
    PTDist t -> TDist (convertType t)
    PTProd members -> TProd (map convertMember members)
    PTSum members -> TSum (map convertMember members)
    PTAll (Ident ident) t -> TAll ident (convertType t)
    where
        convertMember = \case
            TMember (Ident ident) t -> (ident, convertType t)
            TMember1 (Ident ident) t -> (ident, convertType t)
