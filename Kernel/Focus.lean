import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.NumberTheory.LSeries.Nonvanishing
import Kernel.SchwarzDischarge

open Complex

namespace Focus

theorem conj_half_plus_it (t : Real) :
    (starRingEnd ℂ) (⟨1/2, t⟩ : ℂ) = 1 - (⟨1/2, t⟩ : ℂ) := by
  apply Complex.ext_iff.mpr
  constructor
  · simp [Complex.conj_re, Complex.sub_re, Complex.one_re]; ring
  · simp [Complex.conj_im, Complex.sub_im, Complex.one_im]

theorem focus (t : Real) :
    (completedRiemannZeta₀ ⟨1/2, t⟩).im = 0 := by
  suffices h : (starRingEnd ℂ) (completedRiemannZeta₀ ⟨1/2, t⟩) =
               completedRiemannZeta₀ ⟨1/2, t⟩ by
    exact conj_eq_iff_im.mp h
  -- Schwarz says: Λ₀(conj s) = conj(Λ₀(s))
  -- So: conj(Λ₀(s)) = Λ₀(conj s)
  -- We rewrite the LHS conj(Λ₀(s)) to Λ₀(conj s):
  conv_lhs => rw [← schwarz_reflection_completedZeta₀ ⟨1/2, t⟩]
  -- Now goal: Λ₀(conj(1/2+it)) = Λ₀(1/2+it)
  rw [conj_half_plus_it]
  -- Now goal: Λ₀(1 - (1/2+it)) = Λ₀(1/2+it)
  exact completedRiemannZeta₀_one_sub ⟨1/2, t⟩

theorem euler_closing (s : ℂ) (hs : 1 ≤ s.re) :
    riemannZeta s ≠ 0 :=
  riemannZeta_ne_zero_of_one_le_re hs

theorem fe_symmetry (s : ℂ) :
    completedRiemannZeta₀ (1 - s) = completedRiemannZeta₀ s :=
  completedRiemannZeta₀_one_sub s

end Focus
