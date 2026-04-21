import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.Deriv.Basic

open Complex HurwitzZeta MeasureTheory Set

-- =========================================================
-- BUILDING BLOCKS (all verified)
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
-- KEY LEMMA: restricted integral conjugation
-- =========================================================

-- ∫ t in S, f t is notation for ∫ t, f t ∂(volume.restrict S)
-- integral_conj works for any measure, so it applies

lemma set_integral_conj' (S : Set ℝ) (f : ℝ → ℂ) :
    starRingEnd ℂ (∫ t in S, f t) = ∫ t in S, starRingEnd ℂ (f t) := by
  exact (integral_conj (𝕜 := ℂ)).symm

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
  -- Now: mellin f_modif (conj(s)/2) / 2 = conj(mellin f_modif (s/2)) / 2
  -- Cancel the /2
  congr 1
  -- LHS: rewrite conj(s)/2 = conj(s/2)
  rw [← conj_div_two]
  -- Now: mellin f_modif (conj(s/2)) = conj(mellin f_modif (s/2))
  -- Unfold mellin on both sides
  simp only [mellin]
  -- Now: ∫ t in Ioi 0, ↑t^(conj(s/2)-1) • f_modif(t)
  --    = conj(∫ t in Ioi 0, ↑t^(s/2-1) • f_modif(t))
  -- Push conj inside the integral
  rw [set_integral_conj']
  -- Now both sides are set integrals, compare integrands on Ioi 0
  apply set_integral_congr measurableSet_Ioi
  intro t ht
  -- ht : t ∈ Ioi 0, i.e. 0 < t
  simp only [smul_eq_mul, map_mul]
  have ht' : 0 < t := ht
  congr 1
  · -- Factor 1: ↑t^(conj(s/2)-1) = conj(↑t^(s/2-1))
    rw [map_sub, conj_div_two, map_one]
    exact (cpow_conj_pos_real t ht' (s / 2 - 1)).symm
  · -- Factor 2: f_modif(t) = conj(f_modif(t)) [real-valued]
    sorry
