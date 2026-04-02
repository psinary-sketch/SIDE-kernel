import Mathlib.NumberTheory.Padics.PadicNorm
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.Factorization.Basic

-- Check what factorization tools exist
#check Nat.factorization
#check @Finsupp.prod
#check @Nat.factorization_prod_pow_eq_self

-- Check padic valuation connection to norm
#check @padicValNat
#check @padicNorm.eq_zpow_of_nonzero

-- Check coprimality tools
#check @Nat.Coprime
#check @padicNorm.padicNorm_of_prime_of_ne

-- Check Nat.factors
#check @Nat.factors
#check @Nat.prod_factors_eq_of_ne_zero

-- Check Finset.prod over primes
#check @Finset.prod

-- Test: can we state the general product formula?
example (n : Nat) (hn : n ≠ 0) :
    n.factorization.prod (fun p k => (p : Rat) ^ k) = (n : Rat) := by
  exact_mod_cast Nat.factorization_prod_pow_eq_self hn
