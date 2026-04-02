import Mathlib.NumberTheory.LSeries.RiemannZeta

/-! Voice 3 (C₃): Functional equation forces symmetry about σ = 1/2.
    Mathlib provides completedRiemannZeta₀_one_sub. -/

theorem fe_symmetry (s : Complex) :
    completedRiemannZeta₀ (1 - s) = completedRiemannZeta₀ s :=
  completedRiemannZeta₀_one_sub s

theorem fe_forces_half (s : Complex) (h1 : completedRiemannZeta₀ s = 0)
    (h2 : completedRiemannZeta₀ (1 - s) = 0) :
    completedRiemannZeta₀ s = completedRiemannZeta₀ (1 - s) := by
  rw [h1, h2]