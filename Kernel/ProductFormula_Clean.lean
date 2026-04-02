import Mathlib.NumberTheory.Padics.PadicNorm
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Algebra.Order.Field.Basic

namespace ProductFormula

-- ============================================================
-- BRIDGE: factorization <-> padic valuation <-> padic norm
-- ============================================================

theorem valRat_eq_factorization (p n : Nat) (hp : Nat.Prime p) :
    padicValRat p (n : Rat) = (n.factorization p : Int) := by
  rw [padicValRat.of_nat, Nat.factorization_def n hp]

theorem padicNorm_via_factorization (p : Nat) [hp : Fact p.Prime]
    (n : Nat) (hn : n ≠ 0) :
    padicNorm p (n : Rat) =
    (p : Rat) ^ (-(n.factorization p : Int)) := by
  rw [padicNorm.eq_zpow_of_nonzero (Nat.cast_ne_zero.mpr hn)]
  congr 1
  rw [neg_inj]
  exact valRat_eq_factorization p n hp.out

-- ============================================================
-- STRUCTURAL THEOREM: p^(v_p(n)) * |n|_p = 1
-- ============================================================

theorem factor_times_norm_eq_one (p : Nat) [hp : Fact p.Prime]
    (n : Nat) (hn : n ≠ 0) :
    ((p : Rat) ^ (n.factorization p)) * padicNorm p (n : Rat) = 1 := by
  rw [padicNorm_via_factorization p n hn]
  rw [← zpow_natCast (p : Rat) (n.factorization p)]
  rw [zpow_neg]
  exact mul_inv_cancel₀ (zpow_ne_zero _
    (Nat.cast_ne_zero.mpr (Nat.Prime.ne_zero hp.out)))

-- ============================================================
-- PRIME FROM FACTORIZATION SUPPORT
-- ============================================================

theorem prime_of_mem_factorization_support {n p : Nat}
    (hp_mem : p ∈ n.factorization.support) : Nat.Prime p :=
  Nat.prime_of_mem_primeFactors (Nat.support_factorization n ▸ hp_mem)

-- ============================================================
-- FULL PRODUCT FORMULA via Finsupp
-- ============================================================

theorem product_formula_finsupp (n : Nat) (hn : n ≠ 0) :
    n.factorization.prod (fun p k =>
      ((p : Rat) ^ k) * padicNorm p (n : Rat)) = 1 := by
  unfold Finsupp.prod
  apply Finset.prod_eq_one
  intro p hp_mem
  haveI : Fact (Nat.Prime p) :=
    ⟨prime_of_mem_factorization_support hp_mem⟩
  exact factor_times_norm_eq_one p n hn

-- ============================================================
-- FUNDAMENTAL THEOREM OF ARITHMETIC (Mathlib)
-- ============================================================

theorem nat_eq_factorization_prod (n : Nat) (hn : n ≠ 0) :
    (n : Nat) = n.factorization.prod (fun p k => p ^ k) :=
  (Nat.factorization_prod_pow_eq_self hn).symm

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

-- ============================================================
-- PRIME POWER PRODUCT FORMULA
-- ============================================================

theorem product_formula_prime_pow (p : Nat) [hp : Fact p.Prime] (k : Nat) :
    |(p : Rat) ^ k| * padicNorm p ((p : Rat) ^ k) = 1 := by
  rw [abs_of_pos (pow_pos (Nat.cast_pos.mpr (Nat.Prime.pos hp.out)) k)]
  induction k with
  | zero => simp
  | succ n ih =>
    rw [pow_succ, padicNorm.mul, padicNorm.padicNorm_p_of_prime]
    have hp_ne : (p : Rat) ≠ 0 :=
      Nat.cast_ne_zero.mpr (Nat.Prime.ne_zero hp.out)
    calc (p : Rat) ^ n * (p : Rat) *
          (padicNorm p ((p : Rat) ^ n) * (p : Rat)⁻¹)
        = ((p : Rat) ^ n * padicNorm p ((p : Rat) ^ n)) *
          ((p : Rat) * (p : Rat)⁻¹) := by ring
      _ = 1 * 1 := by rw [ih, mul_inv_cancel₀ hp_ne]
      _ = 1 := by ring

end ProductFormula
