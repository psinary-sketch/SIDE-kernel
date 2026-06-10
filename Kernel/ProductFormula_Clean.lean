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
  (Nat.prod_factorization_pow_eq_self hn).symm

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

theorem product_formula_global (n : Nat) (hn : Ne n 0) :
    (n : Rat) * n.factorization.support.prod (fun p => padicNorm p (n : Rat)) = 1 := by
  have hfact : (n : Rat)
      = n.factorization.support.prod (fun p => (p : Rat) ^ (n.factorization p)) := by
    conv_lhs => rw [nat_eq_factorization_prod n hn]
    simp only [Finsupp.prod, Nat.cast_prod, Nat.cast_pow]
  have key : n.factorization.support.prod
      (fun p => (p : Rat) ^ (n.factorization p) * padicNorm p (n : Rat)) = 1 := by
    refine Finset.prod_eq_one (fun p hp => ?_)
    haveI : Fact (Nat.Prime p) := Fact.mk (prime_of_mem_factorization_support hp)
    exact factor_times_norm_eq_one p n hn
  calc (n : Rat) * n.factorization.support.prod (fun p => padicNorm p (n : Rat))
      = n.factorization.support.prod (fun p => (p : Rat) ^ (n.factorization p))
        * n.factorization.support.prod (fun p => padicNorm p (n : Rat)) := by rw [hfact]
    _ = n.factorization.support.prod
          (fun p => (p : Rat) ^ (n.factorization p) * padicNorm p (n : Rat)) :=
            (Finset.prod_mul_distrib).symm
    _ = 1 := key


theorem padicNorm_eq_one_of_not_mem (p n : Nat) [hp : Fact p.Prime] (hn : n ≠ 0)
    (hpn : p ∉ n.factorization.support) :
    padicNorm p (n : Rat) = 1 := by
  rw [padicNorm_via_factorization p n hn]
  have h0 : n.factorization p = 0 := by
    by_contra h
    exact hpn (Finsupp.mem_support_iff.mpr h)
  rw [h0]
  simp

theorem product_formula_rat (q : Rat) (hq : q ≠ 0) :
    |q| * (q.num.natAbs.factorization.support ∪ q.den.factorization.support).prod
            (fun p => padicNorm p q) = 1 := by
  have hnum0 : q.num ≠ 0 := fun h => hq (Rat.num_eq_zero.mp h)
  have hnum : q.num.natAbs ≠ 0 := Int.natAbs_ne_zero.mpr hnum0
  have hden : q.den ≠ 0 := q.den_nz
  have hA : (q.num.natAbs : Rat) ≠ 0 := Nat.cast_ne_zero.mpr hnum
  have hB : (q.den : Rat) ≠ 0 := Nat.cast_ne_zero.mpr hden
  have hdisj : Disjoint q.num.natAbs.factorization.support q.den.factorization.support := by
    rw [Nat.support_factorization, Nat.support_factorization]
    exact q.reduced.disjoint_primeFactors
  have hbridge : ∀ p : Nat, padicNorm p ((q.num.natAbs : Nat) : Rat) = padicNorm p (q.num : Rat) := by
    intro p
    have hcast : ((q.num.natAbs : Nat) : Rat) = |(q.num : Rat)| := by rw [Nat.cast_natAbs, Int.cast_abs]
    rw [hcast]
    rcases abs_choice (q.num : Rat) with h | h
    · rw [h]
    · rw [h, padicNorm.neg]
  have habs : |q| = (q.num.natAbs : Rat) / (q.den : Rat) := by
    conv_lhs => rw [← Rat.num_div_den q]
    rw [abs_div]
    rw [abs_of_nonneg (show (0 : Rat) ≤ (q.den : Rat) from Nat.cast_nonneg q.den)]
    rw [Nat.cast_natAbs, Int.cast_abs]
  have eqnum : (q.num.natAbs.factorization.support).prod (fun p => padicNorm p q)
      = (q.num.natAbs.factorization.support).prod (fun p => padicNorm p (q.num.natAbs : Rat)) := by
    refine Finset.prod_congr rfl (fun p hp => ?_)
    haveI : Fact (Nat.Prime p) := Fact.mk (prime_of_mem_factorization_support hp)
    have hpnotden : p ∉ q.den.factorization.support := Finset.disjoint_left.mp hdisj hp
    have hden1 : padicNorm p (q.den : Rat) = 1 :=
      padicNorm_eq_one_of_not_mem p q.den hden hpnotden
    have hsplit : padicNorm p q = padicNorm p (q.num : Rat) / padicNorm p (q.den : Rat) := by
      conv_lhs => rw [← Rat.num_div_den q]
      rw [padicNorm.div]
    rw [hsplit, hden1, div_one, hbridge]
  have eqden : (q.den.factorization.support).prod (fun p => padicNorm p q)
      = (q.den.factorization.support).prod (fun p => (padicNorm p (q.den : Rat))⁻¹) := by
    refine Finset.prod_congr rfl (fun p hp => ?_)
    haveI : Fact (Nat.Prime p) := Fact.mk (prime_of_mem_factorization_support hp)
    have hpnotnum : p ∉ q.num.natAbs.factorization.support := Finset.disjoint_right.mp hdisj hp
    have hnum1 : padicNorm p (q.num : Rat) = 1 := by
      rw [← hbridge p]
      exact padicNorm_eq_one_of_not_mem p q.num.natAbs hnum hpnotnum
    have hsplit : padicNorm p q = padicNorm p (q.num : Rat) / padicNorm p (q.den : Rat) := by
      conv_lhs => rw [← Rat.num_div_den q]
      rw [padicNorm.div]
    rw [hsplit, hnum1, one_div]
  have hPnum : (q.num.natAbs.factorization.support).prod (fun p => padicNorm p (q.num.natAbs : Rat))
      = (q.num.natAbs : Rat)⁻¹ :=
    eq_inv_of_mul_eq_one_right (product_formula_global q.num.natAbs hnum)
  have hPden : (q.den.factorization.support).prod (fun p => padicNorm p (q.den : Rat))
      = (q.den : Rat)⁻¹ :=
    eq_inv_of_mul_eq_one_right (product_formula_global q.den hden)
  rw [Finset.prod_union hdisj, eqnum, eqden, Finset.prod_inv_distrib, hPnum, hPden, habs,
      inv_inv, div_eq_mul_inv]
  rw [show (q.num.natAbs : Rat) * (q.den : Rat)⁻¹ * ((q.num.natAbs : Rat)⁻¹ * (q.den : Rat))
        = ((q.num.natAbs : Rat) * (q.num.natAbs : Rat)⁻¹) * ((q.den : Rat)⁻¹ * (q.den : Rat))
      from by ring]
  rw [mul_inv_cancel₀ hA, inv_mul_cancel₀ hB, mul_one]

end ProductFormula
