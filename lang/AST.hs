{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE TupleSections #-}
module AST where

import Control.Monad
import Control.Monad.Trans.Reader
import Control.Monad.Trans.Class (lift)
import Control.Monad.Error.Class
import Data.Bifunctor
import Data.Maybe(fromJust)
import Data.List(sort, sortOn)
import Lang.Abs

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

-- forall a . my t . (Cons: a (t a) | Nil: Unit) in Exp
-- my t . Unit | Unit * t
data Type
  = TBool
  | TNat
  | TArr Type Type

  -- ind types are dead
  -- | TInd Name Type
  | TSum  [(Name, Type)]
  | TProd [(Name, Type)]

  | TAll Name Type
  | TVar Name

  | TDist Type
  deriving Show

instance Eq Type where
  t1 == t2 = matchTypes [] t1 t2

matchTypes :: [(Name, Name)] -> Type -> Type -> Bool
matchTypes _ TBool TBool = True
matchTypes _ TNat TNat = True
matchTypes ms (TVar l)     (TVar r)     = lookup l ms == Just r
matchTypes ms (TDist l)    (TDist r)    = matchTypes  ms l r
matchTypes ms (TProd ls)   (TProd rs)   = matchLabels ms ls rs
matchTypes ms (TSum  ls)   (TSum  rs)   = matchLabels ms ls rs
matchTypes ms (TAll lx lt) (TAll rx rt) = matchTypes  ((lx , rx) : ms) lt rt
matchTypes ms (TArr la lr) (TArr ra rr) = matchTypes  ms la ra && matchTypes ms lr rr
matchTypes _ _ _ = False

matchLabels :: [(Name, Name)] -> [(Name, Type)] -> [(Name, Type)] -> Bool
matchLabels ms ls rs = and $ zipWith f (sortOn fst ls) (sortOn fst rs)
  where f (ll, lt) (rl, rt) = ll == rl && matchTypes ms lt rt

type Check     = ReaderT (Gamma, Delta) Maybe
type TypeCheck = ReaderT Context (Either String)

-- Temporary measures to recast stuff
pairToContext :: (Gamma, Delta) -> Context
pairToContext (g , d) = Ctxt d g 

contextToPair :: Context -> (Gamma , Delta)
contextToPair (Ctxt d g) = (g ,d)

maybeToEither :: Maybe a -> Either String a
maybeToEither Nothing  = Left "nothing"
maybeToEither (Just a) = Right a

checkToTypeCheck :: Check a -> TypeCheck a
checkToTypeCheck (ReaderT f) = ReaderT ( maybeToEither . (f . contextToPair))
-- end temporary measures


--type Check = ReaderT (Gamma, Delta) (Either String)
-- Gamma contains term variables, Delta type variables.
-- Check a can read Gamma and Delta and returns Either an error message or a type

type Gamma = [(Name, Type)]
type Delta = [Name]

data Context = Ctxt { typeVars :: TypeContext , termVars :: TermContext }

type TermContext = [(Name , Type)]
type TypeContext = [Name]

emptyCtxt :: Context
emptyCtxt = Ctxt [] []

-- Taken from https://hackage-content.haskell.org/package/extra-1.8.1/docs/src/Data.Tuple.Extra.html#secondM
secondM :: Functor m => (b -> m b') -> (a, b) -> m (a, b')
secondM f ~(a,b) = (a,) <$> f b

gamma :: Check Gamma
gamma = asks fst

delta :: Check Delta
delta = asks snd

tryWithMessage :: Maybe a -> String -> TypeCheck a
tryWithMessage Nothing  s = throwError s
tryWithMessage (Just x) _ = pure x

varNotFoundMsg :: Name -> Gamma -> String
varNotFoundMsg x ctx = "We expected the term " ++ show x ++ " to be in the termcontext " ++ show ctx ++ "but it's not."

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
   "We expected the type " ++ show t ++ " to be in the typecontext " ++ show types ++ " but it's not."

lookupGamma :: Name -> Check Type
lookupGamma x = do
  g <- gamma
  maybe mzero return (lookup x g)

putTermInContext :: Name -> Type -> Context -> Context 
putTermInContext x t (Ctxt types terms) = Ctxt types ((x, t) : terms)
-- DANGER what about alpha-conversion. We could now have added the same variable twice.

putTypeInContext :: Name -> Context -> Context
putTypeInContext t (Ctxt types terms) = Ctxt (t : types) terms

withTermVar  :: Name -> Type -> TypeCheck a -> TypeCheck a
withTermVar x t = local $ putTermInContext x t 

withTypeVar :: Name -> TypeCheck a -> TypeCheck a
withTypeVar t = local $ putTypeInContext t

withGamma :: Name -> Type -> Check a -> Check a
withGamma x t = local $ first ((x, t) :)

withDelta :: Name -> Check a -> Check a
withDelta t = local $ second (t :)

catchWhenEvaluating :: (Show b) => b -> TypeCheck a -> TypeCheck a
catchWhenEvaluating x c = catchError c $ \e -> throwError $ e ++ "\n while evaluating " ++ show x

typecheck :: Expr -> Either String Type
typecheck e = case runReaderT (synth e) ([], []) of
  Just t -> Right t
  Nothing -> Left "type error"

typeCheck :: Expr -> Either String Type
typeCheck e = runReaderT (synthesizeType e) emptyCtxt

synthesizeType :: Expr -> TypeCheck Type
synthesizeType (Var t) = lookupTypeDeclaration t
synthesizeType n@(Let x e1 e2) = catchWhenEvaluating n $ do 
  t1 <- synthesizeType e1
  withTermVar x t1 $ synthesizeType e2

synthesizeType n@(Lambda x t e) = catchWhenEvaluating n $ do 
  isAType t
  t' <- withTermVar x t $ synthesizeType e
  return $ TArr t t'

synthesizeType n@(App f a) = catchWhenEvaluating n $ do 
  fType <- synthesizeType f 
  case fType of 
    (TArr t1 t2) -> exprHasType a t1 >> return t2
    _ -> throwError $ "We want to apply the expression " ++ show f ++ " but we think it is not a function type."

synthesizeType n@(LambdaT x e) = catchWhenEvaluating n $ do 
  t <- withTypeVar x $ synthesizeType e
  return $ TAll x t

synthesizeType n@(AppT t e) = catchWhenEvaluating n $ do 
-- DANGER is this not flipped from the book? shouldn't AppT take first 
  isAType t
  -- Feature maybe do a nice catch here. 
  eType <- synthesizeType e
  case eType of 
    (TAll x t') -> return $ substType x t t'
    _ -> throwError $ "We wanted to apply the expression " ++ show e ++ "to a type, we think it has type " ++ show eType ++ " which we think is not a TAll type."

synthesizeType n@(Prod es) = catchWhenEvaluating n $ TProd <$> forM es (secondM synthesizeType)

synthesizeType n@(Proj k e) = catchWhenEvaluating n $ do 
  eType <- synthesizeType e 
  case eType of 
    (TProd ts) -> do 
      let errormessage = "projected to " ++ show k ++ " in the product of types " ++ show ts ++ " which we couldn't find"
      tryWithMessage (lookup k ts) errormessage
    _ -> throwError $ "We wanted " ++ show e ++ " to be a prodType, but we think it has type " ++ show eType

synthesizeType n@(Sum t x e) = catchWhenEvaluating n $ do 
  isAType t 
  case t of 
    TSum ss -> do 
      let errorMsg = "Wanted to put something of label " ++ show x ++ " in a sum type over " ++ show ss ++ "but it doesn't appear in the list. "
      eType <- tryWithMessage (lookup x ss) errorMsg
      exprHasType e eType
      return t
    _ -> throwError $ "We wanted " ++ show t ++ "to be a sumtype, but it's not."

synthesizeType n@(Case e t patternList) = catchWhenEvaluating n $ do 
  isAType t 
  eType <- synthesizeType e 
  case eType of 
    TSum eCases -> do 
      let casesMatch = sort [l | Pattern l _ _ <- patternList] == sort (map fst eCases)
      unless casesMatch $ throwError $ "the cases in " ++ show eCases ++ " and " ++ show patternList ++ "don't match."
      forM_ patternList $ \(Pattern label varName expr) -> do 
        let varLookup = lookup varName eCases
        let errorMsg  = varNotFoundMsg varName eCases
        varVal <- tryWithMessage varLookup errorMsg
        withTermVar varName varVal $ exprHasType expr t
      return t
    _ -> throwError $ "We wanted to case split on " ++ show e ++ "but instead of a sum type, we think it has type" ++ show eType

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
  case e1Type of 
    TDist t -> do 
      e2Type <- withTermVar x t $ synthesizeType e2
      isTDist e2Type
    _ -> throwError $ "In a distribution binding, we infered the type of " ++ show e1 ++ " to be " ++ show e1Type ++ " but it should be a Distribution type"
synthesizeType n@(Guard p e) = catchWhenEvaluating n $ do 
  -- CONFUSION shouldn't p be a function e -> Bool, so 
  -- Guard varName filterCondition expr
  -- withTermVar varName expr 
  exprHasType p TBool
  synthesizeType e >>= isTDist
synthesizeType n@(Plus e1 e2) = catchWhenEvaluating n $ do 
  t1 <- synthesizeType e1
  isTDist t1
  exprHasType e2 t1
  return t1
synthesizeType (Return e) = TDist <$> synthesizeType e

synth :: Expr -> Check Type
synth exp = case exp of
  (Var x) -> lookupGamma x
  (Let x e1 e2) -> do
    t1 <- synth e1
    withGamma x t1 $ synth e2
  (Lambda x t e) -> do
    okType t
    t' <- withGamma x t $ synth e
    return $ TArr t t'
  (App f a) -> do
    (TArr ta tr) <- synth f
    check a ta
    return tr
  (LambdaT x e) -> do
    t <- withDelta x $ synth e
    return $ TAll x t
  (AppT t e) -> do
    okType t
    (TAll x t') <- synth e
    return $ substType x t t'
  (Prod es) ->
    TProd <$> forM es (secondM synth)
  (Proj k e) -> do
    (TProd ts) <- synth e
    lift $ lookup k ts
  (Sum t x e) -> do
    okType t -- t has to be a type
    let TSum ss = t -- and a sum type
    tk <- lift (lookup x ss)
    check e tk
    return t
  (Case e t ps) -> do
    okType t
    (TSum ss) <- synth e -- scrutinized must be sum
    guard $ sort [l | Pattern l _ _ <- ps] == sort (map fst ss) -- check that sum and patterns have same labels
    -- for each pattern, bind to var and check exp for given type
    forM_ ps $ \(Pattern lk xk ek) -> do
      withGamma xk (fromJust $ lookup lk ss) $ check ek t
    return t
  (LitBool _) -> return TBool
  (If c t f) -> do
    check c TBool
    tau <- synth t
    check f tau
    return tau
  Zero -> return TNat
  (Succ e) -> check e TNat >> return TNat
  (Iter eb x ei e) -> do
    check e TNat
    tau <- synth eb
    withGamma x tau $ check ei tau
    return tau
  {-(Fold t tau e) -> do
    let tind = TInd t tau
    okType tind
    check e $ substType t tind tau
    return tind
  (Rec t tau tauR x e1 e2) -> do
    let tind = TInd t tau
    okType tind
    check e2 tind
    withGamma x (substType t tauR tau) $ check e1 tauR
    return tauR -}
  (Distr t) -> do
    distType t
    return $ TDist t
  (Bind x e1 e2) -> do
    (TDist t) <- synth e1
    withGamma x t $ synth e2 >>= isDistT
  (Guard p e) -> do
    check p TBool
    synth e >>= isDistT
  (Plus e1 e2) -> do
    t <- synth e1
    void $ isDistT t
    check e2 t
    return t
  (Return e) ->
    TDist <$> synth e

check :: Expr -> Type -> Check ()
check exp t = do
  t' <- synth exp
  guard $ t == t'

exprHasType :: Expr -> Type -> TypeCheck ()
exprHasType e supposedType = do 
  realType <- synthesizeType e
  unless (realType == supposedType) $ throwError $ 
    (show e) ++ " should have type " ++ (show supposedType) ++ " but has type " ++ (show realType) ++ " which we think aren't equal."


isAType :: Type -> TypeCheck () 
isAType (TVar t)     = isDeclaredType t
isAType (TAll x t)   = withTypeVar x $ isAType t
isAType (TSum ss)    = forM_ ss $ isAType . snd
isAType (TProd ps)   = forM_ ps $ isAType . snd
isAType (TArr t1 t2) = isAType t1 >> isAType t2
isAType (TDist t)    = isAType t 
isAType TBool        = return ()
isAType TNat         = return ()


okType :: Type -> Check ()
okType (TVar x) = delta >>= guard . elem x
-- okType (TInd x t) = withDelta x $ okType t
okType (TAll x t) = withDelta x $ okType t
okType (TSum ss)  = forM_ ss $ okType . snd
okType (TProd ps) = forM_ ps $ okType . snd
okType (TArr t1 t2) = okType t1 >> okType t2
okType (TDist t) = okType t 
okType TBool = return ()
okType TNat = return ()

isTDist :: Type -> TypeCheck Type
isTDist (TDist t) = return $ TDist t
isTDist t = throwError $ "We excpected" ++ (show t) ++ " to be of the form TDist t, but it's not."

isDistT :: Type -> Check Type
isDistT (TDist t) = return $ TDist t
isDistT _ = mzero

distType :: Type -> Check ()
distType TBool = return ()
distType TNat = return ()
distType (TSum ss)  = forM_ ss $ distType . snd
distType (TProd ps) = forM_ ps $ distType . snd
distType (TVar x) = delta >>= guard . elem x
distType _ = mzero

isDistType :: Type -> TypeCheck ()
isDistType TBool = return ()
isDistType TNat = return ()
isDistType (TSum ss)  = forM_ ss $ isDistType . snd
isDistType (TProd ps) = forM_ ps $ isDistType . snd
isDistType (TVar t) = do 
  error "This should have a checker to make sure we only do distributable types/types with a sampling or something"
  types <- asks typeVars 
  let isDeclared = elem t types
  unless isDeclared $ throwError $ 
   "We expected " ++ show t ++ " to be in the typecontext " ++ show types ++ ", but it's not (this came up when checking it's a disttype, not sure that should happen in the first place)."

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
  (TSum ss)  -> TSum  $ map (second $ substType x s) ss
  (TProd ps) -> TProd $ map (second $ substType x s) ps




-- CONVERTER
-- Niklas wrote typechecker before grammar. 
-- This translates BFC datatypes to our datatypes (defined on top of this file)
convert :: Gen -> Expr
convert (Gen exp) = convertExp exp

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
    -- DANGER: why do the arguments switch. 
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
