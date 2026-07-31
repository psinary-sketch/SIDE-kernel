/-
  InvarianceBarrier.lean

  The abstract relativization / oracle-separation lemma, in fully general form.

  A target property `P` is "determined by" an agreement class `agree` when `P`
  is invariant on it. The barrier: if two witnesses agree (are related by
  `agree`) yet diverge on `P` (P does not hold alike on both), then `P` is NOT
  determined by the class -- no method invariant on `agree` decides `P`.

  Fully general: arbitrary carrier `α`, arbitrary agreement relation, arbitrary
  property, arbitrary witness pair. There is NO object-level content here -- no
  zeta, no RH, no Euler product. Genre: relativization (Baker-Gill-Solovay);
  natural proofs (Razborov-Rudich).

  DELIBERATELY NOT PROVIDED: any instantiation to a specific system (e.g. an
  `agree` with a stipulated body separating two named objects). Supplying such a
  body in the kernel would encode the intended conclusion in a definition. The
  concrete agreement clause is a manuscript work-order
  (W-ORD-FACE-E-INDISTINGUISHABILITY), not a kernel definition -- it stays out
  of the kernel by design.
-/

namespace InvarianceBarrier

universe u
variable {α : Type u}

/-- `P` is *determined by* the class `agree` when `agree`-related points are
    indistinguishable by `P` (i.e. `P` is invariant on the relation). -/
def DeterminedBy (agree : α → α → Prop) (P : α → Prop) : Prop :=
  ∀ x y, agree x y → (P x ↔ P y)

/-- The invariance barrier (oracle separation).

    If two witnesses `x`, `y` **agree** (`agree x y`) yet **diverge** on the
    target property (`¬ (P x ↔ P y)`), then `P` is not determined by the class
    `agree`. Named hypotheses: `h_agree` (agreement), `h_diverge` (divergence). -/
theorem invariance_barrier
    {agree : α → α → Prop} {P : α → Prop} {x y : α}
    (h_agree : agree x y) (h_diverge : ¬ (P x ↔ P y)) :
    ¬ DeterminedBy agree P :=
  fun h_det => h_diverge (h_det x y h_agree)

/-- `x` *derives* `P` over the class `agree` when a derivation at `x` transports
    to every `agree`-related point (soundness / relativization: a proof using
    only class-accessible facts holds at every agreeing witness). This models
    derivability, not truth: `Derives agree P x` is strictly stronger than `P x`
    only through the class. -/
def Derives (agree : α → α → Prop) (P : α → Prop) (x : α) : Prop :=
  ∀ z, agree x z → P z

/-- The derivability barrier (soundness corollary of the invariance barrier).

    If witness `y` **agrees** with `x` (`agree x y`) yet the target property
    **fails** at `y` (`¬ P y`), then `x` does not derive `P` over the class --
    no derivation invariant on `agree` establishes `P` at `x`. Unlike
    `invariance_barrier`, this needs no divergence biconditional (hence no
    knowledge of `P x`): one agreeing counter-witness suffices. -/
theorem derivability_barrier
    {agree : α → α → Prop} {P : α → Prop} {x y : α}
    (h_agree : agree x y) (h_fail : ¬ P y) :
    ¬ Derives agree P x :=
  fun h_der => h_fail (h_der y h_agree)

end InvarianceBarrier
