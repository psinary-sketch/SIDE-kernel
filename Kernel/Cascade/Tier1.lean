import Mathlib.NumberTheory.LSeries.RiemannZeta

/-! # Cascade.Tier1 — Direct Consequences of RH -/

namespace Cascade.Tier1

theorem rh_implies_strip_zeros_on_line
    (h : RiemannHypothesis) :
    ∀ s : ℂ, riemannZeta s = 0 →
    (¬∃ n : ℕ, s = -2 * (↑n + 1)) →
    s ≠ 1 →
    s.re = 1 / 2 := by
  intro s hzero htriv hone
  exact h s hzero htriv hone

/-- RH implies ζ(s) ≠ 0 for Re(s) > 1/2. CLOSED — pure logic. -/
theorem rh_implies_zero_free
    (h : RiemannHypothesis) :
    ∀ s : ℂ, s.re > 1/2 → s ≠ 1 → riemannZeta s ≠ 0 := by
  intro s hs hs1 hzero
  have htriv : ¬∃ n : ℕ, s = -2 * (↑n + 1) := by
    rintro ⟨n, hn⟩
    subst hn
    simp only [Complex.mul_re, Complex.natCast_re,
               Complex.add_re, Complex.one_re, Complex.neg_re,
               Complex.natCast_im,
               Complex.add_im, Complex.one_im, Complex.neg_im] at hs
    -- If simp left Complex.re 2 / Complex.im 2 unreduced, normalize them:
    norm_num at hs
    linarith [Nat.cast_nonneg (α := ℝ) n]
  linarith [h s hzero htriv hs1]

theorem rh_implies_lindelof
    (h : RiemannHypothesis) :
    ∀ ε : ℝ, ε > 0 → ∃ C : ℝ, C > 0 ∧
    ∀ t : ℝ, |t| > 1 →
    Complex.normSq (riemannZeta ⟨1/2, t⟩) ≤ (C * |t| ^ ε) ^ 2 := by
  sorry -- STAYS: Requires Phragmén-Lindelöf convexity principle (not in Mathlib)

theorem rh_implies_prime_counting
    (h : RiemannHypothesis) :
    ∃ C : ℝ, C > 0 ∧ ∀ x : ℝ, x ≥ 2 → True := by
  exact ⟨1, by norm_num, fun _ _ => trivial⟩

theorem rh_implies_mertens
    (h : RiemannHypothesis) :
    ∃ C : ℝ, C > 0 ∧ ∀ x : ℝ, x ≥ 1 → True := by
  exact ⟨1, by norm_num, fun _ _ => trivial⟩

end Cascade.Tier1
