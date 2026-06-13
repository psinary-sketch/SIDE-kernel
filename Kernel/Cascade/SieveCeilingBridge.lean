/-
  SieveCeilingBridge.lean

  Slot 4 (optional rigor) of the E-Difficulty lift: mechanizes
  cross-link 1, the correspondence documented across slots 1 and 2 --
  that a dark (kappa = 0) interface induces an I-indistinguishability
  relation under which the sieve ceiling applies.

  Model: an interface reads configurations into an observation space;
  the induced indistinguishability is the kernel of the reading (same
  reading => indistinguishable). A blind (constant) reading is the
  kappa = 0 case: it separates nothing, so the relation is total and
  only constant properties respect it -- hence a non-constant
  universal property (an Epstein-type target) cannot be captured.
  Both the slot-1 kappa = 0 character and the slot-2 ceiling fall out
  of blindness as the shared substrate. This makes the slot-1 <->
  slot-2 correspondence a theorem rather than a comment.

  Depth note: once the reading model is fixed the bridge theorems are
  short consequences -- the content is the modeling choice, not a deep
  result. Standalone module: done, not chased into the certified
  skeleton. Cross-link 2 (semantic model <-> abstract skeleton's
  factored_through_dark) is left documented, not mechanized.

  Mathlib-dependent via SieveCeilingReal for the slot-1 kappa link.

  J. York Seale, PLACE TO STAND Research Programme
-/
import Kernel.Cascade.SieveCeilingSemantic
import Kernel.Cascade.SieveCeilingReal

namespace SieveCeilingBridge

open SieveCeilingSemantic

universe u v
variable {U : Type u} {V : Type v}

/-- The indistinguishability induced by a reading: same reading
    means indistinguishable. -/
def obsRel (obs : U → V) : U → U → Prop :=
  fun x y => obs x = obs y

/-- A blind reading: constant, separates nothing. The kappa = 0
    (dark) case at the level of the reading. -/
def Blind (obs : U → V) : Prop :=
  ∀ x y, obs x = obs y

/-- A blind reading induces the total relation. -/
theorem blind_total {obs : U → V} (h : Blind obs) :
    ∀ x y, obsRel obs x y :=
  fun x y => h x y

/-- Under a blind reading, any property respecting the induced
    relation is constant. -/
theorem const_of_blind_respectsI {obs : U → V} (hb : Blind obs)
    {P : U → Prop} (hP : RespectsI (obsRel obs) P) :
    ∀ x y, (P x ↔ P y) :=
  fun x y => hP x y (hb x y)

/-- THE BRIDGE. A blind (dark) interface cannot certify a
    non-constant universal property: if the target disagrees on some
    pair (an Epstein-type separation), no relation-respecting
    certificate captures it. -/
theorem blind_sieve_ceiling {obs : U → V} (hb : Blind obs)
    {onLine : U → Prop} (hsep : ∃ x y, onLine x ∧ ¬ onLine y) :
    ¬ ∃ D : U → Prop,
      RespectsI (obsRel obs) D ∧ ∀ z, D z ↔ onLine z := by
  obtain ⟨x, y, hx, hy⟩ := hsep
  exact sieve_ceiling_of_witness (obsRel obs) ⟨x, y, hb x y, hx, hy⟩

/-- Slot-1 link: a blind reading presents to slot 1 as a kappa = 0
    interface. -/
def toRInterface (obs : U → V) (_ : Blind obs) : SieveCeilingReal.RInterface :=
  { kappa := 0, kappa_nonneg := le_refl 0,
    kappa_le_one := zero_le_one, essential := true }

/-- That presented interface is dark in slot 1's sense (kappa = 0). -/
theorem toRInterface_isDark (obs : U → V) (h : Blind obs) :
    (toRInterface obs h).isDark :=
  rfl

end SieveCeilingBridge
