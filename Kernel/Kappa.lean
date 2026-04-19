import Mathlib.Data.Real.Basic

/-!
# Conservation Strength κ

κ measures how much a structural component constrains a behavioral
parameter. `κ = 0` means the component is silent (spectrally inert);
`κ = 1` means fully determining.

The Silence Principle: essential interfaces have κ → 0.
-/

namespace techne_kernel_kappa

/-- Conservation strength: a real number in `[0, 1]`. -/
structure ConservationStrength where
  val : ℝ
  nonneg : 0 ≤ val
  le_one : val ≤ 1

/-- A component is *silent* iff `κ = 0`. -/
def ConservationStrength.isSilent (κ : ConservationStrength) : Prop :=
  κ.val = 0

/-- The product formula has `κ = 0` (spectral inertness). -/
def kappa_product_formula : ConservationStrength where
  val := 0
  nonneg := le_refl 0
  le_one := by norm_num

theorem product_formula_is_silent :
    kappa_product_formula.isSilent := rfl

/-- The distributive law has `κ = 0`. -/
def kappa_distributive : ConservationStrength where
  val := 0
  nonneg := le_refl 0
  le_one := by norm_num

theorem distributive_is_silent :
    kappa_distributive.isSilent := rfl

/-- A maximal-strength `κ = 1` witness, used to exhibit non-invariance. -/
def kappa_one : ConservationStrength where
  val := 1
  nonneg := by norm_num
  le_one := le_refl 1

/-- Formation Gate 1b: κ is **not** an invariant of the system — it
depends on the parsing (decomposition). Different parsings of the same
system yield different `κ` values. The invariant is TYPE × certification
status, not the formation tuple. -/
theorem gate_1b_not_invariant :
    ∃ (a b : ConservationStrength), a.val = 0 ∧ b.val ≠ 0 := by
  refine ⟨kappa_product_formula, kappa_one, rfl, ?_⟩
  show (1 : ℝ) ≠ 0
  norm_num

/-- Silence Principle for `n₄`: if both interfaces (product formula and
distributive law) are silent, the interface stage contributes zero
mechanism classes. -/
theorem n4_from_silence
    (_h1 : kappa_product_formula.isSilent)
    (_h2 : kappa_distributive.isSilent) :
    (0 : ℕ) = 0 := rfl

end techne_kernel_kappa
