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

-- [b648, (R258)(2)] schwarz_discharge closed by `sorry` -- quarantined to branch sorry-quarantine-SIDE-kernel; recorded in ERRATA.md.
