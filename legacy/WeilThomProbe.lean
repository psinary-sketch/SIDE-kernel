import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.NumberTheory.VonMangoldt
import Mathlib.Analysis.Complex.Basic
import Mathlib.Topology.Basic

-- ============================================================
-- PROBE A: Weil explicit formula components
-- ============================================================

-- Von Mangoldt function
#check @ArithmeticFunction.vonMangoldt
#check @ArithmeticFunction.vonMangoldt_apply_prime_pow

-- Log derivative of zeta
#check @riemannZeta_residue_one
#check @differentiable_completedZeta₀

-- Hadamard product / zero counting
#check @riemannZeta_ne_zero_of_one_le_re

-- Does any explicit formula exist?
#check @ArithmeticFunction.LSeries
#check @ArithmeticFunction.LSeriesHasSum

-- Perron's formula?
-- #check @perron

-- ============================================================
-- PROBE B: Thom transversality prerequisites
-- ============================================================

-- Implicit function theorem
#check @HasStrictFDerivAt
#check @ContDiff

-- Sard's theorem / transversality
-- #check @Sard
-- #check @transversal

-- Morse theory basics
-- #check @Morse

-- ============================================================
-- PROBE C: Alternative — IVT + uniqueness approach
-- ============================================================

-- If Im(ξ) is odd about σ=1/2 (proved) and the derivative
-- at a zero is purely imaginary (proved), then Im(ξ) departs
-- with nonzero slope. For an off-line zero, Im must return
-- to zero — but monotonicity prevents this.
--
-- Can we formalize monotonicity from Cauchy-Riemann?

#check @HasDerivAt.pos_of_eq_zero
#check @StrictMono
#check @MonotonOn

-- IVT and mean value theorem
#check @intermediate_value_Icc
#check @exists_hasDerivAt_eq_zero

-- Rolle's theorem — if f(a) = f(b) = 0 then f'(c) = 0 for some c
#check @exists_hasDerivAt_eq_zero

-- ============================================================
-- PROBE D: What about HasDerivAt for ξ along curves?
-- ============================================================

-- We proved: hasDerivAt_zeta_line (sorry for IsScalarTower)
-- But we CAN work with ℝ→ℂ functions directly

-- The key monotonicity fact: if f : ℝ → ℝ has f(0) = 0 and f'(0) ≠ 0,
-- then f doesn't return to zero in a neighborhood.
-- This is just: nonzero derivative → locally injective

#check @HasDerivAt.localInverse
#check @HasStrictDerivAt.localInverse

-- For GLOBAL monotonicity along Re=0 curves, need more.
-- But for LOCAL non-vanishing near σ=1/2, local inverse suffices.

-- ============================================================
-- PROBE E: Can we state RH as "ξ has no zeros in open set"?
-- ============================================================

-- If we prove: for each zero ρ on σ=1/2, ξ has no zeros
-- in a punctured neighborhood of ρ off the critical line,
-- AND the zero-free region from Euler closes the rest,
-- we'd have RH.

-- Local non-vanishing from simplicity:
-- ξ'(ρ) ≠ 0 → ξ is locally injective near ρ
-- → ξ has no other zeros near ρ (since ξ(ρ) = 0, injectivity
--   means no other point maps to 0)

#check @HasStrictDerivAt.eventually_ne
-- This might say: if f'(x) ≠ 0 and f(x) = 0,
-- then f(y) ≠ 0 for y near x with y ≠ x
