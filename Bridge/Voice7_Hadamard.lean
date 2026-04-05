import Mathlib.NumberTheory.LSeries.RiemannZeta

open HurwitzZeta

#check @differentiableAt_completedHurwitzZetaEven
#check @completedRiemannZeta₀
-- Try to prove it via the Hurwitz route
example (s : Complex) : DifferentiableAt Complex completedRiemannZeta₀ s :=
  differentiable_completedZeta₀.differentiableAt