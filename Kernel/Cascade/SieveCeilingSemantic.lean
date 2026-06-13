/-
  SieveCeilingSemantic.lean

  Slot 2 of the E-Difficulty lift: the semantic model behind the
  skeleton's abstract `factored_through_dark`.

  Mathlib's model theory is semantic (ModelTheory has Syntax,
  Semantics, Satisfiability, Definability, ... but no syntactic
  derivation calculus), so the faithful hook for "a proof factoring
  through a dark interface" is the I-indistinguishability relation,
  not a proof-tree object. A dark (k = 0) interface transmits nothing
  that separates I-indistinguishable configurations, so a proof
  factoring through it can only certify properties that respect that
  relation. The universal property "all zeros on the critical line"
  is NOT respected once an Epstein-type witness exists -- a
  configuration I-indistinguishable from the ideal yet with off-line
  zeros -- so no dark-factored certificate captures it. That is the
  sieve ceiling.

  The non-invariance witness is abstract here. Slot 3 discharges it
  concretely with the Davenport-Heilbronn function (discriminant -23).

  Core Lean only. Pairs with Kernel/Cascade/SieveCeiling.lean, whose
  abstract `factored_through_dark` this models and whose
  `density_one_per_class < universal` ordering this explains.

  J. York Seale, PLACE TO STAND Research Programme
-/

namespace SieveCeilingSemantic

universe u
variable {U : Type u} (r : U → U → Prop)

/-- A property is dark-establishable when it respects the
    I-indistinguishability relation r: configurations the dark
    interface cannot separate receive the same verdict. This is the
    semantic content of the skeleton's `factored_through_dark`. (r is
    the I-indistinguishability equivalence; the theorems below need
    only that certificates respect it, not its equivalence laws.) -/
def RespectsI (P : U → Prop) : Prop :=
  ∀ x y, r x y → (P x ↔ P y)

/-- THE SEMANTIC SIEVE CEILING. If the target property is not
    r-invariant, no r-respecting (dark-factored) certificate is
    extensionally equal to it: the dark-factored reach stops strictly
    below the target. -/
theorem sieve_ceiling_semantic {onLine : U → Prop}
    (h_not_inv : ¬ RespectsI r onLine) :
    ¬ ∃ D : U → Prop, RespectsI r D ∧ ∀ z, D z ↔ onLine z := by
  rintro ⟨D, hD_inv, hD_eq⟩
  apply h_not_inv
  intro x y hxy
  exact ((hD_eq x).symm.trans (hD_inv x y hxy)).trans (hD_eq y)

/-- The shape of a non-invariance witness: a pair of
    I-indistinguishable configurations that disagree on the property
    -- r x y, onLine x, not onLine y. This is the abstract slot the
    Epstein witness fills (ideal vs Davenport-Heilbronn). -/
def NonInvarianceWitness (onLine : U → Prop) : Prop :=
  ∃ x y, r x y ∧ onLine x ∧ ¬ onLine y

/-- A non-invariance witness makes the property not r-invariant. -/
theorem not_respectsI_of_witness {onLine : U → Prop}
    (h : NonInvarianceWitness r onLine) : ¬ RespectsI r onLine := by
  intro hinv
  obtain ⟨x, y, hxy, hx, hy⟩ := h
  exact hy ((hinv x y hxy).mp hx)

/-- Sieve ceiling from a concrete witness: given an
    I-indistinguishable pair disagreeing on the universal property,
    no dark-factored certificate captures it. Slot 3 instantiates
    this with the discriminant -23 Epstein zero. -/
theorem sieve_ceiling_of_witness {onLine : U → Prop}
    (h : NonInvarianceWitness r onLine) :
    ¬ ∃ D : U → Prop, RespectsI r D ∧ ∀ z, D z ↔ onLine z :=
  sieve_ceiling_semantic r (not_respectsI_of_witness r h)

end SieveCeilingSemantic
