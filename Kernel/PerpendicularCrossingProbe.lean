/-
  PerpendicularCrossingProbe.lean
  The perpendicular crossing theorem: Re(Λ₀'(1/2 + it)) = 0 for all real t.

  Zero axioms. Zero sorry. Fully discharged via path differentiation
  of the Focus identity Im(Λ₀(1/2 + it)) = 0.
-/

import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Complex.RealDeriv
-- Self-contained: no kernel imports needed

open Complex

-- ================================================================
-- PART I: Differentiated functional equation (from SpectralCannon)
-- ================================================================

theorem hasDerivAt_one_sub (s : ℂ) :
    HasDerivAt (fun z : ℂ => 1 - z) (-1) s := by
  have h1 : HasDerivAt (fun z : ℂ => (1 : ℂ)) 0 s := hasDerivAt_const s 1
  have h2 : HasDerivAt (fun z : ℂ => z) 1 s := hasDerivAt_id s
  have := h1.sub h2
  simp at this
  exact this

theorem deriv_completedRiemannZeta₀_one_sub (s : ℂ) :
    deriv completedRiemannZeta₀ s = -(deriv completedRiemannZeta₀ (1 - s)) := by
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

-- Im(Λ₀(1/2 + it)) = 0 — self-contained proof via Mellin representation
-- (Same argument as Kernel.SchwarzDischarge + Kernel.Focus, inlined)
private lemma conj_ofReal_two : (starRingEnd ℂ) (2 : ℂ) = 2 := by
  exact_mod_cast conj_ofReal 2

private lemma schwarz_reflection (s : ℂ) :
    completedRiemannZeta₀ (starRingEnd ℂ s) = starRingEnd ℂ (completedRiemannZeta₀ s) := by
  show mellin (HurwitzZeta.hurwitzEvenFEPair 0).f_modif (starRingEnd ℂ s / 2) / 2 =
    starRingEnd ℂ (mellin (HurwitzZeta.hurwitzEvenFEPair 0).f_modif (s / 2) / 2)
  rw [map_div₀, conj_ofReal_two]; congr 1
  simp only [mellin]
  have hpt {t : ℝ} (ht : t ∈ Set.Ioi 0) :
    (↑t : ℂ) ^ ((starRingEnd ℂ) s / 2 - 1) • (HurwitzZeta.hurwitzEvenFEPair 0).f_modif t =
      (starRingEnd ℂ) ((↑t : ℂ) ^ (s / 2 - 1) •
        (HurwitzZeta.hurwitzEvenFEPair 0).f_modif t) := by
    simp only [smul_eq_mul, map_mul]; congr 1
    · rw [show starRingEnd ℂ s / 2 - 1 = starRingEnd ℂ (s / 2 - 1) from by
        rw [map_sub, map_div₀, conj_ofReal_two, map_one]]
      rw [cpow_conj]; simp [conj_ofReal]
      rw [arg_ofReal_of_nonneg (le_of_lt ht)]; exact Real.pi_pos.ne
    · rw [eq_comm, Complex.conj_eq_iff_im]
      simp only [WeakFEPair.f_modif, Pi.add_apply, Set.indicator_apply]
      split_ifs <;> simp [Complex.add_im, Complex.sub_im, Complex.ofReal_im,
        Complex.one_im, Complex.zero_im, HurwitzZeta.hurwitzEvenFEPair]
  calc ∫ t in Set.Ioi (0 : ℝ), (↑t : ℂ) ^ ((starRingEnd ℂ) s / 2 - 1) •
        (HurwitzZeta.hurwitzEvenFEPair 0).f_modif t
      = ∫ t in Set.Ioi (0 : ℝ), (starRingEnd ℂ) ((↑t : ℂ) ^ (s / 2 - 1) •
        (HurwitzZeta.hurwitzEvenFEPair 0).f_modif t) :=
          MeasureTheory.setIntegral_congr_fun measurableSet_Ioi fun t ht => hpt ht
    _ = (starRingEnd ℂ) (∫ t in Set.Ioi (0 : ℝ), (↑t : ℂ) ^ (s / 2 - 1) •
        (HurwitzZeta.hurwitzEvenFEPair 0).f_modif t) :=
          integral_conj

private lemma focus (t : ℝ) : (completedRiemannZeta₀ ⟨1/2, t⟩).im = 0 := by
  suffices h : (starRingEnd ℂ) (completedRiemannZeta₀ ⟨1/2, t⟩) =
               completedRiemannZeta₀ ⟨1/2, t⟩ by
    exact conj_eq_iff_im.mp h
  rw [← schwarz_reflection]
  have : (starRingEnd ℂ) ⟨(1 : ℝ)/2, t⟩ = 1 - ⟨(1 : ℝ)/2, t⟩ := by
    apply Complex.ext_iff.mpr; constructor
    · simp [Complex.conj_re, Complex.sub_re, Complex.one_re]; ring
    · simp [Complex.conj_im, Complex.sub_im, Complex.one_im]
  rw [this]
  exact completedRiemannZeta₀_one_sub ⟨1/2, t⟩

-- ================================================================
-- PART II: Path differentiation infrastructure
-- ================================================================

private lemma hasDerivAt_half_add_mul_I (z : ℂ) :
    HasDerivAt (fun w : ℂ => (1/2 : ℂ) + w * I) I z := by
  convert (hasDerivAt_const z (1/2 : ℂ)).add ((hasDerivAt_id z).mul_const I) using 1; simp

private lemma hasDerivAt_rotated (z : ℂ) :
    HasDerivAt (fun w => completedRiemannZeta₀ (1/2 + w * I))
      (deriv completedRiemannZeta₀ (1/2 + z * I) * I) z :=
  differentiable_completedZeta₀.differentiableAt.hasDerivAt.comp z (hasDerivAt_half_add_mul_I z)

private lemma half_add_ofReal_mul_I (t : ℝ) :
    (1/2 : ℂ) + (↑t) * I = ⟨1/2, t⟩ := by
  apply Complex.ext <;> simp

set_option backward.isDefEq.respectTransparency false in
private lemma HasDerivAt.im_of_complex {e : ℂ → ℂ} {e' : ℂ} {z : ℝ}
    (h : HasDerivAt e e' z) :
    HasDerivAt (fun x : ℝ => (e x).im) e'.im z := by
  have A : HasFDerivAt ((↑) : ℝ → ℂ) ofRealCLM z := ofRealCLM.hasFDerivAt
  have B :
    HasFDerivAt e ((ContinuousLinearMap.smulRight 1 e' : ℂ →L[ℂ] ℂ).restrictScalars ℝ)
      (ofRealCLM z) :=
    h.hasFDerivAt.restrictScalars ℝ
  have C : HasFDerivAt im imCLM (e (ofRealCLM z)) := imCLM.hasFDerivAt
  simpa using (C.comp z (B.comp z A)).hasDerivAt

-- ================================================================
-- PART III: Spectral cannon — Re(xi'(1/2 + it)) = 0
-- Zero axioms. Proved by path differentiation of Focus.
-- ================================================================

/-- The perpendicular crossing theorem: the derivative of the completed
Riemann zeta function has vanishing real part on the critical line. -/
theorem spectral_cannon (t : ℝ) :
    (deriv completedRiemannZeta₀ (1/2 + ↑t * I)).re = 0 := by
  have hderiv := hasDerivAt_rotated (↑t)
  have him_deriv := hderiv.im_of_complex
  simp only [half_add_ofReal_mul_I] at him_deriv
  have him_const : HasDerivAt (fun s : ℝ => (completedRiemannZeta₀ ⟨1/2, s⟩).im) 0 t := by
    have : (fun s : ℝ => (completedRiemannZeta₀ ⟨1/2, s⟩).im) = fun _ => 0 :=
      funext focus
    rw [this]; exact hasDerivAt_const t (0 : ℝ)
  have h_eq := him_deriv.unique him_const
  simp only [mul_im, I_re, I_im] at h_eq
  have : (1/2 : ℂ) + ↑t * I = ⟨1/2, t⟩ := half_add_ofReal_mul_I t
  rw [this]
  linarith
