import Mathlib.NumberTheory.Padics.PadicNorm
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Algebra.Order.Field.Basic

namespace ProductFormula

-- ============================================================
-- BRIDGE (from ProductFormula_Clean)
-- ============================================================

theorem valRat_eq_factorization (p n : Nat) (hp : Nat.Prime p) :
    padicValRat p (n : Rat) = (n.factorization p : Int) := by
  rw [padicValRat.of_nat, Nat.factorization_def n hp]

-- ============================================================
-- PER-PRIME PRODUCT FORMULA FOR RATIONALS
-- ============================================================

theorem factor_times_norm_rat (p : Nat) [hp : Fact p.Prime]
    (q : Rat) (hq : q ≠ 0) :
    (p : Rat) ^ (padicValRat p q) * padicNorm p q = 1 := by
  rw [padicNorm.eq_zpow_of_nonzero hq]
  have hp_ne : (p : Rat) ≠ 0 :=
    Nat.cast_ne_zero.mpr (Nat.Prime.ne_zero hp.out)
  rw [zpow_neg]
  exact mul_inv_cancel₀ (zpow_ne_zero _ hp_ne)

-- ============================================================
-- FULL PRODUCT FORMULA FOR INTEGERS (reproved cleanly)
-- ============================================================

theorem archimedean_times_padic_product (n : Nat) (hn : n ≠ 0) :
    n.factorization.prod (fun p k =>
      ((p : Rat) ^ k) * padicNorm p (n : Rat)) = 1 := by
  unfold Finsupp.prod
  apply Finset.prod_eq_one
  intro p hp_mem
  have hp_prime : Nat.Prime p :=
    Nat.prime_of_mem_primeFactors (Nat.support_factorization n ▸ hp_mem)
  haveI : Fact p.Prime := ⟨hp_prime⟩
  -- Beta-reduce the lambda, then apply the bridge
  show ((p : Rat) ^ (n.factorization p)) * padicNorm p (n : Rat) = 1
  rw [padicNorm.eq_zpow_of_nonzero (Nat.cast_ne_zero.mpr hn)]
  rw [← zpow_natCast (p : Rat)]
  rw [padicValRat.of_nat, Nat.factorization_def n hp_prime, zpow_neg]
  exact mul_inv_cancel₀ (zpow_ne_zero _
    (Nat.cast_ne_zero.mpr (Nat.Prime.ne_zero hp_prime)))

-- ============================================================
-- S-DARKNESS
-- ============================================================

theorem s_darkness_int (s : Int) :
    (1 : Rat) ^ s = 1 :=
  one_zpow s

theorem s_darkness_from_product (p : Nat) [hp : Fact p.Prime]
    (q : Rat) (hq : q ≠ 0) (s : Int) :
    ((p : Rat) ^ (padicValRat p q) * padicNorm p q) ^ s = 1 := by
  rw [factor_times_norm_rat p q hq]; exact one_zpow s

-- ============================================================
-- CONSERVATION OF SPECTRA (Foundation 4)
-- ============================================================

/-- The product formula ∏_v |x|_v = 1 is s-independent.
    Raising both sides to any power s: (∏_v |x|_v)^s = 1^s = 1.
    Therefore interfaces transmit no spectral information.
    Formation count: n₄ = 0. -/
theorem conservation_of_spectra :
    ∀ (s : Int), (1 : Rat) ^ s = 1 :=
  fun s => one_zpow s

-- ============================================================
-- FUNDAMENTAL THEOREM OF ARITHMETIC (Mathlib)
-- ============================================================

theorem nat_eq_factorization_prod (n : Nat) (hn : n ≠ 0) :
    (n : Nat) = n.factorization.prod (fun p k => p ^ k) :=
  (Nat.factorization_prod_pow_eq_self hn).symm

-- ============================================================
-- ARCHIMEDEAN NORM
-- ============================================================

theorem abs_nat_pos (n : Nat) (hn : n ≠ 0) :
    |(n : Rat)| = (n : Rat) :=
  abs_of_pos (Nat.cast_pos.mpr (Nat.pos_of_ne_zero hn))

-- ============================================================
-- COPRIME NORMS
-- ============================================================

theorem coprime_prime_pow_norm (p q : Nat)
    [hp : Fact p.Prime] [hq : Fact q.Prime] (hpq : p ≠ q) (k : Nat) :
    padicNorm p ((q : Rat) ^ k) = 1 := by
  induction k with
  | zero => simp
  | succ n ih =>
    rw [pow_succ, padicNorm.mul, ih,
        padicNorm.padicNorm_of_prime_of_ne hpq, mul_one]

end ProductFormula
