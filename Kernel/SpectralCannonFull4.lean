import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Complex.Basic
import Kernel.SchwarzDischarge
import Kernel.SpectralCannon
open Complex

private def ist : IsScalarTower ℝ ℂ ℂ := inferInstance

namespace SpectralCannonFull

theorem conj_hasDerivAt (f : ℝ → ℂ) (f' : ℂ) (x : ℝ) (hf : HasDerivAt f f' x) :
    HasDerivAt (fun x => conjCLE (f x)) (conjCLE f') x := by
  have h := conjCLE.toContinuousLinearMap.hasFDerivAt.comp x hf.hasFDerivAt
  convert h.hasDerivAt using 1
  simp [ContinuousLinearMap.comp_apply, ContinuousLinearMap.toSpanSingleton_apply]
  rfl

theorem hasDerivAt_zeta_line (t σ : ℝ) :
    HasDerivAt (fun x : ℝ => completedRiemannZeta₀ ⟨x, t⟩)
    (deriv completedRiemannZeta₀ ⟨σ, t⟩) σ := by
  have h_embed : HasDerivAt (fun x : ℝ => (⟨x, t⟩ : ℂ)) 1 σ := by
    have h3 := (Complex.ofRealCLM.hasDerivAt (x := σ)).add (hasDerivAt_const σ (⟨0, t⟩ : ℂ))
    have hf : (⇑ofRealCLM + fun _ => (⟨0, t⟩ : ℂ)) = fun x => (⟨x, t⟩ : ℂ) := by
      ext x; apply Complex.ext <;> simp
    have hd : ofRealCLM (1 : ℝ) + (0 : ℂ) = 1 := by simp
    exact hd ▸ hf ▸ h3
  have h_diff := differentiable_completedZeta₀.differentiableAt (x := (⟨σ, t⟩ : ℂ))
  have h_comp := @HasDerivAt.scomp ℝ _ ℂ _ _ σ ℂ _ _ _ ist
    _ _ _ _ h_diff.hasDerivAt h_embed
  simp [Function.comp_def] at h_comp
  exact h_comp

theorem schwarz_deriv (t σ : ℝ) :
    (starRingEnd ℂ) (deriv completedRiemannZeta₀ ⟨σ, t⟩) =
    deriv completedRiemannZeta₀ ⟨σ, -t⟩ := by
  have hf := hasDerivAt_zeta_line t σ
  have hg := hasDerivAt_zeta_line (-t) σ
  have h_schwarz : ∀ x : ℝ,
      completedRiemannZeta₀ ⟨x, -t⟩ =
      conjCLE (completedRiemannZeta₀ ⟨x, t⟩) := by
    intro x
    have h_conj : (⟨x, -t⟩ : ℂ) = (starRingEnd ℂ) ⟨x, t⟩ := by
      apply Complex.ext_iff.mpr; constructor
      · simp [Complex.conj_re]
      · simp [Complex.conj_im]
    rw [h_conj, schwarz_reflection_completedZeta₀]; rfl
  have h_conj_deriv := conj_hasDerivAt
    (fun x => completedRiemannZeta₀ ⟨x, t⟩)
    (deriv completedRiemannZeta₀ ⟨σ, t⟩) σ hf
  have h_eq : ∀ x, conjCLE (completedRiemannZeta₀ ⟨x, t⟩) =
              completedRiemannZeta₀ ⟨x, -t⟩ :=
    fun x => (h_schwarz x).symm
  simp_rw [h_eq] at h_conj_deriv
  have h_unique := hg.unique h_conj_deriv
  rw [h_unique]; rfl

theorem spectral_cannon (t : ℝ) :
    (deriv completedRiemannZeta₀ ⟨1/2, t⟩).re = 0 := by
  have h_fe := SpectralCannon.deriv_at_half t
  have h_schwarz := schwarz_deriv t (1/2)
  have h_anti : deriv completedRiemannZeta₀ ⟨1/2, t⟩ =
      -((starRingEnd ℂ) (deriv completedRiemannZeta₀ ⟨1/2, t⟩)) := by
    rw [h_schwarz]; exact h_fe
  have h_re := congr_arg Complex.re h_anti
  simp [Complex.neg_re, Complex.conj_re] at h_re
  linarith

end SpectralCannonFull
