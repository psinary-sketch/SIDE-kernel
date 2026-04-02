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

lemma conj_half_sub_one (s : ℂ) :
    starRingEnd ℂ s / 2 - 1 = starRingEnd ℂ (s / 2 - 1) := by
  rw [map_sub, conj_div_two, map_one]

-- =========================================================
-- FULL PROOF
-- =========================================================

theorem schwarz_discharge (s : ℂ) :
    completedRiemannZeta₀ (starRingEnd ℂ s) =
    starRingEnd ℂ (completedRiemannZeta₀ s) := by
  show mellin (hurwitzEvenFEPair 0).f_modif (starRingEnd ℂ s / 2) / 2 =
       starRingEnd ℂ (mellin (hurwitzEvenFEPair 0).f_modif (s / 2) / 2)
  rw [map_div₀, conj_two]
  congr 1
  simp only [mellin]
  suffices hpt : EqOn
      (fun (t : ℝ) => (↑t : ℂ) ^ ((starRingEnd ℂ) s / 2 - 1) • (hurwitzEvenFEPair 0).f_modif t)
      (fun (t : ℝ) => (starRingEnd ℂ) ((↑t : ℂ) ^ (s / 2 - 1) • (hurwitzEvenFEPair 0).f_modif t))
      (Ioi 0) by
    rw [setIntegral_congr_fun measurableSet_Ioi hpt]
    exact integral_conj
  intro t ht
  simp only [smul_eq_mul, map_mul]
  congr 1
  · rw [conj_half_sub_one]
    exact cpow_conj_pos_real t ht (s / 2 - 1)
  · -- f_modif real-valued: (hurwitzEvenFEPair 0).f_modif t is real
    sorry
