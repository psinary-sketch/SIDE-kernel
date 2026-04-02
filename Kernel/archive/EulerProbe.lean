import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.NumberTheory.EulerProduct.DirichletLSeries
import Mathlib.NumberTheory.Padics.PadicNorm
import Mathlib.Data.Nat.Prime.Basic

-- ============================================================
-- PROBE 1: What does riemannZeta_eulerProduct actually say?
-- ============================================================

#check @riemannZeta_eulerProduct

-- ============================================================
-- PROBE 2: What is the Euler product type?
-- ============================================================

#check @EulerProduct
#check @LSeries
#check @LSeriesHasSum

-- ============================================================
-- PROBE 3: Local factors — what does Mathlib call (1-p^(-s))⁻¹?
-- ============================================================

#check @DirichletLSeries
#check @LSeries_congr

-- ============================================================
-- PROBE 4: riemannZeta in terms of LSeries
-- ============================================================

#check @riemannZeta_eq_tsum_one_div_nat_cpow
#check @zeta_LSeriesHasSum

-- ============================================================
-- PROBE 5: Euler product convergence region
-- ============================================================

-- Does the Euler product statement require Re(s) > 1?
-- Or does it extend to zeros?

-- ============================================================
-- PROBE 6: Can we express the balance condition p^(-σ) = p^(-(1-σ))
-- as a consequence of the Euler product structure?
-- ============================================================

-- The balance condition is algebraic: it says
-- the weight p^(-s) in the Euler factor (1-p^(-s))⁻¹
-- satisfies p^(-s) = p^(-(1-s)) only when Re(s) = 1/2.
--
-- This is independent of whether the product converges.
-- It's a property of the INDIVIDUAL FACTOR, not the product.
-- Voice 1 already proves this.
--
-- The bridge question: at a zero of ζ(s), does the
-- Euler product structure "activate" the balance condition?

-- ============================================================
-- PROBE 7: Functional equation — the other bridge
-- ============================================================

#check @riemannZeta_one_sub
#check @completedRiemannZeta₀_one_sub

-- ============================================================
-- PROBE 8: The key question — can we define OffLineZero
-- using riemannZeta directly and still apply balance_theorem?
-- ============================================================

-- Attempt: define OffLineZero using ζ, derive balance as consequence

-- At a zero ρ of ζ with Re(ρ) = σ:
-- The functional equation gives ζ(ρ) = 0 → ζ(1-ρ) = 0 (modulo poles/Γ)
-- This means both p^(-ρ) and p^(-(1-ρ)) appear in the Euler product
-- For the WEIGHTS: |p^(-ρ)| = p^(-σ) and |p^(-(1-ρ))| = p^(-(1-σ))
-- Balance: p^(-σ) = p^(-(1-σ)) iff σ = 1/2

-- The balance condition doesn't need the product to converge.
-- It's about the MODULUS of individual Euler factors.
-- This is purely algebraic and holds for any complex s.

-- ============================================================
-- PROBE 9: Direct approach — riemannZeta + not_trivial + ne_one
-- ============================================================

-- What if OffLineZero just uses riemannZeta and we derive
-- the balance condition from the functional equation?

-- At ρ with ζ(ρ) = 0:
--   FE: ζ(1-ρ) relates to ζ(ρ) = 0
--   For ANY prime p: the weight p^(-ρ) has modulus p^(-σ)
--   This is just |p^(-σ-it)| = p^(-σ) (modulus of complex power)
--   The FE pairs ρ with 1-ρ, giving weight modulus p^(-(1-σ))
--   Voice 1: p^(-σ) = p^(-(1-σ)) ↔ σ = 1/2

-- Can we state this in Lean using rpow on the modulus?

open Complex in
example (p : Nat) (hp : Nat.Prime p) (s : Complex) :
    Complex.abs ((p : Complex) ^ (-s)) = (p : Real) ^ (-s.re) := by
  exact?

-- ============================================================
-- PROBE 10: Complex.abs of cpow for positive real base
-- ============================================================

#check @Complex.abs_cpow_eq_rpow_re_of_pos
#check @Complex.abs_cpow_real
#check @Complex.abs_cpow_of_ne_zero
