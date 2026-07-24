/-
  Voice7Witness.lean

  W-ORD-C7-WITNESS: the faithful de-encode of C₇ as a compiled NEGATIVE.

  This is the two-point Epstein-vs-ideal countermodel promised by the
  σ-neutral stand-in `hadamard_contrib := 0` (Bridge/TheBridgeComplete)
  and `topological_contribution := 0` (Kernel/Voice7). It is modelled on
  the in-repo kin `SieveCeilingWitness.dh_sieve_ceiling` /
  `SieveCeilingBridge.blind_sieve_ceiling` -- NOT on CartanBBridge's T3
  (an open set-aside external input, not a countermodel).

  WHAT THIS PROVES (a compiled NEGATIVE, what C₇'s presence provably
  CANNOT do). Two configurations both carry the Hadamard-product
  property -- the arithmetic ideal (RH holds) and a completed
  Epstein-type zeta -- yet the Epstein object has OFF-LINE zeros
  (classical: Davenport-Heilbronn 1936, the discriminant -23 Epstein
  zero; monograph Ch 17, §917/§933/§1845). Because the two share the
  Hadamard/FE observable, no observable-respecting certificate captures
  "all zeros on the line": the terminal `hadamard_does_not_enforce_online`.
  Presence of the Hadamard product does not enforce on-line placement --
  a model-theoretic (necessary-not-sufficient) statement, now compiled.

  ANTI-OVERCLAIM (load-bearing). The `rfl`/`trivial` proofs certify the
  ARCHITECTURE -- that the mere PRESENCE of a Hadamard/FE reading cannot
  enforce on-line placement -- NOT any analytic property of ξ's actual
  Hadamard product. The off-line-zeros fact is a STIPULATED CITED DATUM
  (`allOnLine .epstein = False`), the analogue of `allOnLine .dh = False`:
  it is consumed here, never reproved. Both the Epstein off-line-zeros
  theorem and the genus-1 Hadamard/Weierstrass factorization are
  Mathlib-ABSENT at pin `e960b84` (Analysis/Complex/Hadamard.lean is the
  three-lines theorem only; no product-over-zeros, no order-of-growth) --
  they are math-leg input, cited, not carried by this kernel module.

  TRIPLE-ROLE / CROSS-LINK. The single Epstein object here serves three
  roles off ONE `allOnLine .epstein = False` citation:
    (i)   the prose Epstein discriminator (monograph Ch 17:
          Euler-product-ABSENT ⇒ off-line zeros allowed);
    (ii)  this compiled countermodel (Hadamard-present cannot enforce);
    (iii) the W-6-EXT-A stipulation (same Epstein datum, second terminal).
  The shared observable `hadObs` reads the Euler-product-FREE content
  (Hadamard factorization + functional-equation symmetry -- what the
  Epstein object SHARES with ξ) and is BLIND to the Euler product (what
  the Epstein object LACKS). Under that naming the terminal says exactly:
  a reading seeing only Hadamard/FE cannot separate ideal from Epstein,
  so it cannot enforce on-line placement -- the separating structure
  would have to be the (absent) Euler product. That IS the prose
  discriminator, faithfully mirrored.

  Core Lean + the SieveCeiling semantic engine only. Zero edits to
  existing files. 0 sorry, 0 native_decide.

  J. York Seale, PLACE TO STAND Research Programme (post-v1.5)
-/
import Kernel.Cascade.SieveCeilingSemantic
import Kernel.Cascade.SieveCeilingBridge

namespace Voice7Witness

open SieveCeilingSemantic

/-- Two configurations, both possessing the Hadamard-product property:
    the arithmetic ideal (RH holds) and a completed Epstein-type zeta
    (Hadamard factorization present, functional equation present, yet
    OFF-LINE zeros). Kin to `SieveCeilingWitness.Config` (ideal/dh). -/
inductive Config where
  | ideal   : Config
  | epstein : Config
deriving DecidableEq

/-- The shared observable: the Euler-product-FREE content a Hadamard/FE
    reading sees -- the Hadamard factorization together with the
    functional-equation symmetry `s ↦ 1 − s`. This is what the Epstein
    object SHARES with ξ; the reading is BLIND to the Euler product
    (which the Epstein object LACKS). Both configurations present the
    SAME observable (`true`) -- the honest modelling stipulation, the
    analogue of `SieveCeilingWitness.darkObs`. Being constant, it is
    `Blind` (a κ = 0 / dark reading). -/
