{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE DataKinds #-}
data ℕ = Z | S ℕ
data Typ = Nat | Fun Typ Typ
type Ctx = [Typ]

data τ ∈ γ where
  Here :: τ ∈ (τ : γ)
  There :: forall τ τ' γ . τ ∈ γ -> τ ∈ (τ' : γ)


data γ ⊢ τ where
  Var :: (τ ∈ γ) -> γ ⊢ τ
  Zero ::  γ ⊢ Nat
  Succ :: γ ⊢ Nat -> γ ⊢ Nat
  App :: γ ⊢ Fun τ τ' -> γ ⊢ τ -> γ ⊢ τ'
  Lam ::  (τ : γ) ⊢ τ' -> γ ⊢ Fun τ τ'
  Rec :: γ ⊢ Nat -> γ ⊢ τ -> ((Nat : τ : γ) ⊢ τ) -> γ ⊢ τ

data Val τ where
  NatVal :: ℕ -> Val Nat
  FunVal :: (Val τ -> Val τ') -> Val (Fun τ τ') -- !!! TOTAL FUNCTIONS ONLY ALLOWED HERE !!!

type Env γ = forall τ. τ ∈ γ -> Val τ

cons :: Val τ -> Env γ -> Env (τ : γ)
cons v ρ Here = v
cons v ρ (There x) = ρ x

cons v ρ = \l -> case l of
  Here -> v
  (There x) -> ρ x


nil :: Env '[]
nil = \case

recursor :: ℕ -> t -> (ℕ -> t -> t) -> t
recursor Z base ind = base
recursor (S n) base ind = ind n (recursor n base ind)

eval :: Env γ -> γ ⊢ τ -> Val τ
eval ρ (Var x) = ρ x
eval ρ Zero = NatVal Z
eval ρ (Succ e) = case eval ρ e of
  NatVal v -> NatVal (S v)
eval ρ (App e₁ e₂) = case eval ρ e₁ of
  FunVal f -> f (eval ρ e₂)
eval ρ (Lam e) = FunVal (\v -> eval (cons v ρ) e)
eval ρ (Rec e eBase eInd) = case eval ρ e of
  NatVal v -> recursor v (eval ρ eBase) (\n i -> eval (cons (NatVal n) (cons i ρ)) eInd)
