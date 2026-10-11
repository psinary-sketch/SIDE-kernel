import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.Deriv.Basic

open Complex HurwitzZeta MeasureTheory Set

-- =========================================================
-- BUILDING BLOCKS (all confirmed working)
-- =========================================================

-- conj(2) = 2
lemma conj_two : (starRingEnd ℂ) (2 : ℂ) = 2 :=
  conj_eq_iff_re.mpr rfl

-- arg of positive real = 0
lemma arg_pos_real (t : ℝ) (ht : 0 < t) : ((t : ℂ)).arg = 0 :=
  arg_ofReal_of_nonneg (le_of_lt ht)

-- arg of positive real ≠ π
lemma arg_pos_real_ne_pi (t : ℝ) (ht : 0 < t) : ((t : ℂ)).arg ≠ Real.pi := by
  rw [arg_pos_real t ht]
  exact Real.pi_pos.ne'

-- cpow conjugation for positive reals
lemma cpow_conj_pos_real (t : ℝ) (ht : 0 < t) (w : ℂ) :
    (t : ℂ) ^ (starRingEnd ℂ w) = starRingEnd ℂ ((t : ℂ) ^ w) := by
  rw [cpow_conj _ _ (arg_pos_real_ne_pi t ht)]
  simp [conj_ofReal]

-- conj(s/2) = conj(s)/2
lemma conj_div_two (s : ℂ) : starRingEnd ℂ (s / 2) = starRingEnd ℂ s / 2 := by
  rw [map_div₀, conj_two]

-- conj(s - 1) = conj(s) - 1
lemma conj_sub_one (s : ℂ) : starRingEnd ℂ (s - 1) = starRingEnd ℂ s - 1 := by
  simp [map_sub, conj_eq_iff_re.mpr rfl]

-- conj(s/2 - 1) = conj(s)/2 - 1
lemma conj_half_sub_one (s : ℂ) :
    starRingEnd ℂ (s / 2 - 1) = starRingEnd ℂ s / 2 - 1 := by
  rw [map_sub, conj_div_two, conj_eq_iff_re.mpr rfl]

-- =========================================================
-- KEY LEMMA: integrand conjugation
--
-- For t > 0 and f real-valued:
-- conj(↑t^(s/2-1) • f(t)) = ↑t^(conj(s)/2-1) • f(t)
-- =========================================================

-- We need f_modif to be real-valued, i.e. conj(f_modif(t)) = f_modif(t)
-- This is because f_modif is built from (ofReal ∘ evenKernel)
-- with correction terms involving ofReal constants

-- Test: is f_modif value conj-fixed?
-- [b648, (R258)(2)] (example) closed by `sorry` -- quarantined to branch sorry-quarantine-SIDE-kernel; recorded in ERRATA.md.

-- =========================================================
-- ALTERNATIVE: Try simp-based proof
-- =========================================================

-- Maybe simp can handle the whole thing if we give it enough lemmas
-- [b648, (R258)(2)] schwarz_v3 closed by `sorry` -- quarantined to branch sorry-quarantine-SIDE-kernel; recorded in ERRATA.md.

-- =========================================================
-- EVEN SIMPLER: skip integral_conj, prove directly
-- =========================================================

-- [b648, (R258)(2)] schwarz_v4 closed by `sorry` -- quarantined to branch sorry-quarantine-SIDE-kernel; recorded in ERRATA.md.
