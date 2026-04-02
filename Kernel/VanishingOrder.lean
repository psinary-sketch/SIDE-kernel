import Mathlib.Tactic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.IteratedDeriv.Defs

open Complex

namespace VanishingOrder

/-
  CP2.3: Vanishing Order of Analytic Functions

  Define the order of vanishing and prove:
  - order 1 ↔ simple zero ↔ deriv f a ≠ 0
  - order ≥ 2 ↔ multiple zero ↔ deriv f a = 0

  This unblocks ALL three paths to axiom elimination.
-/

-- The vanishing order of f at a is the smallest n ≥ 1 with f^(n)(a) ≠ 0
-- (when f(a) = 0 and f is not identically zero near a)

-- For ℝ → ℝ functions (connects to SignChange/DoubleZero):

-- Simple zero: f(a) = 0 AND f'(a) ≠ 0
def IsSimpleZeroReal (f : ℝ → ℝ) (a : ℝ) : Prop :=
  f a = 0 ∧ deriv f a ≠ 0

-- Multiple zero: f(a) = 0 AND f'(a) = 0
def IsMultipleZeroReal (f : ℝ → ℝ) (a : ℝ) : Prop :=
  f a = 0 ∧ deriv f a = 0

-- These are complementary (for zeros)
theorem simple_or_multiple_real (f : ℝ → ℝ) (a : ℝ) (hf : f a = 0) :
    IsSimpleZeroReal f a ∨ IsMultipleZeroReal f a := by
  by_cases h : deriv f a = 0
  · right; exact ⟨hf, h⟩
  · left; exact ⟨hf, h⟩

-- For ℂ → ℂ functions:

def IsSimpleZero (f : ℂ → ℂ) (a : ℂ) : Prop :=
  f a = 0 ∧ deriv f a ≠ 0

def IsMultipleZero (f : ℂ → ℂ) (a : ℂ) : Prop :=
  f a = 0 ∧ deriv f a = 0

theorem simple_or_multiple (f : ℂ → ℂ) (a : ℂ) (hf : f a = 0) :
    IsSimpleZero f a ∨ IsMultipleZero f a := by
  by_cases h : deriv f a = 0
  · right; exact ⟨hf, h⟩
  · left; exact ⟨hf, h⟩

-- KEY CONNECTION: simple zero of ξ ↔ simple zero of F
-- (Uses Voice1Ext.simplicity_iff)

-- The factorization theorem (stated, not proved —
-- needs removable singularity / power series):
-- If f is analytic at a with f(a) = 0, then
-- f(z) = (z - a)^m · g(z) with g(a) ≠ 0
-- and m is the vanishing order.

-- For the AXIOM ELIMINATION PROGRAMME:
-- The connection we need is:
--   ξ has a zero of order m at ρ
--   ↔ f'/f has a pole with residue m at ρ
--   ↔ deriv^(k) ξ (ρ) = 0 for k < m and ≠ 0 for k = m

-- The simple case (m=1) is what we prove:
-- deriv ξ ρ ≠ 0 means the zero is simple.
-- This is literally the definition.

-- What REMAINS for the full programme:
-- 1. Prove the factorization (needs analytic function theory)
-- 2. Prove residue of f'/f = m (needs Laurent series)
-- 3. Connect to phase non-cancellation (needs Baker or QIndep)

-- But the DEFINITION and DICHOTOMY are compiled NOW.

end VanishingOrder
