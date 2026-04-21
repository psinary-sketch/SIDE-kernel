import Mathlib.NumberTheory.LSeries.RiemannZeta

open Complex HurwitzZeta

-- =========================================================
-- Chase: hurwitzEvenFEPair → Λ₀
-- =========================================================

#print hurwitzEvenFEPair
#check hurwitzEvenFEPair
#check @WeakFEPair.Λ₀

-- What is a WeakFEPair / FEPair?
#print WeakFEPair.Λ₀

-- =========================================================
-- Alternative: try riemannZeta path instead
-- =========================================================

-- Maybe riemannZeta has a conj lemma even if completed doesn't?
-- completedRiemannZeta₀ s = π^(-s/2) * Γ(s/2) * ζ(s) (roughly)
-- If ζ(conj s) = conj(ζ(s)) exists...

example (s : ℂ) : riemannZeta (starRingEnd ℂ s) =
    starRingEnd ℂ (riemannZeta s) := by
  exact?

-- =========================================================
-- Alternative: use identity theorem approach
-- Two entire functions agreeing on ℝ agree everywhere
-- =========================================================

-- Does Mathlib have the identity theorem for entire functions?
#check AnalyticAt.eq_of_nhds  -- or similar
#check IsPreconnected.eq_of_analyticOn  -- maybe
#check eqOn_of_eq_zero_of_ne  -- maybe

-- =========================================================
-- Alternative: direct from Dirichlet series
-- ζ(s) = Σ n^(-s) and conj(n^(-s)) = n^(-conj(s))
-- so ζ(conj s) = conj(ζ(s)) in the convergence region
-- then extend by identity theorem
-- =========================================================

-- Check if there's a general Dirichlet series conj lemma
#check LSeries  -- L-series
#check LSeriesHasSum
#check LSeries_congr

-- =========================================================
-- Nuclear option: check ALL names containing "conj" in zeta files
-- =========================================================

#check completedRiemannZeta_conj  -- non-zero version?
#check completedRiemannZeta₀_neg  -- negative?
