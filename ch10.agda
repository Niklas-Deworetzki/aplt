module ch10 where 
--TODO fix some stupid _,_ bug
open import Agda.Builtin.Sigma
open import Function
open import Data.Sum renaming (inj₁ to inl ; inj₂ to inr)
open import Data.Product renaming (_×_ to _AND_)
open import Data.Tree.AVL.Map
open import Data.String
open import Data.String.Properties renaming 
  (<-strictTotalOrder-≈ to StringOrder)

-- Abstract syntax
data Type : Set where
  unit : Type
  prod : Type → Type → Type

_×_ : Type → Type → Type
_×_ = prod 

data Exp : Set where
  triv : Exp
  pair : Exp → Exp → Exp
  πl , πr  : Exp → Exp 

⟨⟩ : Exp
⟨⟩ = triv

⟨_,_⟩ : Exp → Exp → Exp 
⟨_,_⟩ = pair

-- statics
Context : Set
Context = Map StringOrder Exp 

data _⊢_hasT_ : Context → Exp → Type → Set where 
  hasTunit : {Γ : Context} → Γ ⊢ triv hasT unit
  hasTprod : {Γ : Context} {e₁ e₂ : Exp} {τ₁ τ₂ : Type} → 
    Γ ⊢ e₁ hasT τ₁ → 
    Γ ⊢ e₂ hasT τ₂ → 
    Γ ⊢ (pair e₁ e₂) hasT (prod τ₁ τ₂)
  hasTπl : {Γ : Context} {e : Exp} {τ₁ τ₂ : Type} → 
    Γ ⊢ e hasT (prod τ₁ τ₂) → 
    Γ ⊢ (πl e) hasT τ₁
  hasTπr : {Γ : Context} {e : Exp} {τ₁ τ₂ : Type} → 
    Γ ⊢ e hasT (prod τ₁ τ₂) → 
    Γ ⊢ (πr e) hasT τ₂ 

-- dynamics
-- TODO : I don't like these names 
data LazyTransition : Exp -> Exp -> Set where 
  -- 10.2e
  congπl : {e e' : Exp} → 
       LazyTransition e e' → 
       LazyTransition (πl e) (πl e')
  -- 10.2f 
  congπr : {e e' : Exp} → 
       LazyTransition e e' → 
       LazyTransition (πr e) (πr e')
  -- 10.2g
  apπl : {e e' : Exp} → 
       LazyTransition (πl ⟨ e , e' ⟩) e
  -- 10.2h
  apπr : {e e' : Exp} → 
       LazyTransition (πr ⟨ e , e' ⟩) e'

_↦_ : Exp → Exp → Set 
_↦_ = LazyTransition

data LazyVal : Exp → Set where
  LValTriv : LazyVal triv
  LValPair : (e1 e2 : Exp) → LazyVal ⟨ e1 , e2 ⟩
-- basic lemma's
preservation : 
  {e e' : Exp} {τ : Type} {Γ : Context} → 
  Γ ⊢ e hasT τ → (e ↦ e') → Γ ⊢ e' hasT τ
preservation (hasTπl Γ⊢e:τ) (congπl e→e') = 
  hasTπl (preservation Γ⊢e:τ e→e')
preservation (hasTπr Γ⊢e:τ) (congπr e→e') = 
  hasTπr (preservation Γ⊢e:τ e→e')
preservation (hasTπl (hasTprod Γ⊢el:τ _)) apπl = Γ⊢el:τ
preservation (hasTπr (hasTprod _ Γ⊢er:τ)) apπr = Γ⊢er:τ 

progress : {e : Exp} {τ : Type} {Γ : Context} → 
  (Γ ⊢ e hasT τ) → LazyVal e ⊎ Σ Exp λ e' → e ↦ e' 
progress {triv} _ = inl LValTriv
progress {pair e e₁} _ = inl (LValPair e e₁)
progress {πl e} (hasTπl Γ⊢e:τ) = 
  case progress Γ⊢e:τ of λ 
    { (inl (LValPair el _)) → inr $ _,_ el apπl   ; 
      (inr (e' , e→e'))     → inr $ _,_ (πl e') (congπl e→e') }
progress {πr e} (hasTπr Γ⊢e:τ) =
  case progress Γ⊢e:τ of λ 
    { (inl (LValPair _ er)) → inr $ _,_ er apπr   ; 
      (inr (e' , e→e'))     → inr $ _,_ (πr e') (congπr e→e') }

safety : {e : Exp} {τ : Type} {Γ : Context} → 
  (Γ ⊢ e hasT τ) → 
  (LazyVal e) ⊎ Σ Exp (λ e' → (Γ ⊢ e' hasT τ) AND e ↦ e') 
safety Γ⊢e:τ = case progress Γ⊢e:τ of λ 
  { (inl eval) → inl eval
  ; (inr (e' , e→e') ) → inr $ _,_ e' $ _,_ (preservation Γ⊢e:τ e→e') e→e' } 

