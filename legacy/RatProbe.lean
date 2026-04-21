import Mathlib.NumberTheory.Padics.PadicNorm
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Algebra.Order.Field.Basic

-- PROBE 1: Rat decomposition
#check @Rat.num
#check @Rat.den
#check @Rat.num_div_den

-- PROBE 2: padicNorm on rationals (already works)
#check @padicNorm.eq_zpow_of_nonzero
-- padicNorm p q = p^(-padicValRat p q) for q ≠ 0

-- PROBE 3: multiplicativity
#check @padicNorm.mul
#check @padicNorm.div

-- PROBE 4: padicValRat decomposition
#check @padicValRat.defn
#check @padicValRat.mul
#check @padicValRat.div

-- PROBE 5: neg/abs for padic norm
#check @padicNorm.neg
-- |−q|_p = |q|_p

-- PROBE 6: s-darkness building blocks
#check @one_zpow
-- 1^(n : ℤ) = 1

-- Test: does padicNorm.div exist?
example (p : Nat) [hp : Fact p.Prime] (a b : Rat) (hb : b ≠ 0) :
    padicNorm p (a / b) = padicNorm p a / padicNorm p b := by
  exact?

-- Test: product formula for negative integers
example (p : Nat) [hp : Fact p.Prime] (n : Nat) (hn : n ≠ 0) :
    padicNorm p (-(n : Rat)) = padicNorm p (n : Rat) := by
  exact?
