import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.InverseFunctionTheorem.FDeriv
import Mathlib.Analysis.Analytic.Basic
import Mathlib.Analysis.Analytic.IsolatedZeros
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.IteratedDeriv.Defs
import Mathlib.Topology.Order.Basic

open Complex Filter Topology

-- =========================================================
-- IDENTITY THEOREM BUILD v1
--
-- Goal: If f : ℂ → ℂ is analytic on a connected open set U,
-- and f vanishes on a set with an accumulation point in U,
-- then f = 0 on all of U.
--
-- PROOF PLAN:
-- 1. At accumulation point z₀, all power series coefficients = 0
--    (by contradiction using local injectivity at simple zeros)
-- 2. f = 0 on convergence disc around z₀
-- 3. Set S = {z : f =ᶠ[nhds z] 0} is open (trivially)
-- 4. S is closed in U (limit of points where all derivs = 0
--    → all derivs = 0 at limit → power series = 0 at limit)
-- 5. U connected + S nonempty → S = U
-- =========================================================

-- =========================================================
-- SECTION 1: PROBE — what tools exist for power series?
-- =========================================================

-- Power series type
#check FormalMultilinearSeries
#check HasFPowerSeriesAt
#check HasFPowerSeriesOnBall

-- Key question: can we access individual coefficients?
-- And relate them to iterated derivatives?
#check HasFPowerSeriesAt.coeff_zero

-- Iterated derivatives
#check iteratedDeriv
#check iteratedFDeriv

-- Does Mathlib link power series coefficients to iterated derivs?
#check HasFPowerSeriesAt.iteratedFDeriv_eq

-- Can we show: if all coefficients are zero, function is zero on disc?
#check HasFPowerSeriesOnBall.sum

-- =========================================================
-- SECTION 2: PROBE — local injectivity from nonzero derivative
-- =========================================================

-- The chain: f'(z₀) ≠ 0 → HasStrictFDerivAt → localInverse → injective near z₀

-- Step 1: Analytic → HasFPowerSeriesAt
#check Differentiable.analyticAt

-- Step 2: HasFPowerSeriesAt → HasStrictFDerivAt
#check HasFPowerSeriesAt.hasStrictFDerivAt

-- Step 3: HasStrictFDerivAt → local inverse (for ℂ → ℂ, need equiv)
-- For f : ℂ → ℂ with f'(z₀) ≠ 0, the derivative as ContinuousLinearMap
-- is multiplication by f'(z₀), which is invertible.
-- Can we build the ContinuousLinearEquiv?
#check ContinuousLinearMap.smulRight
#check ContinuousLinearEquiv.ofBijective

-- Step 4: IFT gives local homeomorphism
#check HasStrictFDerivAt.to_localInverse

-- =========================================================
-- SECTION 3: PROBE — connectivity and clopen
-- =========================================================

#check IsPreconnected.subset_of_isClopen
#check IsPreconnected
#check IsClopen
#check isPreconnected_univ

-- For an open set U ⊆ ℂ, is U connected in the subspace topology?
-- We might need to work with Set.univ if dealing with entire functions.

-- =========================================================
-- SECTION 4: PROBE — continuity of iterated derivatives
-- =========================================================

-- If f is differentiable on ℂ, are iteratedDeriv n f continuous?
#check Differentiable.contDiff
-- contDiff → iterated derivatives exist and are continuous?
#check ContDiff.continuous_iteratedDeriv

-- =========================================================
-- SECTION 5: ATTEMPT — simple zero isolation
-- This is the core building block.
-- =========================================================

-- For f : ℂ → ℂ entire, f(z₀)=0, f'(z₀)≠0:
-- f is locally injective near z₀, so z₀ is isolated in f⁻¹{0}

-- First: build the ContinuousLinearEquiv from f'(z₀) ≠ 0
-- For ℂ → ℂ, the derivative at z₀ is the ContinuousLinearMap
-- "multiply by f'(z₀)". If f'(z₀) ≠ 0, this is invertible.

noncomputable def smul_equiv (c : ℂ) (hc : c ≠ 0) : ℂ ≃L[ℂ] ℂ where
  toLinearEquiv := {
    toFun := fun z => c * z
    map_add' := mul_add c
    map_smul' := fun a z => by ring
    invFun := fun z => c⁻¹ * z
    left_inv := fun z => by simp [mul_assoc, inv_mul_cancel₀ hc]
    right_inv := fun z => by simp [mul_assoc, mul_inv_cancel₀ hc]
  }
  continuous_toFun := continuous_const.mul continuous_id
  continuous_invFun := continuous_const.mul continuous_id

-- Now: f'(z₀) ≠ 0 → HasStrictFDerivAt f (equiv) z₀ → locally injective
-- The HasStrictFDerivAt gives us the derivative as a ContinuousLinearMap.
-- We need to match it with our equiv.

