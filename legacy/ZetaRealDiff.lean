import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Complex.Basic

noncomputable def completedZeta_real_differentiable :
    Differentiable ℝ completedRiemannZeta₀ :=
  differentiable_completedZeta₀.restrictScalars ℝ
