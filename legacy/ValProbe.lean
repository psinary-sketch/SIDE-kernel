import Mathlib.NumberTheory.Padics.PadicNorm
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Algebra.Order.Field.Basic

-- PROBE: Find the bridge between padicValRat/padicValNat and Nat.factorization

-- Is factorization defined in terms of padicValNat?
#check @Nat.factorization
#check @padicValNat

-- Direct connection?
#check @Nat.factorization_eq
-- This might say: n.factorization p = padicValNat p n

-- Try the other direction
example (p n : Nat) (hp : Nat.Prime p) (hn : n ≠ 0) :
    n.factorization p = padicValNat p n := by
  exact?

-- What about padicValRat for nat cast?
#check @padicValRat.of_nat
#check @padicValRat_of_nat

-- Try: padicValRat p (n : Rat) = padicValNat p n
example (p n : Nat) :
    padicValRat p (n : Rat) = padicValNat p n := by
  exact?

-- What about the norm directly?
-- padicNorm p (n : Rat) for prime p, positive n
-- Should be p^(-padicValNat p n)
#check @padicNorm.eq_zpow_of_nonzero

-- Try to express norm in terms of factorization
example (p : Nat) [hp : Fact p.Prime] (n : Nat) (hn : n ≠ 0) :
    padicNorm p (n : Rat) = ((p : Rat) ^ (n.factorization p))⁻¹ := by
  exact?
