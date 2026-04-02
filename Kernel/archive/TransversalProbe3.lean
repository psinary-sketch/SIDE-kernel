import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.InverseFunctionTheorem.FDeriv
import Mathlib.Analysis.Analytic.Order
import Mathlib.Analysis.Analytic.IsolatedZeros

open Complex

-- =========================================================
-- TRANSVERSAL PROBE v3: Extract actual type signatures
-- Compile with: lake env lean Kernel\TransversalProbe3.lean 2>&1
-- =========================================================

-- SECTION A: Analyticity bridge
#check @Differentiable.analyticAt
-- Expected: Differentiable → AnalyticAt

-- SECTION B: Order API — the money tools
#check @AnalyticAt.order
#check @AnalyticAt.order_eq_zero_iff
#check @AnalyticAt.order_eq_one_iff
#check @AnalyticAt.order_eq_nat_iff
#check @AnalyticAt.order_pos

-- SECTION C: Zero isolation
#check @AnalyticAt.eventually_ne
#check @AnalyticAt.eventually_eq_zero_or_self

-- SECTION D: Identity theorem
#check @AnalyticOn.eqOn_of_preconnected_of_eventuallyEq
#check @AnalyticOn.eq_of_eventuallyEq

-- SECTION E: IFT
#check @HasStrictFDerivAt.localInverse
#check @HasStrictFDerivAt.to_localHomeomorph

-- SECTION F: Argument principle / residue
-- These might not exist — check carefully
-- #check @DiffContOnCl.sum_residues

-- SECTION G: Open mapping / maximum principle for analytic
-- #check @AnalyticAt.isOpenMap
-- Try alternates:
#check @IsPreconnected
#check @Differentiable.apply_eq_apply_of_ne

-- SECTION H: The critical connection —
-- can we go from "order = 1 at all zeros on line"
-- to "no zeros off line"?

-- What does Mathlib know about zeros of entire functions?
#check @AnalyticOn.eqOn_zero_of_preconnected_of_eventuallyEq_zero

-- SECTION I: HasStrictFDerivAt for analytic functions
#check @AnalyticAt.hasFPowerSeriesAt
#check @HasFPowerSeriesAt.hasStrictFDerivAt

-- SECTION J: Preimage of zero under analytic map
-- Is the zero set of an analytic function discrete?
#check @AnalyticAt.eventually_ne

-- SECTION K: Connected components
#check @isPreconnected_univ
#check @IsConnected.isPreconnected

-- SECTION L: Critical — ξ has finitely many zeros in any bounded region?
-- Or: the zeros of ξ form a discrete set?
-- This follows from analyticity + not identically zero.
-- Can we state "completedRiemannZeta₀ is not identically zero"?

-- Quick test: can we get a specific nonzero value?
-- Λ₀(2) should be computable and nonzero
-- Or: ζ(2) = π²/6 ≠ 0

-- SECTION M: The cleanest possible approach
-- If we can show:
-- (1) Λ₀ is analytic (✅ from Differentiable)
-- (2) Λ₀ is not identically zero
-- (3) Every zero of Λ₀ that lies on σ=1/2 is simple
-- (4) Λ₀(1-s) = Λ₀(s)
-- (5) Λ₀(conj s) = conj(Λ₀(s))
-- Then: ???
--
-- The gap: (1)-(5) don't logically imply all zeros on line
-- without COUNTING. We need:
-- "The number of zeros with 0<t<T equals the number of
--  sign changes of Λ₀ on the critical line with 0<t<T"
--
-- OR we need a different approach entirely.
-- 
-- ALTERNATIVE: Can we prove transversality_bridge by contradiction?
-- Assume s₀ off-line is a zero. Then:
-- - 1-s₀ is a zero (FE)
-- - conj(s₀) is a zero (Schwarz)
-- - 1-conj(s₀) is a zero
-- These are 4 points (or 2 if s₀ is on σ=1/2).
-- With σ₀ ≠ 1/2, we have 4 distinct zeros.
-- But that alone doesn't give contradiction.
--
-- What if σ₀ = 0? Then 1-s₀ has σ=1. 
-- Do we know Λ₀ has no zeros on σ=0 or σ=1? 
-- Hardy-Littlewood proved zeros exist on the line,
-- but that's the wrong direction.
--
-- CONCLUSION: transversality_bridge likely needs either
-- (a) argument principle / zero counting from Mathlib
-- (b) a clever identity theorem argument
-- (c) something about the zero DENSITY on the line vs off it
--
-- Let's check what exists for (a):

-- Residue theorem / winding numbers?
#check Complex.circleIntegral_sub_inv_smul
-- This is Cauchy's integral formula!

-- Winding number?
-- #check Complex.windingNumber

-- Logarithmic derivative?
-- If f'/f is analytic except at zeros, and we can integrate...
-- This is the argument principle path.

-- FINAL CHECK: what about the specific structure of ζ?
-- Does Mathlib have anything about zero-free regions?
#check ZetaFunction
