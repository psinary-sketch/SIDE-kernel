import Mathlib.NumberTheory.Padics.PadicNorm
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.Factorization.Basic

-- PROBE 1: How to get "p prime" from "p in factorization support"
#check @Nat.prime_of_mem_primeFactors
#check @Nat.support_factorization
#check @Nat.mem_primeFactors
#check @Nat.primeFactors

-- What is the type of support_factorization?
example (n : Nat) : n.factorization.support = n.primeFactors := by
  exact?

-- Direct approach: mem_primeFactors gives primality
example (n p : Nat) (hn : n ≠ 0) (hp : p ∈ n.primeFactors) :
    Nat.Prime p := by
  exact (Nat.mem_primeFactors.mp hp).1

-- Or from factorization support
example (n p : Nat) (hn : n ≠ 0) (hp : p ∈ n.factorization.support) :
    Nat.Prime p := by
  exact?

-- PROBE 2: Finsupp product equals one
#check @Finsupp.prod_eq_one
#check @Finsupp.prod_one
#check @Finsupp.prod_congr

-- Try: if each term is 1, the product is 1
example (f : Nat →₀ Nat) (g : Nat → Nat → Rat)
    (h : ∀ x ∈ f.support, g x (f x) = 1) :
    f.prod g = 1 := by
  exact?
