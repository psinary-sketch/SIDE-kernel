import Mathlib.NumberTheory.Padics.PadicNorm
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Algebra.Order.Field.Basic

namespace ProductFormula

open Nat

theorem padicNorm_prime_pow (p : Nat) [hp : Fact p.Prime] (k : Nat) :
    padicNorm p ((p : Rat) ^ k) = ((p : Rat)⁻¹) ^ k := by
  induction k with
  | zero => simp [padicNorm.one]
  | succ n ih =>
    rw [pow_succ, padicNorm.mul, ih, pow_succ]
    congr 1
    exact padicNorm.padicNorm_p_of_prime

theorem abs_prime_pow (p : Nat) [hp : Fact p.Prime] (k : Nat) :
    |(p : Rat) ^ k| = (p : Rat) ^ k := by
  apply abs_of_pos
  exact pow_pos (Nat.cast_pos.mpr (Nat.Prime.pos hp.out)) k

theorem product_formula_prime_pow (p : Nat) [hp : Fact p.Prime] (k : Nat) :
    |(p : Rat) ^ k| * padicNorm p ((p : Rat) ^ k) = 1 := by
  rw [abs_prime_pow, padicNorm_prime_pow]
  rw [← mul_pow]
  have hp_ne : (p : Rat) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.Prime.ne_zero hp.out)
  rw [mul_inv_cancel₀ hp_ne, one_pow]

theorem coprime_prime_norm (p q : Nat)
    [hp : Fact p.Prime] [hq : Fact q.Prime] (hpq : p ≠ q) :
    padicNorm p (q : Rat) = 1 :=
  padicNorm.padicNorm_of_prime_of_ne hpq

theorem coprime_prime_pow_norm (p q : Nat)
    [hp : Fact p.Prime] [hq : Fact q.Prime] (hpq : p ≠ q) (k : Nat) :
    padicNorm p ((q : Rat) ^ k) = 1 := by
  induction k with
  | zero => simp [padicNorm.one]
  | succ n ih =>
    rw [pow_succ, padicNorm.mul, ih, coprime_prime_norm p q hpq, mul_one]

theorem product_formula_single_prime (q : Nat) [hq : Fact q.Prime] :
    |(q : Rat)| * padicNorm q (q : Rat) = 1 := by
  have := product_formula_prime_pow q 1
  simp only [pow_one] at this
  exact this

end ProductFormula
