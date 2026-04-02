import Kernel.Layer1

open techne_kernel Classical

namespace TypeLevel

universe u

/-- A type-level constraint: a property that holds for ALL instances
    of a specification class, not just specific values. -/
structure TypeLevelConstraint (X : Type u) (P : X → Prop) where
  holds_for_spec : ∀ x, P x

/-- Determination collapse: if a type-level constraint holds for
    all instances of a class, and there is only one instance,
    it holds for the specific instance. -/
theorem determination_collapse
    {X : Type u} {P : X → Prop}
    (tlc : TypeLevelConstraint X P) (x : X) : P x :=
  tlc.holds_for_spec x

-- A SIDE-amenable specification class.
structure SIDEClass (X : Type u) (P : X → Prop) where
  catalogue : ExhaustiveCatalogue X (fun x => ¬ (P x))
  none_produces : ∀ x, NoneProduces X (fun x => ¬ (P x)) catalogue.classes x

/-- From SIDE class to type-level constraint. -/
def side_to_type_level
    {X : Type u} {P : X → Prop}
    (sc : SIDEClass X P) : TypeLevelConstraint X P where
  holds_for_spec := fun x => by
    exact Classical.byContradiction (fun h_not =>
      SIDE_exclusion sc.catalogue (sc.none_produces x) h_not)

/-- The bridge: SIDE → TypeLevel → Value.
    Specification-reasoning (SIDE) produces a type-level constraint.
    Determination collapse converts it to a value-level conclusion. -/
theorem side_bridge
    {X : Type u} {P : X → Prop}
    (sc : SIDEClass X P) (x : X) : P x :=
  determination_collapse (side_to_type_level sc) x

end TypeLevel