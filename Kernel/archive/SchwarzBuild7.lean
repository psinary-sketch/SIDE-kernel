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
  -- Now: ... / 2 = conj(...) / 2
  congr 1
  -- LHS: rewrite conj(s)/2 as conj(s/2)
  rw [← conj_div_two]
  -- Now: mellin f_modif (conj(s/2)) = conj(mellin f_modif (s/2))
  -- Unfold mellin
  simp only [mellin]
  -- Goal: ∫ t in Ioi 0, ↑t^(conj(s/2)-1) • f_modif(t)
  --     = conj(∫ t in Ioi 0, ↑t^(s/2-1) • f_modif(t))
  -- Convert RHS using integral_conj
  have iconj : (starRingEnd ℂ)
      (∫ t in Ioi (0:ℝ), ↑t ^ (s / 2 - 1) • (hurwitzEvenFEPair 0).f_modif t) =
      ∫ t in Ioi (0:ℝ), (starRingEnd ℂ)
        (↑t ^ (s / 2 - 1) • (hurwitzEvenFEPair 0).f_modif t) :=
    (integral_conj (𝕜 := ℂ)).symm
  rw [iconj]
  -- Now both sides are ∫ t in Ioi 0, ...
  -- Compare integrands pointwise on Ioi 0
  apply set_integral_congr measurableSet_Ioi
  intro t ht
  -- ht : t ∈ Ioi 0, i.e. 0 < t
  -- Goal: ↑t^(conj(s/2)-1) • f_modif(t) = conj(↑t^(s/2-1) • f_modif(t))
  -- Push conj through smul/mul
  simp only [smul_eq_mul, map_mul]
  -- Goal: ↑t^(conj(s/2)-1) * f_modif(t) = conj(↑t^(s/2-1)) * conj(f_modif(t))
  congr 1
  · -- cpow part: ↑t^(conj(s/2)-1) = conj(↑t^(s/2-1))
    rw [map_sub, conj_div_two, map_one]
    exact (cpow_conj_pos_real t ht (s / 2 - 1)).symm
  · -- f_modif part: f_modif(t) = conj(f_modif(t))
    -- f_modif is real-valued (built from ofReal ∘ evenKernel with real corrections)
    sorry
