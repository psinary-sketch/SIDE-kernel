import Mathlib.NumberTheory.LSeries.RiemannZeta

/-! Voice 6 (C₆): Cauchy-Riemann / holomorphicity.
    riemannZeta is differentiable away from s=1. -/

theorem zeta_differentiable (s : Complex) (hs : s ≠ 1) :
    DifferentiableAt Complex riemannZeta s :=
  differentiableAt_riemannZeta hs

theorem zeta_continuous (s : Complex) (hs : s ≠ 1) :
    ContinuousAt riemannZeta s :=
  (differentiableAt_riemannZeta hs).continuousAt