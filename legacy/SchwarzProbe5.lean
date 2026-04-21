import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.Deriv.Basic

open Complex HurwitzZeta MeasureTheory Set

-- =========================================================
-- PROBE: find the right name for set integral congr
-- =========================================================

#check @MeasureTheory.setIntegral_congr_fun
#check @set_integral_congr
#check @setIntegral_congr
#check @MeasureTheory.set_integral_congr
#check @integral_congr_ae

-- Try with explicit namespace
example (f g : ℝ → ℂ) (hfg : ∀ t ∈ Ioi (0:ℝ), f t = g t) :
    ∫ t in Ioi (0:ℝ), f t = ∫ t in Ioi (0:ℝ), g t := by
  exact?
