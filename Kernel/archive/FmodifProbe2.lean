import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.Deriv.Basic

open Complex HurwitzZeta MeasureTheory Set

-- The goal (from Build14 sorry) is:
-- f_modif(t) = conj(f_modif(t))
-- Equivalently: conj(f_modif(t)) = f_modif(t)
-- Equivalently: f_modif(t).im = 0

-- =========================================================
-- APPROACH 1: conj_eq_iff_im route
-- =========================================================

example (t : ℝ) :
    (hurwitzEvenFEPair 0).f_modif t =
    starRingEnd ℂ ((hurwitzEvenFEPair 0).f_modif t) := by
  rw [eq_comm]
  rw [Complex.conj_eq_iff_im]
  simp only [WeakFEPair.f_modif, Pi.add_apply]
  -- After unfolding, try simp with im lemmas
  simp only [indicator_apply]
  split_ifs <;> simp [Complex.add_im, Complex.sub_im, Complex.ofReal_im,
    Complex.smul_im, Complex.mul_im, Complex.one_im, Complex.zero_im,
    hurwitzEvenFEPair]
  sorry

-- =========================================================
-- APPROACH 2: show it's in range of ofReal
-- =========================================================

-- f_modif is built from:
--   f = ofReal ∘ evenKernel 0
--   f₀ = 1 (= ofReal 1)
--   g₀ = 1 (= ofReal 1)
--   ε = 1
--   k = 1/2
--   x^(-k) is real for x > 0

-- Check what hurwitzEvenFEPair fields unfold to
example : (hurwitzEvenFEPair 0).f₀ = 1 := by rfl
example : (hurwitzEvenFEPair 0).g₀ = 1 := by rfl
example : (hurwitzEvenFEPair 0).ε = 1 := by rfl
example : (hurwitzEvenFEPair 0).k = 1 / 2 := by rfl

-- The f field
example (x : ℝ) : (hurwitzEvenFEPair 0).f x = (↑(evenKernel 0 x) : ℂ) := by rfl

-- =========================================================
-- APPROACH 3: direct computation with indicator cases
-- =========================================================

-- indicator_apply: S.indicator f x = if x ∈ S then f x else 0
-- Pi.add_apply: (f + g) x = f x + g x

example (t : ℝ) :
    (hurwitzEvenFEPair 0).f_modif t =
    starRingEnd ℂ ((hurwitzEvenFEPair 0).f_modif t) := by
  simp only [WeakFEPair.f_modif, Pi.add_apply, indicator_apply]
  -- Now it's: (if t ∈ Ioi 1 then ... else 0) + (if t ∈ Ioo 0 1 then ... else 0)
  --         = conj(same)
  -- Push conj through
  rw [map_add]
  congr 1
  · -- First indicator: if t ∈ Ioi 1 then f(t) - f₀ else 0
    split_ifs with h
    · -- t ∈ Ioi 1: conj(ofReal(evenKernel 0 t) - 1) = ofReal(...) - 1
      simp [map_sub, conj_ofReal, map_one]
    · -- t ∉ Ioi 1: conj(0) = 0
      simp
  · -- Second indicator
    split_ifs with h
    · -- t ∈ Ioo 0 1: conj(ofReal(evenKernel 0 t) - ε * ↑(t^(-k)) • g₀)
      simp [map_sub, map_mul, map_smul, conj_ofReal, map_one]
      sorry  -- see what remains
    · simp
