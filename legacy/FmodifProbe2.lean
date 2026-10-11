import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.Deriv.Basic

open Complex HurwitzZeta MeasureTheory Set

-- The goal (from Build14 sorry) is:
-- f_modif(t) = conj(f_modif(t))
-- Equivalently: conj(f_modif(t)) = f_modif(t)
-- Equivalently: f_modif(t).im = 0

-- =========================================================
-- APPROACH 1: conj_eq_iff_im route
-- =========================================================

-- [b648, (R258)(2)] (example) closed by `sorry` -- quarantined to branch sorry-quarantine-SIDE-kernel; recorded in ERRATA.md.

-- =========================================================
-- APPROACH 2: show it's in range of ofReal
-- =========================================================

-- f_modif is built from:
--   f = ofReal ∘ evenKernel 0
--   f₀ = 1 (= ofReal 1)
--   g₀ = 1 (= ofReal 1)
--   ε = 1
--   k = 1/2
--   x^(-k) is real for x > 0

-- Check what hurwitzEvenFEPair fields unfold to
example : (hurwitzEvenFEPair 0).f₀ = 1 := by rfl
example : (hurwitzEvenFEPair 0).g₀ = 1 := by rfl
example : (hurwitzEvenFEPair 0).ε = 1 := by rfl
example : (hurwitzEvenFEPair 0).k = 1 / 2 := by rfl

-- The f field
example (x : ℝ) : (hurwitzEvenFEPair 0).f x = (↑(evenKernel 0 x) : ℂ) := by rfl

-- =========================================================
-- APPROACH 3: direct computation with indicator cases
-- =========================================================

-- indicator_apply: S.indicator f x = if x ∈ S then f x else 0
-- Pi.add_apply: (f + g) x = f x + g x

-- [b648, (R258)(2)] (example) closed by `sorry` -- quarantined to branch sorry-quarantine-SIDE-kernel; recorded in ERRATA.md.
