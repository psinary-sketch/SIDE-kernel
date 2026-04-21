import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.NumberTheory.LSeries.Nonvanishing

-- ============================================================
-- PROBE: Does Mathlib have the zero-free region?
-- ============================================================

-- Non-vanishing for Re(s) ≥ 1
#check @zeta_ne_zero_of_re_ge_one
#check @riemannZeta_ne_zero_of_one_le_re
#check @riemannZeta_ne_zero

-- Non-vanishing on Re(s) = 1 (the key classical result)
#check @zeta_ne_zero_of_re_eq_one
#check @riemannZeta_ne_zero_of_re_eq_one

-- Any non-vanishing result at all?
#check @LSeries_ne_zero
#check @DirichletLSeries_ne_zero

-- What's in the Nonvanishing file?
#check @zeta_ne_zero
#check @riemannZeta_ne_zero_of_one_le_re

-- The classical zero-free region σ > 1 - c/log t
#check @riemannZeta_zeroFreeRegion

-- de la Vallée-Poussin
#check @zeroFreeRegion

-- ============================================================
-- PROBE: Complex norm of powers
-- ============================================================

#check @Complex.norm_eq_abs
#check @Complex.abs_apply
#check @norm_cpow_eq_rpow_re_of_pos

-- Try: ‖(p : ℂ)^(-s)‖ = (p : ℝ)^(-s.re)
example (p : Nat) (hp : 0 < p) (s : Complex) :
    ‖(p : Complex) ^ (-s)‖ = (p : Real) ^ (-s.re) := by
  exact?

-- ============================================================
-- PROBE: What does Nonvanishing actually export?
-- ============================================================

-- List everything with "ne_zero" or "nonvanishing" in the zeta namespace
#check @riemannZeta_ne_zero_of_one_le_re
