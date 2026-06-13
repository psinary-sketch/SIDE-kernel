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

/-- I-indistinguishability: same functional equation, same
    density-one-on-line statistics, so the dark interface cannot
    separate the two configurations. -/
def iIndist (_ _ : Config) : Prop := True

/-- The universal property: all zeros on the critical line. True for
    the ideal; FALSE for Davenport-Heilbronn, whose off-line zeros
    are classical (Davenport-Heilbronn 1936) -- cited, not reproved. -/
def allOnLine : Config → Prop
  | Config.ideal => True
  | Config.dh    => False

/-- The Davenport-Heilbronn witness: ideal ~ dh, onLine ideal,
    not onLine dh. -/
theorem dh_witness : NonInvarianceWitness iIndist allOnLine :=
  ⟨Config.ideal, Config.dh, trivial, trivial, fun h => h⟩

/-- The sieve ceiling fires concretely on the Davenport-Heilbronn
    example: no dark-factored (I-respecting) certificate is
    extensionally equal to "all zeros on the critical line." -/
theorem dh_sieve_ceiling :
    ¬ ∃ D : Config → Prop, RespectsI iIndist D ∧ ∀ z, D z ↔ allOnLine z :=
  sieve_ceiling_of_witness iIndist dh_witness

end SieveCeilingWitness