def hadObs : Config → Bool
  | Config.ideal   => true
  | Config.epstein => true

/-- Indistinguishability is the KERNEL of the Hadamard/FE reading: two
    configurations are indistinguishable exactly when the reading sees
    the same observable. This READS ITS ARGUMENTS -- the equality
    `hadObs x = hadObs y`, not the total relation `True` (the retired
    vacuity of W-6). Reuses the `SieveCeilingWitness.iIndist` shape. -/
def hadIndist (x y : Config) : Prop := hadObs x = hadObs y

/-- The observable is `Blind` in the `SieveCeilingBridge` sense: it is
    constant, so it separates nothing (the κ = 0 darkness at the level
    of the reading). -/
theorem hadObs_blind : SieveCeilingBridge.Blind hadObs := by
  intro x y; cases x <;> cases y <;> rfl

/-- Non-totality screen: the reading-kernel is genuinely a reading, not
    the total relation `True` -- distinct observables are NOT related.
    (`Bool` has distinct inhabitants; a configuration presenting `false`
    would be distinguished from `ideal`. The two-point Config presents
    no such pair only because `ideal` and `epstein` SHARE the Hadamard/FE
    observable by stipulation -- that shared observable IS the dark
    reading, cf. `SieveCeilingWitness.darkReading_capable_of_falsity`.) -/
theorem hadReading_capable_of_falsity : ¬ (∀ b c : Bool, b = c) :=
  fun h => Bool.noConfusion (h true false)

/-- The universal property under test: all zeros on the critical line.
    True for the ideal; FALSE for the Epstein-type object, whose off-line
    zeros are classical (Davenport-Heilbronn 1936; discriminant -23;
    monograph Ch 17) -- the STIPULATED CITED DATUM, consumed not reproved.
    This is the SINGLE citation shared with the prose Epstein
    discriminator and with W-6-EXT-A (triple-role). -/
def allOnLine : Config → Prop
  | Config.ideal   => True
  | Config.epstein => False

/-- The Epstein witness: `ideal ~ epstein` (they share the Hadamard/FE
    observable, so `hadIndist ideal epstein` holds by `rfl` on `hadObs`),
    `allOnLine ideal`, `¬ allOnLine epstein`. Kin to
    `SieveCeilingWitness.dh_witness`. -/
theorem hadamard_witness : NonInvarianceWitness hadIndist allOnLine :=
  ⟨Config.ideal, Config.epstein, rfl, trivial, id⟩

/-- **THE COMPILED NEGATIVE.** Presence of the Hadamard product does NOT
    enforce on-line placement: no Hadamard/FE-respecting certificate is
    extensionally equal to "all zeros on the critical line." The mere
    presence of the Hadamard factorization cannot separate the ideal from
    the Epstein object, so it cannot certify the universal property.

    This is what C₇'s presence provably CANNOT do -- the faithful
    de-encode filed as W-ORD-C7-WITNESS. It does NOT positively de-encode
    `hadamard_contrib`/`topological_contribution` (the σ-neutrality shape
    `∀σ, g σ = g(1/2)` has no non-vacuous model); it compiles the
    necessary-not-sufficient argument instead. Kin to
    `SieveCeilingWitness.dh_sieve_ceiling`. -/
theorem hadamard_does_not_enforce_online :
    ¬ ∃ D : Config → Prop, RespectsI hadIndist D ∧ ∀ z, D z ↔ allOnLine z :=
  sieve_ceiling_of_witness hadIndist hadamard_witness

/-- The same terminal via the generalized blind-reading route
    (`SieveCeilingBridge.blind_sieve_ceiling`): a blind (dark) Hadamard/FE
    observable plus a separating pair (the Epstein off-line datum) yields
    the ceiling. Demonstrates reuse of the second in-repo kin; the
    induced relation `obsRel hadObs` is def-eq to `hadIndist`. -/
theorem hadamard_does_not_enforce_online' :
    ¬ ∃ D : Config → Prop,
      RespectsI (SieveCeilingBridge.obsRel hadObs) D ∧ ∀ z, D z ↔ allOnLine z :=
  SieveCeilingBridge.blind_sieve_ceiling hadObs_blind
    ⟨Config.ideal, Config.epstein, trivial, id⟩

end Voice7Witness
