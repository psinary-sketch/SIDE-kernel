import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Schwarz Reflection Discharge

Goal: Prove completedRiemannZeta₀(conj s) = conj(completedRiemannZeta₀(s))

Strategy:
  completedRiemannZeta₀ s = (hurwitzEvenFEPair 0).Λ₀ (s/2) / 2
                          = mellin (hurwitzEvenFEPair 0).f_modif (s/2) / 2

  The kernel f_modif is real-valued (built from ofReal ∘ evenKernel).
  For real-valued kernels, mellin commutes with conjugation.

Available tools (confirmed in Mathlib 4.29.0):
  - integral_conj: ∫ conj(f x) = conj(∫ f x)
  - Complex.cpow_conj: x ^ conj(n) = conj(conj(x) ^ n) when arg(x) ≠ π
  - conj_ofReal: conj((x : ℂ)) = (x : ℂ) for x : ℝ
  - starRingEnd_self_apply: conj(conj(x)) = x
-/

open Complex HurwitzZeta MeasureTheory Set

-- =========================================================
-- STEP 1: Can we unfold completedRiemannZeta₀ to mellin?
-- =========================================================

-- Test: does the definitional unfolding work?
example (s : ℂ) : completedRiemannZeta₀ s =
    HurwitzZeta.completedHurwitzZetaEven₀ 0 s := by
  rfl

-- Next level
example (s : ℂ) : HurwitzZeta.completedHurwitzZetaEven₀ 0 s =
    (hurwitzEvenFEPair 0).Λ₀ (s / 2) / 2 := by
  rfl

-- Full chain
example (s : ℂ) : completedRiemannZeta₀ s =
    mellin (hurwitzEvenFEPair 0).f_modif (s / 2) / 2 := by
  rfl

-- =========================================================
-- STEP 2: conj(s/2) = conj(s)/2
-- =========================================================

example (s : ℂ) : starRingEnd ℂ (s / 2) = starRingEnd ℂ s / 2 := by
  exact map_div₀ (starRingEnd ℂ) s 2

-- =========================================================
-- STEP 3: conj(x / 2) = conj(x) / 2 for the outer division
-- =========================================================

-- Same lemma works

-- =========================================================
-- STEP 4: mellin conjugation for real-valued functions
--
-- mellin f s = ∫ t in Ioi 0, t^(s-1) • f(t)
-- conj(mellin f s) = ∫ t in Ioi 0, conj(t^(s-1) • f(t))
--                  = ∫ t in Ioi 0, conj(t^(s-1)) • conj(f(t))
--                  = ∫ t in Ioi 0, t^(conj(s)-1) • f(t)  [if f real-valued]
--                  = mellin f (conj s)
-- =========================================================

-- First: conj of smul
example (a b : ℂ) : starRingEnd ℂ (a • b) = starRingEnd ℂ a • starRingEnd ℂ b := by
  simp [smul_eq_mul, map_mul]

-- Key: for t > 0 real, conj(↑t ^ w) = ↑t ^ conj(w)
-- From cpow_conj: x ^ conj(n) = conj(conj(x) ^ n) when arg(x) ≠ π
-- For ↑t with t > 0: conj(↑t) = ↑t (real), and arg(↑t) = 0 ≠ π
-- So: ↑t ^ conj(n) = conj(↑t ^ n) ✓

example (t : ℝ) (ht : 0 < t) (w : ℂ) :
    (t : ℂ) ^ (starRingEnd ℂ w) = starRingEnd ℂ ((t : ℂ) ^ w) := by
  rw [cpow_conj]
  · simp [conj_ofReal]
  · simp [arg_ofReal_of_pos ht]

-- =========================================================
-- STEP 5: Try the full proof
-- =========================================================

-- Rewrite target using definitional unfolding
-- [b648, (R258)(2)] schwarz_discharge closed by `sorry` -- quarantined to branch sorry-quarantine-SIDE-kernel; recorded in ERRATA.md.
