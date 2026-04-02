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
  simp only [mellin]
  -- Goal: ∫ t in Ioi 0, ↑t^(conj(s)/2-1) • f_modif(t)
  --     = conj(∫ t in Ioi 0, ↑t^(s/2-1) • f_modif(t))
  --
  -- Strategy: go through intermediate
  --   ∫ t in Ioi 0, conj(↑t^(s/2-1) • f_modif(t))
  -- which equals RHS by integral_conj, and equals LHS by integrand comparison
  trans (∫ t in Ioi (0:ℝ),
    (starRingEnd ℂ) (↑t ^ (s / 2 - 1) • (hurwitzEvenFEPair 0).f_modif t))
  · -- LHS = middle: compare integrands on Ioi 0
    apply set_integral_congr measurableSet_Ioi
    intro t ht
    simp only [smul_eq_mul, map_mul]
    congr 1
    · -- cpow part
      rw [map_sub, conj_div_two, map_one]
      exact (cpow_conj_pos_real t ht (s / 2 - 1)).symm
    · -- f_modif real-valued: f_modif(t) = conj(f_modif(t))
      sorry
  · -- middle = RHS: integral_conj
    exact (integral_conj (𝕜 := ℂ)).symm
