import Mathlib.Tactic
import Mathlib.Analysis.Calculus.Deriv.Basic

open Filter Topology

namespace SignChange

theorem sign_change_pos (f : ℝ → ℝ) (x0 f' : ℝ)
    (hf : HasDerivAt f f' x0) (hfx : f x0 = 0) (hf' : f' > 0) :
    ∃ a b : ℝ, a < x0 ∧ x0 < b ∧ f a < 0 ∧ f b > 0 := by
  have hilo := hf.isLittleO
  simp only [hfx, sub_zero] at hilo
  have hev := (Asymptotics.isLittleO_iff.mp hilo) (half_pos hf')
  rw [Filter.Eventually, Metric.mem_nhds_iff] at hev
  obtain ⟨δ, hδpos, hball⟩ := hev
  have hδ2 : δ / 2 > 0 := by linarith
  refine ⟨x0 - δ/2, x0 + δ/2, by linarith, by linarith, ?_, ?_⟩
  · have hmem : x0 - δ/2 ∈ Metric.ball x0 δ := by
      rw [Metric.mem_ball, Real.dist_eq, show x0 - δ / 2 - x0 = -(δ / 2) from by ring,
          abs_neg, abs_of_pos hδ2]; linarith
    have h1 := Set.mem_setOf.mp (hball hmem)
    -- h1 : ‖f(x0-δ/2) - ((x0-δ/2)-x0) • f'‖ ≤ f'/2 * ‖(x0-δ/2)-x0‖
    simp only [Real.norm_eq_abs, smul_eq_mul] at h1
    rw [show (x0 - δ / 2) - x0 = -(δ / 2) from by ring] at h1
    rw [show -(δ / 2) * f' = -(δ / 2 * f') from by ring] at h1
    rw [show f (x0 - δ / 2) - -(δ / 2 * f') = f (x0 - δ / 2) + δ / 2 * f' from by ring] at h1
    rw [abs_neg, abs_of_pos hδ2] at h1
    have h2 := (abs_le.mp h1).2
    nlinarith
  · have hmem : x0 + δ/2 ∈ Metric.ball x0 δ := by
      rw [Metric.mem_ball, Real.dist_eq, show x0 + δ / 2 - x0 = δ / 2 from by ring,
          abs_of_pos hδ2]; linarith
    have h1 := Set.mem_setOf.mp (hball hmem)
    simp only [Real.norm_eq_abs, smul_eq_mul] at h1
    rw [show (x0 + δ / 2) - x0 = δ / 2 from by ring] at h1
    rw [abs_of_pos hδ2] at h1
    have h2 := (abs_le.mp h1).1
    nlinarith

end SignChange
