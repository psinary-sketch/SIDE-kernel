import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.Deriv.Basic

open Complex HurwitzZeta MeasureTheory Set

-- =========================================================
-- FIX 1: conj(s/2) = conj(s)/2
-- =========================================================

-- map_div₀ gives conj(s)/conj(2), need conj(2)=2
example : (starRingEnd ℂ) (2 : ℂ) = 2 := by
  exact?

example (s : ℂ) : starRingEnd ℂ (s / 2) = starRingEnd ℂ s / 2 := by
  rw [map_div₀]
  simp [conj_ofReal]

-- =========================================================
-- FIX 2: arg of positive real ≠ π
-- =========================================================

-- Find the right lemma name
#check Complex.arg_ofReal_of_nonneg
#check Complex.arg_pos
#check Complex.arg_ofReal
example (t : ℝ) (ht : 0 < t) : ((t : ℂ)).arg ≠ Real.pi := by
  exact?

-- Alternative: arg = 0 for positive reals, then 0 ≠ π
example (t : ℝ) (ht : 0 < t) : ((t : ℂ)).arg = 0 := by
  exact?

-- =========================================================
-- FIX 3: cpow conj for positive reals (fixed)
-- =========================================================

-- [b648, (R258)(2)] (example) closed by `sorry` -- quarantined to branch sorry-quarantine-SIDE-kernel; recorded in ERRATA.md.

-- =========================================================
-- FIX 4: conj(s-1) = conj(s)-1 (for the s/2-1 term)
-- =========================================================

example (s : ℂ) : starRingEnd ℂ (s - 1) = starRingEnd ℂ s - 1 := by
  simp [map_sub]

-- =========================================================
-- FULL PROOF ATTEMPT v2
-- =========================================================

-- Definitional unfolding still works:
example (s : ℂ) : completedRiemannZeta₀ s =
    mellin (hurwitzEvenFEPair 0).f_modif (s / 2) / 2 := by rfl

-- [b648, (R258)(2)] schwarz_v2 closed by `sorry` -- quarantined to branch sorry-quarantine-SIDE-kernel; recorded in ERRATA.md.
