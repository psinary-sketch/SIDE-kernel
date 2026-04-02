import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Complex.Basic
import Kernel.SpectralCannonFull4

open Complex

private def ist2 : IsScalarTower ℝ ℂ ℂ := inferInstance

namespace Voice1Ext

-- t-direction embedding: t ↦ ⟨σ, t⟩, derivative = I
theorem hasDerivAt_imag_embed (σ t₀ : ℝ) :
    HasDerivAt (fun t : ℝ => (⟨σ, t⟩ : ℂ)) I t₀ := by
  have h_add := (hasDerivAt_const t₀ (⟨σ, 0⟩ : ℂ)).add
    ((Complex.ofRealCLM.hasDerivAt (x := t₀)).const_mul I)
  have hf : (fun _ => (⟨σ, 0⟩ : ℂ)) + (fun y => I * ofRealCLM y) =
            fun t => (⟨σ, t⟩ : ℂ) := by
    ext t; apply Complex.ext <;> simp
  have hd : (0 : ℂ) + I * ofRealCLM 1 = I := by simp
  exact hd ▸ hf ▸ h_add

-- Compose with ξ: F'(t₀) = I · ξ'(⟨σ, t₀⟩)
theorem hasDerivAt_zeta_imag (σ t₀ : ℝ) :
    HasDerivAt (fun t : ℝ => completedRiemannZeta₀ ⟨σ, t⟩)
    (I * deriv completedRiemannZeta₀ ⟨σ, t₀⟩) t₀ := by
  have h_embed := hasDerivAt_imag_embed σ t₀
  have h_diff := differentiable_completedZeta₀.differentiableAt (x := (⟨σ, t₀⟩ : ℂ))
  have h_comp := @HasDerivAt.scomp ℝ _ ℂ _ _ t₀ ℂ _ _ _ ist2
    _ _ _ _ h_diff.hasDerivAt h_embed
  simp [Function.comp_def] at h_comp
  exact h_comp

-- THE BRIDGE: ξ'(ρ) = 0 → F'(t₀) = 0
theorem simplicity_forward (t₀ : ℝ) :
    deriv completedRiemannZeta₀ ⟨1/2, t₀⟩ = 0 →
    deriv (fun t : ℝ => completedRiemannZeta₀ ⟨1/2, t⟩) t₀ = 0 := by
  intro h
  have h_line := hasDerivAt_zeta_imag (1/2) t₀
  rw [h, mul_zero] at h_line
  exact h_line.deriv

-- THE BRIDGE: F'(t₀) = 0 → ξ'(ρ) = 0
theorem simplicity_backward (t₀ : ℝ) :
    deriv (fun t : ℝ => completedRiemannZeta₀ ⟨1/2, t⟩) t₀ = 0 →
    deriv completedRiemannZeta₀ ⟨1/2, t₀⟩ = 0 := by
  intro h
  have h_line := hasDerivAt_zeta_imag (1/2) t₀
  have h_eq := h_line.deriv
  rw [h] at h_eq
  -- h_eq : I * deriv ξ ⟨1/2, t₀⟩ = 0
  exact (mul_eq_zero.mp h_eq.symm).resolve_left I_ne_zero

-- COMBINED: simplicity ↔ real function nonvanishing
theorem simplicity_iff (t₀ : ℝ) :
    deriv completedRiemannZeta₀ ⟨1/2, t₀⟩ = 0 ↔
    deriv (fun t : ℝ => completedRiemannZeta₀ ⟨1/2, t⟩) t₀ = 0 :=
  ⟨simplicity_forward t₀, simplicity_backward t₀⟩

end Voice1Ext
