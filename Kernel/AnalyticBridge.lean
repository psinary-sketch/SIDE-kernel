import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Analytic.Order
import Mathlib.Analysis.Complex.CauchyIntegral

open Complex Filter

namespace AnalyticBridge

theorem zeta_analyticAt (s : ℂ) : AnalyticAt ℂ completedRiemannZeta₀ s :=
  differentiable_completedZeta₀.differentiableOn.analyticAt
    (IsOpen.mem_nhds isOpen_univ (Set.mem_univ s))

theorem simple_iff_order_one (s : ℂ) (hs : completedRiemannZeta₀ s = 0) :
    deriv completedRiemannZeta₀ s ≠ 0 ↔
    analyticOrderAt completedRiemannZeta₀ s = 1 := by
  have h_an := zeta_analyticAt s
  constructor
  · intro h_ne
    have := h_an.analyticOrderAt_sub_eq_one_of_deriv_ne_zero h_ne
    simp [hs] at this; exact this
  · intro h_one
    have h_ord := h_an.analyticOrderAt_deriv_add_one
    simp [hs] at h_ord
    rw [h_one] at h_ord
    -- h_ord : analyticOrderAt (deriv ξ) s + 1 = 1
    -- In ℕ∞: a + 1 = 1 → a = 0
    have h_zero : analyticOrderAt (deriv completedRiemannZeta₀) s = 0 := by
      cases h : analyticOrderAt (deriv completedRiemannZeta₀) s with
      | top => simp [h] at h_ord
      | coe n => simp [h] at h_ord; exact congrArg _ h_ord
    rw [analyticOrderAt_eq_zero] at h_zero
    rcases h_zero with h_not_an | h_ne
    · exact absurd h_an.deriv h_not_an
    · exact h_ne

end AnalyticBridge