-- The derivative ContinuousLinearMap for f : ℂ → ℂ at z₀ is
-- (ContinuousLinearMap.smulRight 1 (deriv f z₀)) which maps h ↦ h • deriv f z₀
-- For ℂ, this is h ↦ deriv(f, z₀) * h (after smul = mul).
-- Hmm, or is it h ↦ h * deriv(f, z₀)?

-- Let's check the actual form:
-- HasFPowerSeriesAt.hasStrictFDerivAt gives:
--   HasStrictFDerivAt f ((continuousMultilinearCurryFin1 ℂ ℂ ℂ) (p 1)) z₀
-- where p is the power series.

-- Alternative simpler path: 
-- Differentiable → HasDerivAt → HasStrictDerivAt?
#check HasDerivAt.hasStrictDerivAt
-- Does this exist? If so, we get HasStrictFDerivAt directly.

-- From HasStrictDerivAt, we can get local injectivity:
#check HasStrictDerivAt.localInverse

-- =========================================================
-- SECTION 6: ATTEMPT — the core isolation lemma
-- =========================================================

-- If f is entire and f(z₀) = 0 and f'(z₀) ≠ 0,
-- then ∃ ε > 0, ∀ z, ‖z - z₀‖ < ε → z ≠ z₀ → f(z) ≠ 0

lemma simple_zero_isolated
    (f : ℂ → ℂ) (z₀ : ℂ)
    (hf : Differentiable ℂ f)
    (hz : f z₀ = 0)
    (hd : deriv f z₀ ≠ 0) :
    ∀ᶠ z in nhdsWithin z₀ {z₀}ᶜ, f z ≠ 0 := by
  -- f'(z₀) ≠ 0 → locally injective → isolated zero
  -- Step 1: get HasStrictDerivAt
  have h_da : HasDerivAt f (deriv f z₀) z₀ := hf.differentiableAt.hasDerivAt
  sorry -- need HasDerivAt → HasStrictDerivAt for analytic functions

-- =========================================================
-- SECTION 7: ATTEMPT — accumulation kills all coefficients
-- =========================================================

-- If f is entire and f(zₙ) = 0 for zₙ → z₀ with zₙ ≠ z₀,
-- then all iterated derivatives of f at z₀ are zero.

lemma accumulation_kills_derivs
    (f : ℂ → ℂ) (z₀ : ℂ)
    (hf : Differentiable ℂ f)
    (hacc : ∃ (z : ℕ → ℂ), (∀ n, f (z n) = 0) ∧ (∀ n, z n ≠ z₀) ∧
            Tendsto z atTop (nhds z₀)) :
    ∀ n : ℕ, iteratedDeriv n f z₀ = 0 := by
  sorry -- induction using simple_zero_isolated

-- =========================================================
-- SECTION 8: Check what's available for HasStrictDerivAt
-- =========================================================

#check hasStrictDerivAt_of_isLittleO_pow
-- Does HasDerivAt.hasStrictDerivAt exist for analytic functions?
-- Or can we go through ContDiff?

-- ContDiff → HasStrictFDerivAt?
#check ContDiff.hasStrictFDerivAt
-- This might be the route!
-- Differentiable on ℂ → ContDiff ℂ ∞ → HasStrictFDerivAt

-- Let's test:
example (f : ℂ → ℂ) (z₀ : ℂ) (hf : Differentiable ℂ f) :
    HasStrictFDerivAt f (fderiv ℂ f z₀) z₀ := by
  exact hf.contDiff.hasStrictFDerivAt le_top

-- =========================================================
-- SECTION 9: From HasStrictFDerivAt to local injectivity
-- =========================================================

-- If f'(z₀) ≠ 0 as a complex number, then fderiv ℂ f z₀
-- is an invertible ContinuousLinearMap.
-- HasStrictFDerivAt + invertible → InjOn in some nhd.

#check HasStrictFDerivAt.map_nhds_eq_of_equiv

-- Can we state: f injective on some ball around z₀?
#check HasStrictFDerivAt.localInverse
-- This needs f' as a ContinuousLinearEquiv, not just ContinuousLinearMap.

-- So the question is: deriv f z₀ ≠ 0 → fderiv ℂ f z₀ is a ContinuousLinearEquiv
-- For ℂ → ℂ, fderiv ℂ f z₀ is the ContinuousLinearMap h ↦ f'(z₀) * h
-- (or h ↦ h * f'(z₀), but ℂ is commutative).
-- This is invertible iff f'(z₀) ≠ 0.

-- Can we build the equiv?
example (f : ℂ → ℂ) (z₀ : ℂ) (hf : Differentiable ℂ f) (hd : deriv f z₀ ≠ 0) :
    ∃ (e : ℂ ≃L[ℂ] ℂ), (e : ℂ →L[ℂ] ℂ) = fderiv ℂ f z₀ := by
  sorry -- need to construct from deriv f z₀ ≠ 0
