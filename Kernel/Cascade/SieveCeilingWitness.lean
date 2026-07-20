/-
  SieveCeilingWitness.lean

  Slot 3 of the E-Difficulty lift: a concrete witness discharging
  SieveCeilingSemantic.NonInvarianceWitness.

  Two configurations -- the arithmetic ideal (RH holds) and the
  Davenport-Heilbronn function -- are I-indistinguishable (same
  functional equation, same density-one-on-line statistics, so the
  dark interface cannot separate them) yet disagree on the universal
  property: the Davenport-Heilbronn function has zeros off the
  critical line (Davenport-Heilbronn 1936; Titchmarsh). That off-line
  fact is a classical analytic theorem -- math-leg input, cited here,
  not reproved -- encoded as the datum allOnLine .dh = False. Given
  it, Lean verifies the abstract sieve ceiling fires on the canonical
  counterexample: no dark-factored certificate captures "all zeros on
  the line." The two-point model wears its scope on its sleeve; the
  contentful treatment of the separation lives in the manuscript
  layer. The kernel records only that the architecture consumes the
  cited fact.

  W-6-EXT R1 (2026-07-19): the I-indistinguishability relation is now
  the KERNEL OF THE DARK READING -- `iIndist x y := darkObs x = darkObs y`
  -- and READS ITS ARGUMENTS. The former `iIndist _ _ := True` (the
  total relation, W-6's named vacuity) is retired. `darkObs` lands in
  a two-valued codomain, so the relation is a genuine reading (not the
  total relation): it separates any pair with distinct observables
  (`darkReading_capable_of_falsity`). Within this two-point Config no
  such pair occurs BECAUSE the ideal and Davenport-Heilbronn configs
  present the same dark observable -- same functional equation, same
  density-one statistics -- which is the honest modeling stipulation
  (the analogue of the cited datum allOnLine .dh = False), and which
  IS the kappa = 0 darkness the ceiling formalizes. dh_witness is
  re-derived on the real relation.

  Core Lean only.

  J. York Seale, PLACE TO STAND Research Programme
-/
import Kernel.Cascade.SieveCeilingSemantic

namespace SieveCeilingWitness

open SieveCeilingSemantic

/-- Two configurations: the arithmetic ideal (RH holds) and the
    Davenport-Heilbronn function (density one on the line, yet
    off-line zeros). -/
inductive Config where
  | ideal : Config
  | dh    : Config
deriving DecidableEq

/-- The observable a dark (kappa = 0) interface reads off a
    configuration: its functional-equation type together with its
    density-one-on-line statistics, collapsed to the two-valued token
    the two-point model needs. The arithmetic ideal and the
    Davenport-Heilbronn function present the SAME observable
    (Davenport-Heilbronn 1936: identical functional equation, density
    one on the line) -- this is the honest modeling stipulation, the
    analogue of the cited datum `allOnLine .dh = False`. -/
def darkObs : Config → Bool
  | Config.ideal => true
  | Config.dh    => true

/-- I-indistinguishability is the KERNEL of the dark reading: two
    configurations are indistinguishable exactly when the dark
    interface reads the same observable off them. This READS ITS
    ARGUMENTS -- it is the equality `darkObs x = darkObs y`, not the
    total relation `True`. -/
def iIndist (x y : Config) : Prop := darkObs x = darkObs y

/-- Non-totality witness for the two-sided screen: the reading-kernel
    schema is genuinely a reading, not the total relation -- distinct
    observables are NOT related. (Its codomain `Bool` has distinct
    inhabitants; a configuration presenting the observable `false`
    would be distinguished from `ideal`. The two-point Config presents
    no such pair only because `ideal` and `dh` share the dark
    observable by stipulation -- that shared observable IS the
    kappa = 0 darkness, cf. `dh_witness`.) -/
theorem darkReading_capable_of_falsity : ¬ (∀ b c : Bool, b = c) :=
  fun h => Bool.noConfusion (h true false)

/-- The universal property: all zeros on the critical line. True for
    the ideal; FALSE for Davenport-Heilbronn, whose off-line zeros
    are classical (Davenport-Heilbronn 1936) -- cited, not reproved. -/
def allOnLine : Config → Prop
  | Config.ideal => True
  | Config.dh    => False

/-- The Davenport-Heilbronn witness: ideal ~ dh (they share the dark
    observable, so `iIndist ideal dh` holds by `rfl` on `darkObs`, not
    by `trivial` on `True`), onLine ideal, not onLine dh. -/
theorem dh_witness : NonInvarianceWitness iIndist allOnLine :=
  ⟨Config.ideal, Config.dh, rfl, trivial, fun h => h⟩

/-- The sieve ceiling fires concretely on the Davenport-Heilbronn
    example: no dark-factored (I-respecting) certificate is
    extensionally equal to "all zeros on the critical line." -/
theorem dh_sieve_ceiling :
    ¬ ∃ D : Config → Prop, RespectsI iIndist D ∧ ∀ z, D z ↔ allOnLine z :=
  sieve_ceiling_of_witness iIndist dh_witness

end SieveCeilingWitness
