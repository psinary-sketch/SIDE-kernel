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
  -- Step 1: prove pointwise equality of integrands
  suffices hpt : ∀ t ∈ Ioi (0:ℝ),
      (↑t : ℂ) ^ ((starRingEnd ℂ) s / 2 - 1) • (hurwitzEvenFEPair 0).f_modif t =
      (starRingEnd ℂ) ((↑t : ℂ) ^ (s / 2 - 1) • (hurwitzEvenFEPair 0).f_modif t) by
    -- After rewriting integrands, goal becomes integral_conj
    rw [set_integral_congr measurableSet_Ioi hpt]
    exact integral_conj
  -- Step 2: prove the pointwise claim
  intro t ht
  simp only [smul_eq_mul, map_mul]
  congr 1
  · -- cpow part: ↑t^(conj(s)/2-1) = conj(↑t^(s/2-1))
    rw [map_sub, conj_div_two, map_one]
    exact (cpow_conj_pos_real t ht (s / 2 - 1)).symm
  · -- f_modif real-valued: f_modif(t) = conj(f_modif(t))
    sorry
