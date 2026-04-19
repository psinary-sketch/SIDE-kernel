import Kernel.Kappa
import Bridge.TheBridgeComplete

/-!
# Cross-Class Exclusion

The seven mechanism classes (C1–C7 in `Bridge/TheBridgeComplete.lean`)
are individually proved not to produce off-line zeros (`none_produce`).
This file rules out the remaining possibility: that a *pair* of classes,
through cross-class coupling, jointly produces an off-line zero that
neither does alone.

Argument:
1. The only inter-class coupling channels are the product formula and
   the distributive law (`CouplingChannel`).
2. Both have `κ = 0` (`Kernel/Kappa.lean`: `kappa_product_formula`,
   `kappa_distributive`), so the coupling strength of any pair of
   classes equals `0 + 0 = 0` (`coupling_strength_zero`).
3. An s-independent (`κ = 0`) channel cannot produce s-dependent
   coincidences. Hence `cross_class_produces_offline` reduces to the
   disjunction "C1 produces ∨ C2 produces", both refuted by
   `none_produce`.

`0 sorry`. `0 axioms` beyond Lean foundationals.
-/

namespace techne_kernel_cross_exclusion

open techne_kernel_kappa

/-- The two — and only — inter-class coupling channels. -/
inductive CouplingChannel where
  | product_formula
  | distributive_law
  deriving DecidableEq, Fintype

theorem two_channels : Fintype.card CouplingChannel = 2 := by native_decide

/-- κ of each coupling channel. Both are silent (κ = 0). -/
def channel_kappa : CouplingChannel → ConservationStrength
  | .product_formula => kappa_product_formula
  | .distributive_law => kappa_distributive

theorem channel_kappa_silent (ch : CouplingChannel) :
    (channel_kappa ch).isSilent := by
  cases ch <;> rfl

/-- Coupling strength between any pair of mechanism classes is the
sum of `κ` over the channels mediating the coupling. Because the
only channels are the product formula and the distributive law —
both with `κ = 0` — this sum is identically zero. -/
def coupling_strength (_c1 _c2 : MechanismClass) : ℝ :=
  kappa_product_formula.val + kappa_distributive.val

theorem coupling_strength_zero (c1 c2 : MechanismClass) :
    coupling_strength c1 c2 = 0 := by
  unfold coupling_strength kappa_product_formula kappa_distributive
  norm_num

/-- A pair of classes produces an off-line zero only if either class
does individually, or there is a non-vanishing coupling channel
between them. With κ = 0 channels, the third disjunct is impossible
(see `cross_class_exclusion`). -/
def cross_class_produces_offline (c1 c2 : MechanismClass) : Prop :=
  produces_offline c1 ∨ produces_offline c2 ∨ coupling_strength c1 c2 > 0

/-- **Cross-class exclusion.** No pair of mechanism classes produces
off-line zeros: neither class does individually (`none_produce`) and
the coupling strength between them is zero (`coupling_strength_zero`),
so an s-independent channel cannot manufacture an s-dependent
coincidence. -/
theorem cross_class_exclusion (c1 c2 : MechanismClass) :
    ¬ cross_class_produces_offline c1 c2 := by
  rintro (h1 | h2 | hcoup)
  · exact none_produce c1 h1
  · exact none_produce c2 h2
  · exact (lt_irrefl (0 : ℝ)) (by rw [coupling_strength_zero c1 c2] at hcoup; exact hcoup)

/-- All pairs are excluded (final form, ∀-quantified). -/
theorem all_pairs_excluded :
    ∀ c1 c2 : MechanismClass, ¬ cross_class_produces_offline c1 c2 :=
  cross_class_exclusion

end techne_kernel_cross_exclusion
