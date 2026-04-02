import Mathlib.Tactic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Mul

namespace ProductRuleSimplicity

theorem simple_zero_real (g : ℝ → ℝ) (a g' : ℝ)
    (hg : HasDerivAt g g' a) (hga : g a ≠ 0) :
    HasDerivAt (fun x => (x - a) * g x) (g a) a := by
  have h1 : HasDerivAt (fun x => x - a) 1 a := by
    have h := (hasDerivAt_id a).sub (hasDerivAt_const a a)
    simp only [id, sub_zero] at h; exact h
  exact (h1.mul hg).congr_deriv (by simp [mul_comm])

theorem simple_zero_complex (g : ℂ → ℂ) (a g' : ℂ)
    (hg : HasDerivAt g g' a) (hga : g a ≠ 0) :
    HasDerivAt (fun z => (z - a) * g z) (g a) a := by
  have h1 : HasDerivAt (fun z => z - a) 1 a := by
    have h := (hasDerivAt_id a).sub (hasDerivAt_const a a)
    simp only [id, sub_zero] at h; exact h
  exact (h1.mul hg).congr_deriv (by simp [mul_comm])

end ProductRuleSimplicity
