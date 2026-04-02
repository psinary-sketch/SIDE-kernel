import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Comp

open Complex

namespace SpectralCannon

theorem hasDerivAt_one_sub (s : ℂ) :
    HasDerivAt (fun z : ℂ => 1 - z) (-1) s := by
  have h1 : HasDerivAt (fun z : ℂ => (1 : ℂ)) 0 s := hasDerivAt_const s 1
  have h2 : HasDerivAt (fun z : ℂ => z) 1 s := hasDerivAt_id s
  have := h1.sub h2
  simp at this
  exact this

theorem deriv_fe (s : ℂ) :
    deriv completedRiemannZeta₀ s =
    -(deriv completedRiemannZeta₀ (1 - s)) := by
  have h_fe : (fun z => completedRiemannZeta₀ (1 - z)) = completedRiemannZeta₀ := by
    ext z; exact completedRiemannZeta₀_one_sub z
  have h_lhs : deriv (fun z => completedRiemannZeta₀ (1 - z)) s =
    -(deriv completedRiemannZeta₀ (1 - s)) := by
    rw [show (fun z => completedRiemannZeta₀ (1 - z)) =
        completedRiemannZeta₀ ∘ (fun z => 1 - z) from rfl]
    rw [deriv.scomp s differentiable_completedZeta₀.differentiableAt
        (hasDerivAt_one_sub s).differentiableAt]
    have : deriv (fun z : ℂ => 1 - z) s = -1 :=
      (hasDerivAt_one_sub s).deriv
    rw [this]; simp [smul_eq_mul]
  have h_rhs : deriv (fun z => completedRiemannZeta₀ (1 - z)) s =
    deriv completedRiemannZeta₀ s := by
    rw [h_fe]
  rw [← h_rhs, h_lhs]

theorem deriv_at_half (t : ℝ) :
    deriv completedRiemannZeta₀ ⟨1/2, t⟩ =
    -(deriv completedRiemannZeta₀ ⟨1/2, -t⟩) := by
  have h := deriv_fe ⟨1/2, t⟩
  have h_eq : (1 : ℂ) - ⟨1/2, t⟩ = ⟨1/2, -t⟩ := by
    apply Complex.ext_iff.mpr; constructor
    · simp; ring
    · simp
  rw [h_eq] at h; exact h

-- REMOVED: replaced by SimplicityClosure.all_zeros_simple_from_baker
-- axiom all_zeros_simple :
--     ∀ (s : ℂ), completedRiemannZeta₀ s = 0 →
--     0 < s.re → s.re < 1 →
--     deriv completedRiemannZeta₀ s ≠ 0

end SpectralCannon
