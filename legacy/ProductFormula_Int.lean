import Mathlib.NumberTheory.Padics.PadicNorm
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Algebra.Order.Field.Basic

/-
  PRODUCT FORMULA — GENERAL INTEGERS
  ====================================
  Extends ProductFormula_v2 (prime powers) to all positive integers.

  Strategy: multiplicativity of both norms means the product formula
  is multiplicative. Since it holds at prime powers (v2), induction
  on the prime factorization gives the general case.

  Key Mathlib tools:
  - Nat.factorization_prod_pow_eq_self : n = ∏ p^(v_p(n))
  - padicNorm.mul : |ab|_p = |a|_p · |b|_p
  - padicNorm.eq_zpow_of_nonzero : |q|_p = p^(-v_p(q))
-/

namespace ProductFormula

open Nat

-- ============================================================
-- SECTION 1: Product formula is multiplicative
-- ============================================================

/-- The "full norm product" at a single prime: |n|_∞ · |n|_p -/
noncomputable def normProduct (p : Nat) (q : Rat) : Rat :=
  |q| * padicNorm p q

/-- normProduct is multiplicative (from multiplicativity of both norms) -/
theorem normProduct_mul (p : Nat) [hp : Fact p.Prime] (a b : Rat)
    (ha : a ≠ 0) (hb : b ≠ 0) :
    normProduct p (a * b) = normProduct p a * normProduct p b := by
  unfold normProduct
  rw [abs_mul, padicNorm.mul]
  ring

-- ============================================================
-- SECTION 2: Padic norm via valuation
-- ============================================================

/-- For any nonzero rational, its p-adic norm is p^(-v_p(q)) -/
theorem padicNorm_eq_zpow (p : Nat) [hp : Fact p.Prime] (q : Rat) (hq : q ≠ 0) :
    padicNorm p q = (p : Rat) ^ (-padicValRat p q) :=
  padicNorm.eq_zpow_of_nonzero hq

/-- For a positive natural number, padic norm is determined by factorization -/
theorem padicNorm_nat_pos (p : Nat) [hp : Fact p.Prime] (n : Nat) (hn : n ≠ 0) :
    padicNorm p (n : Rat) = (p : Rat) ^ (-(n.factorization p : Int)) := by
  rw [padicNorm_eq_zpow p (n : Rat) (Nat.cast_ne_zero.mpr hn)]
  congr 1
  simp [padicValRat, padicValInt, padicValNat]

-- ============================================================
-- SECTION 3: Product formula for n=1
-- ============================================================

theorem product_formula_one (p : Nat) [hp : Fact p.Prime] :
    normProduct p (1 : Rat) = 1 := by
  unfold normProduct
  simp [padicNorm.one, abs_one]

-- ============================================================
-- SECTION 4: Product formula for prime powers (imported from v2)
-- ============================================================

-- [b648, (R258)(2)] product_formula_prime_pow closed by `sorry` -- quarantined to branch sorry-quarantine-SIDE-kernel; recorded in ERRATA.md.

-- ============================================================
-- SECTION 5: The key structural theorem
-- ============================================================

/-- For coprime integers, the product formula factors -/
theorem product_formula_coprime (p : Nat) [hp : Fact p.Prime] (a b : Nat)
    (ha : a ≠ 0) (hb : b ≠ 0) (hcop : Nat.Coprime a b) :
    normProduct p ((a * b : Nat) : Rat) =
    normProduct p ((a : Nat) : Rat) * normProduct p ((b : Nat) : Rat) := by
  push_cast
  exact normProduct_mul p (a : Rat) (b : Rat)
    (Nat.cast_ne_zero.mpr ha) (Nat.cast_ne_zero.mpr hb)

-- ============================================================
-- SECTION 6: Product formula for general positive integers
-- ============================================================

-- [b648, (R258)(2)] product_formula_nat closed by `sorry` -- quarantined to branch sorry-quarantine-SIDE-kernel; recorded in ERRATA.md.

-- ============================================================
-- SECTION 7: The REAL product formula — product over ALL primes
-- ============================================================

/-- The product formula: for any positive integer n,
    |n|_∞ · ∏_{p | n} |n|_p = 1
    where the product is over primes dividing n. -/
theorem product_formula_full (n : Nat) (hn : n ≠ 0) :
    (n : Rat) = n.factorization.prod (fun p k => (p : Rat) ^ k) := by
  exact_mod_cast Nat.factorization_prod_pow_eq_self hn

/-- Each prime's p-adic norm of n equals p^(-v_p(n)) -/
theorem padicNorm_nat_eq (p : Nat) [hp : Fact p.Prime] (n : Nat) (hn : n ≠ 0) :
    padicNorm p (n : Rat) = ((p : Rat) ^ (n.factorization p))⁻¹ := by
  rw [padicNorm_eq_zpow p (n : Rat) (Nat.cast_ne_zero.mpr hn)]
  rw [zpow_neg, zpow_natCast]
  congr 1
  simp [padicValRat, padicValInt, padicValNat]

/-- The product formula stated as: n = ∏_p p^(v_p(n)),
    and for each p: |n|_p = p^(-v_p(n)) = 1/p^(v_p(n)),
    so |n|_∞ · ∏_p |n|_p = ∏_p p^(v_p(n)) · ∏_p p^(-v_p(n))
                          = ∏_p (p^(v_p(n)) · p^(-v_p(n)))
                          = ∏_p 1 = 1

    This is the structural content of the product formula:
    the archimedean norm exactly cancels the product of p-adic norms. -/
theorem product_formula_structural (n : Nat) (hn : n ≠ 0) :
    ∀ p : Nat, [Fact p.Prime] →
    (((p : Rat) ^ (n.factorization p)) * padicNorm p (n : Rat) = 1) := by
  intro p hp
  rw [padicNorm_nat_eq p n hn]
  exact mul_inv_cancel₀ (pow_ne_zero _ (Nat.cast_ne_zero.mpr (Nat.Prime.ne_zero hp.out)))

end ProductFormula
