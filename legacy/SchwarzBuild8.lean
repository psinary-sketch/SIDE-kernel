import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.Deriv.Basic

open Complex HurwitzZeta MeasureTheory Set

-- =========================================================
-- BUILDING BLOCKS
-- =========================================================

lemma conj_two : (starRingEnd ℂ) (2 : ℂ) = 2 := by
  exact_mod_cast conj_ofReal 2

lemma arg_pos_real_ne_pi (t : ℝ) (ht : 0 < t) : ((t : ℂ)).arg ≠ Real.pi := by
  rw [arg_ofReal_of_nonneg (le_of_lt ht)]
  exact Real.pi_pos.ne

lemma cpow_conj_pos_real (t : ℝ) (ht : 0 < t) (w : ℂ) :
    (t : ℂ) ^ (starRingEnd ℂ w) = starRingEnd ℂ ((t : ℂ) ^ w) := by
  rw [cpow_conj _ _ (arg_pos_real_ne_pi t ht)]
  simp [conj_ofReal]

lemma conj_div_two (s : ℂ) : starRingEnd ℂ (s / 2) = starRingEnd ℂ s / 2 := by
  rw [map_div₀, conj_two]

-- =========================================================
-- KEY: conjugation commutes with set integrals
-- Uses integral_conj which works for any measure,
-- including volume.restrict S
-- =========================================================

lemma conj_set_integral (S : Set ℝ) (f : ℝ → ℂ) :
    starRingEnd ℂ (∫ t in S, f t) = ∫ t in S, starRingEnd ℂ (f t) :=
  integral_conj.symm

-- =========================================================
-- FULL PROOF
-- =========================================================

theorem schwarz_discharge (s : ℂ) :
    completedRiemannZeta₀ (starRingEnd ℂ s) =
    starRingEnd ℂ (completedRiemannZeta₀ s) := by
  -- Unfold both sides to mellin
  show mellin (hurwitzEvenFEPair 0).f_modif (starRingEnd ℂ s / 2) / 2 =
       starRingEnd ℂ (mellin (hurwitzEvenFEPair 0).f_modif (s / 2) / 2)
  -- RHS: push conj through /2
  rw [map_div₀, conj_two]
  -- Cancel /2
  congr 1
  -- Goal: mellin f_modif (conj(s)/2) = conj(mellin f_modif (s/2))
  -- LHS has (starRingEnd ℂ s / 2), goal already has conj(s/2) form
  -- Unfold mellin
  simp only [mellin]
  -- Goal: ∫ t in Ioi 0, ↑t^(conj(s/2)-1) • f_modif(t)
  --     = conj(∫ t in Ioi 0, ↑t^(s/2-1) • f_modif(t))
  -- Push conj inside the integral
  rw [conj_set_integral]
  -- Now both sides are ∫ t in Ioi 0, ...
  apply set_integral_congr measurableSet_Ioi
  intro t ht
  -- ht : t ∈ Ioi 0, i.e. 0 < t
  -- Goal: ↑t^(conj(s/2)-1) • f_modif(t) = conj(↑t^(s/2-1) • f_modif(t))
  simp only [smul_eq_mul, map_mul]
  congr 1
  · -- cpow part: ↑t^(conj(s/2)-1) = conj(↑t^(s/2-1))
    rw [map_sub, conj_div_two, map_one]
    exact (cpow_conj_pos_real t ht (s / 2 - 1)).symm
  · -- f_modif part: f_modif(t) = conj(f_modif(t))
    sorry
