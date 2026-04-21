import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.InverseFunctionTheorem.FDeriv
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Analytic.Order
import Mathlib.Analysis.Analytic.IsolatedZeros
import Mathlib.Topology.Algebra.Order.LiminfLimsup

open Complex

-- =========================================================
-- TRANSVERSALITY PROBE v2
-- Goal: discharge transversality_bridge from Mathlib
--
-- STRATEGY RECAP:
-- We have: Λ₀ entire, Λ₀(1-s)=Λ₀(s), Λ₀(conj s)=conj(Λ₀(s))
-- We have: Re(Λ₀'(1/2+it))=0  [spectral cannon]
-- We want: AllZerosSimple → all nontrivial zeros on σ=1/2
--
-- APPROACH: At any zero s₀ off the line, Schwarz+FE produce
-- a paired zero at 1-conj(s₀). If s₀ is on the line,
-- simplicity + spectral cannon constrain derivative direction.
-- Key: can we show no off-line zeros exist using these tools?
-- =========================================================

-- ========== SECTION 1: Analyticity of Λ₀ ==========

-- Does Mathlib give us AnalyticAt for completedRiemannZeta₀?
-- differentiable_completedZeta₀ gives Differentiable ℂ Λ₀
-- Differentiable entire functions are analytic

#check differentiable_completedZeta₀
#check Differentiable.analyticAt

-- Can we get AnalyticAt from Differentiable?
example (s : ℂ) : AnalyticAt ℂ completedRiemannZeta₀ s :=
  differentiable_completedZeta₀.analyticAt s

-- ========== SECTION 2: Analytic order API ==========

#check AnalyticAt.order
#check AnalyticAt.order_eq_zero_iff
#check AnalyticAt.order_eq_one_iff
#check AnalyticAt.order_eq_nat_iff
#check AnalyticAt.order_pos

-- Key: order = 1 ↔ f(s₀)=0 ∧ f'(s₀)≠0
-- This IS what "simple zero" means

-- ========== SECTION 3: Zero isolation ==========

#check AnalyticAt.eventually_eq_zero_or_self
#check AnalyticAt.eventually_ne

-- If f is analytic at s₀ and f(s₀)=0 and f is not identically 0,
-- then s₀ is an isolated zero
-- Can we use this?

-- ========== SECTION 4: Identity theorem ==========

#check AnalyticOn.eqOn_of_preconnected_of_eventuallyEq
#check AnalyticOn.eq_of_eventuallyEq

-- If two analytic functions agree on a set with a limit point,
-- they agree everywhere on a connected domain.
-- THIS IS KEY for the argument.

-- ========== SECTION 5: The core argument ==========

-- THE MATHEMATICAL ARGUMENT:
--
-- Suppose for contradiction there exists s₀ = σ₀ + it₀ with
-- σ₀ ≠ 1/2 and Λ₀(s₀) = 0.
--
-- By FE: Λ₀(1-s₀) = Λ₀(s₀) = 0, so 1-s₀ is also a zero.
-- By Schwarz: Λ₀(conj(s₀)) = conj(Λ₀(s₀)) = 0.
--
-- So {s₀, 1-s₀, conj(s₀), 1-conj(s₀)} are all zeros.
-- With σ₀ ≠ 1/2, s₀ ≠ 1-conj(s₀) and conj(s₀) ≠ 1-s₀.
--
-- But wait — this doesn't immediately give a contradiction.
-- We need something more.
--
-- ACTUAL STRATEGY (from the manuscript):
-- The argument principle / zero counting shows ξ(s) has
-- exactly N(T) zeros with 0 < Im(s) < T, and all are
-- accounted for by the critical line.
--
-- SIMPLER STRATEGY (what we can try in Lean):
-- Can we avoid counting and use a topological/analytic argument?
--
-- APPROACH A: Open mapping + real-on-line
-- Λ₀ is real on {σ=1/2}. If Λ₀(s₀)=0 with σ₀≠1/2,
-- then by open mapping theorem, Λ₀ maps a neighborhood
-- of s₀ onto a neighborhood of 0. But Λ₀ also maps
-- nearby points on the critical line to nearby REAL values.
-- ... this doesn't immediately help.
--
-- APPROACH B: Derivative direction + IFT
-- At a simple zero s₀, IFT says the zero set is locally
-- a smooth curve. The tangent direction is perpendicular to
-- Λ₀'(s₀). On the critical line, spectral cannon says
-- Re(Λ₀')=0, so Λ₀' is purely imaginary, so the zero
-- curve is tangent to the REAL direction (horizontal).
-- But the critical line is VERTICAL. Contradiction?
-- NO — tangent perpendicular to Λ₀' which is i·r means
-- perpendicular to vertical = horizontal. Hmm.
-- Actually: zero set tangent = ker(Λ₀') as a real map.
-- Λ₀'(s₀) = ia (purely imaginary). The zero set satisfies
-- Λ₀'(s₀)·δs ≈ 0, so ia·(δσ + i·δt) ≈ 0 means
-- ia·δσ - a·δt ≈ 0, so δt/δσ = i, nonsense in reals...
-- Wait. We need to think of Λ₀ : ℂ → ℂ as ℝ² → ℝ².
-- The zero set of a map ℝ² → ℝ² at a regular point is
-- discrete (0-dimensional), not a curve.
--
-- THAT'S THE KEY INSIGHT:
-- Λ₀ : ℂ → ℂ has real Jacobian of rank 2 at a simple zero
-- (because Λ₀'(s₀) ≠ 0 means the complex derivative is
-- nonzero, which means the 2x2 real Jacobian is invertible).
-- Therefore by IFT, {Λ₀ = 0} is locally a DISCRETE SET
-- near any simple zero. Zeros are isolated.
--
-- We already knew this (analytic + non-identically-zero → 
-- isolated zeros). But the point is stronger:
--
-- APPROACH C: Reflection + isolation + counting
-- All zeros are isolated (analyticity). On the critical line,
-- they're simple by hypothesis. Off the line, FE+Schwarz
-- pair them symmetrically. But we need to show there ARE
-- no off-line zeros — isolation alone doesn't do it.
--
-- APPROACH D: The real approach (Hadamard + argument principle)
-- Classically: N(T) = #{zeros with 0<Im<T} = T/(2π)·log(T/(2πe)) + O(log T)
-- All these zeros are on the critical line (Hardy, etc.)
-- ... but this requires N(T) counting which Mathlib doesn't have.
--
-- APPROACH E: The simplest correct argument
-- Actually, re-read what transversality_bridge says:
-- AllZerosSimple → (every zero of Λ₀ has σ = 1/2)
-- 
-- This is NOT a tautology. AllZerosSimple only says zeros
-- ON THE CRITICAL LINE are simple. It says nothing about
-- off-line zeros directly.
--
-- But wait: FE says Λ₀(1-s)=Λ₀(s). If s₀ is a zero with
-- σ₀≠1/2, then 1-s₀ is also a zero with σ = 1-σ₀ ≠ σ₀.
-- These are distinct points (different real parts).
-- Schwarz says conj(s₀) is also a zero.
--
-- Hmm. The key question: can we show that AllZerosSimple
-- (on the line) forces NO zeros off the line?
--
-- What if we used: the total number of zeros (counting
-- multiplicity) in a region is determined by the argument
-- principle. If all on-line zeros are simple, and the count
-- matches the on-line count... but we need the count.

-- ========== SECTION 6: What Mathlib has for argument principle ==========

#check DiffContOnCl.sum_residues
-- Does this exist? Let's see what's available.

-- ========== SECTION 7: Probing real-valued-on-line more carefully ==========

-- Alternative: Instead of counting, use the functional equation
-- more aggressively.
--
-- Λ₀(s) = Λ₀(1-s)         [FE]
-- Λ₀(conj s) = conj(Λ₀(s))  [Schwarz]
--
-- Combined: Λ₀(1-conj(s)) = Λ₀(conj(1-s)) = conj(Λ₀(1-s)) = conj(Λ₀(s))
--
-- So Λ₀(s) and Λ₀(1-conj(s)) have the same zeros with same
-- multiplicities.
--
-- For s = 1/2 + it: 1-conj(s) = 1-(1/2-it) = 1/2+it = s. Fixed.
-- For s off the line: 1-conj(s) ≠ s.

-- ========== SECTION 8: HasFDerivAt / IFT availability ==========

#check HasStrictFDerivAt.localInverse
#check HasStrictFDerivAt

-- Check if completedRiemannZeta₀ has strict derivative
-- (needed for IFT). Differentiable → HasFDerivAt → need strict.
-- For analytic functions, HasFDerivAt upgrades to HasStrictFDerivAt?

#check AnalyticAt.hasStrictFDerivAt
-- Does this exist?

-- ========== SECTION 9: Open mapping theorem ==========

#check AnalyticAt.eventually_ne
-- If f is analytic, f(z₀)=0, and f is not identically 0 near z₀,
-- then there's a punctured neighborhood where f ≠ 0.

-- Open mapping for analytic functions?
#check IsOpenMap
-- Is there a theorem: nonconstant analytic → open map?

-- ========== SECTION 10: Key imports check ==========

-- Let's see what's actually in scope
#check AnalyticAt.order_eq_one_iff  
-- If this exists, its type tells us a lot

-- Minimum principle / maximum principle?
#check Complex.norm_eq_abs
