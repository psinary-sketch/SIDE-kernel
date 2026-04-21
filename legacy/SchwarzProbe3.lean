import Mathlib.NumberTheory.LSeries.RiemannZeta

open Complex HurwitzZeta

-- =========================================================
-- PROBE: Chase the Hurwitz definition chain
-- =========================================================

-- Level 1: completedRiemannZeta₀ = completedHurwitzZetaEven₀ 0
#print completedHurwitzZetaEven₀

-- Does it have a conj lemma?
#check completedHurwitzZetaEven₀_conj

-- What about the non-zero version?
#check completedHurwitzZetaEven₀
#check completedHurwitzZetaEven

-- =========================================================
-- Check for any conj/star lemmas in HurwitzZeta namespace
-- =========================================================

#check HurwitzZeta.completedHurwitzZetaEven₀_conj
#check HurwitzZeta.completedHurwitzZetaOdd_conj
#check HurwitzZeta.hurwitzZetaEven_conj
#check HurwitzZeta.hurwitzZetaOdd_conj
#check HurwitzZeta.cosZeta_conj
#check HurwitzZeta.sinZeta_conj

-- =========================================================
-- If direct conj lemma exists, try to compose
-- =========================================================

-- Target: completedRiemannZeta₀ (conj s) = conj (completedRiemannZeta₀ s)
-- i.e.: completedHurwitzZetaEven₀ 0 (conj s) = conj (completedHurwitzZetaEven₀ 0 s)

-- Try direct proof
example (s : ℂ) : completedRiemannZeta₀ (starRingEnd ℂ s) =
    starRingEnd ℂ (completedRiemannZeta₀ s) := by
  simp only [completedRiemannZeta₀]
  exact?
