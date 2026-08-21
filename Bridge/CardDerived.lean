/-
  CardDerived.lean — THE FORMATION-CARD CONVERSION, IN-KERNEL (the census series'
  third completed conversion)
  ============================================================================

  2026-08-21, the depth act's strikeable component 3 (the author's route choice by
  ferry paste: in-kernel replication over a cross-repository dependency, preserving
  federation independence). PROVENANCE: the pattern originates in SIDE-trivium's
  `Trivium/CardDerived.lean` (commit 1aac3a9, the census series' first conversion);
  the substrate assignment below REPLICATES that repository's Trivium pairing
  (C1 ↦ −1, C2 ↦ 2, C3 ↦ −2, C4 ↦ 3, C5 ↦ −3, C6 ↦ 6, C7 ↦ −6 — the (ℤ/2)³
  squarefree classification over {−1, 2, 3}) with NO cross-repository dependency.

  WHAT THIS REROUTES: `seven_classes` reads its 7 off the `MechanismClass`
  declaration (a declaration-count, the census species). Here the count is DERIVED:
  the substrate value map is proved injective and the cardinality is transported to
  the derived integer image {−1, 2, −2, 3, −3, 6, −6} — a computation on ℤ, not a
  declaration-read. The original `seven_classes` stays in place (additive edit).
  Expected profile: the repository's stated bar {propext, Classical.choice,
  Quot.sound}.
-/

import Bridge.TheBridgeComplete
import Mathlib.Data.Finset.Image

/-- the substrate assignment, replicated in-kernel: each mechanism class to its
    quadratic discriminant's integer value -/
def substrateValue : MechanismClass → Int
  | .C1_schwarz        => -1
  | .C2_euler          =>  2
  | .C3_functional_eq  => -2
  | .C4_modular        =>  3
  | .C5_spectral       => -3
  | .C6_cauchy_riemann =>  6
  | .C7_hadamard       => -6

/-- the substrate values are pairwise distinct — injectivity as a decided
    computation on ℤ -/
theorem substrate_value_injective : Function.Injective substrateValue := by decide

/-- THE DERIVED COUNT: the mechanism classes number exactly the derived cardinality
    of their substrate image {−1, 2, −2, 3, −3, 6, −6} — the 7 is a computation on ℤ
    through the proved injection, not a declaration-read -/
theorem mechanism_class_card_derived :
    Fintype.card MechanismClass =
      ({-1, 2, -2, 3, -3, 6, -6} : Finset Int).card := by
  have himg : (Finset.univ.image substrateValue) =
      ({-1, 2, -2, 3, -3, 6, -6} : Finset Int) := by decide
  rw [← himg, Finset.card_image_of_injective _ substrate_value_injective,
      Finset.card_univ]

/-- the derived count evaluates to 7 by integer arithmetic -/
theorem mechanism_class_card_value :
    ({-1, 2, -2, 3, -3, 6, -6} : Finset Int).card = 7 := by decide
