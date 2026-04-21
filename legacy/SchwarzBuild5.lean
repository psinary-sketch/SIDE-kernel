import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.Deriv.Basic

open Complex HurwitzZeta MeasureTheory Set

-- =========================================================
-- VERIFIED BUILDING BLOCKS
-- =========================================================

lemma arg_pos_real_ne_pi (t : ℝ) (ht : 0 < t) : ((t : ℂ)).arg ≠ Real.pi := by
  rw [arg_ofReal_of_nonneg (le_of_lt ht)]
  exact Real.pi_pos.ne'

lemma cpow_conj_pos_real (t : ℝ) (ht : 0 < t) (w : ℂ) :
    (t : ℂ) ^ (starRingEnd ℂ w) = starRingEnd ℂ ((t : ℂ) ^ w) := by
  rw [cpow_conj _ _ (arg_pos_real_ne_pi t ht)]
  simp [conj_ofReal]

-- conj(s/2) = conj(s)/2
lemma conj_div_two (s : ℂ) : starRingEnd ℂ (s / 2) = starRingEnd ℂ s / 2 := by
  rw [map_div₀]
  norm_num

-- conj(s - 1) = conj(s) - 1
lemma conj_sub_one (s : ℂ) : starRingEnd ℂ (s - 1) = starRingEnd ℂ s - 1 := by
  rw [map_sub, map_one]

-- conj(s/2 - 1) = conj(s)/2 - 1
lemma conj_half_sub_one (s : ℂ) :
    starRingEnd ℂ (s / 2 - 1) = starRingEnd ℂ s / 2 - 1 := by
  rw [map_sub, conj_div_two, map_one]

-- =========================================================
-- PROBE: What does f_modif actually look like at a value?
-- We need conj(f_modif(t)) = f_modif(t)
-- =========================================================

-- f_modif is:
--   (Ioi 1).indicator (fun x => f(x) - f₀)
--   + (Ioo 0 1).indicator (fun x => f(x) - ε * x^(-k) • g₀)
--
-- For hurwitzEvenFEPair 0:
--   f = ofReal ∘ evenKernel 0  (REAL-VALUED)
--   g = ofReal ∘ cosKernel 0   (REAL-VALUED)
--   f₀ = 1  (since a=0)
--   g₀ = 1
--   ε = 1
--   k = 1/2

-- So f_modif(t) for t > 1:  ofReal(evenKernel 0 t) - 1
-- And f_modif(t) for 0 < t < 1: ofReal(evenKernel 0 t) - t^(-1/2) • 1

-- All components are real! So conj(f_modif(t)) = f_modif(t)

-- Let's try to prove it
example (t : ℝ) : starRingEnd ℂ ((hurwitzEvenFEPair 0).f_modif t) =
    (hurwitzEvenFEPair 0).f_modif t := by
  -- Unfold f_modif
  simp only [WeakFEPair.f_modif]
  -- Try to show conj distributes over everything
  simp [map_add, map_sub, map_indicator, conj_ofReal, map_mul, map_one, smul_eq_mul]
  sorry -- PROBE: see what remains

-- =========================================================
-- RESTRICTED INTEGRAL CONJUGATION
-- =========================================================

-- ∫ t in S, f t  =  ∫ t, f t ∂(volume.restrict S)
-- integral_conj works for any measure μ:
--   ∫ x, conj(f x) ∂μ = conj(∫ x, f x ∂μ)

-- So: conj(∫ t in S, f t) = conj(∫ t, f t ∂(μ.restrict S))
--                          = ∫ t, conj(f t) ∂(μ.restrict S)
--                          = ∫ t in S, conj(f t)

-- Let's check: set_integral_conj might exist
#check integral_conj
-- Or we can use: conj(∫ t in S, f t) = ∫ t in S, conj(f t)
-- This should be a corollary of integral_conj

example (f : ℝ → ℂ) :
    starRingEnd ℂ (∫ t in Ioi (0:ℝ), f t) =
    ∫ t in Ioi (0:ℝ), starRingEnd ℂ (f t) := by
  exact (integral_conj (𝕜 := ℂ)).symm

-- =========================================================
-- FULL PROOF ATTEMPT v5
-- =========================================================

theorem schwarz_v5 (s : ℂ) :
    completedRiemannZeta₀ (starRingEnd ℂ s) =
    starRingEnd ℂ (completedRiemannZeta₀ s) := by
  -- Unfold to mellin
  show mellin (hurwitzEvenFEPair 0).f_modif (starRingEnd ℂ s / 2) / 2 =
       starRingEnd ℂ (mellin (hurwitzEvenFEPair 0).f_modif (s / 2) / 2)
  -- Push conj through /2
  rw [map_div₀]
  norm_num
  -- Goal should now be about mellin
  -- mellin f_modif (conj(s)/2) = conj(mellin f_modif (s/2))
  -- Rewrite conj(s)/2 as conj(s/2)
  rw [← conj_div_two]
  -- Unfold mellin
  simp only [mellin]
  -- Use integral conjugation
  rw [← integral_conj (𝕜 := ℂ)]
  -- Now compare integrands
  congr 1
  ext t
  -- Need: ↑t^(conj(s/2)-1) • f_modif(t) = conj(↑t^(s/2-1) • f_modif(t))
  -- = conj(↑t^(s/2-1)) • conj(f_modif(t))
  -- = ↑t^(conj(s/2-1)) • f_modif(t)  [using cpow_conj + f_modif real]
  -- = ↑t^(conj(s/2)-1) • f_modif(t)  [using conj_sub distributes]
  sorry
