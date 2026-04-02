import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.NumberTheory.LSeries.Nonvanishing
import Kernel.SchwarzDischarge
import Kernel.Focus

open Complex

namespace ThomBridge

/-- Antisymmetry: Λ₀((1-σ)+it) = conj(Λ₀(σ+it)) -/
theorem antisymmetry (sigma t : Real) :
    completedRiemannZeta₀ ⟨1 - sigma, t⟩ =
    (starRingEnd ℂ) (completedRiemannZeta₀ ⟨sigma, t⟩) := by
  have h_fe := completedRiemannZeta₀_one_sub (⟨sigma, -t⟩ : ℂ)
  have h_conj : (⟨sigma, -t⟩ : ℂ) = (starRingEnd ℂ) ⟨sigma, t⟩ := by
    apply Complex.ext_iff.mpr; constructor
    · simp [Complex.conj_re]
    · simp [Complex.conj_im]
  have h_one_sub : (1 : ℂ) - ⟨sigma, -t⟩ = ⟨1 - sigma, t⟩ := by
    apply Complex.ext_iff.mpr; constructor
    · simp [Complex.sub_re, Complex.one_re, Complex.ofReal_re]
    · simp [Complex.sub_im, Complex.one_im, Complex.ofReal_im]
  rw [h_one_sub, h_conj] at h_fe
  rw [h_fe, schwarz_reflection_completedZeta₀]

theorem im_odd (sigma t : Real) :
    (completedRiemannZeta₀ ⟨sigma, t⟩).im =
    -(completedRiemannZeta₀ ⟨1 - sigma, t⟩).im := by
  rw [antisymmetry]
  simp [Complex.conj_im]

theorem focus_from_antisymmetry (t : Real) :
    (completedRiemannZeta₀ ⟨1/2, t⟩).im = 0 := by
  have h := im_odd (1/2) t
  have h_eq : (1 : Real) - 1/2 = 1/2 := by ring
  rw [h_eq] at h
  linarith

theorem c1_closing : ∀ t : Real,
    (completedRiemannZeta₀ ⟨1/2, t⟩).im = 0 :=
  focus_from_antisymmetry

theorem c4_closing : ∀ s : ℂ, 1 ≤ s.re → riemannZeta s ≠ 0 :=
  fun s hs => riemannZeta_ne_zero_of_one_le_re hs

-- gate_e_from_codim2 and rh_statement REMOVED in v65.
-- They used SIDEAxiom.rh which was vacuously true
-- (completedRiemannZeta₀ has no strip zeros).
-- The live content above (antisymmetry, im_odd, focus, c1, c4)
-- is proved with 0 axioms, 0 sorry.

end ThomBridge
