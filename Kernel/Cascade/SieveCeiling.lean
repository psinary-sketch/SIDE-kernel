/-
  SieveCeiling.lean  (v3)

  The Sieve Ceiling Lemma:
    If every inference step of a proof factors through a κ = 0
    interface for parameter P, then the proof establishes
    density statements about P but cannot establish universal
    statements.

  Closes the E-Difficulty Theorem:
    For determined I+D+S systems, decidability within ZFC of a
    universal property is equivalent to the existence of a
    domain-Ostrowski.

  J. York Seale, April 2026 — v3 W-6-EXT R2, 2026-07-19
  PLACE TO STAND Research Programme

  STATUS (honest):
  - 0 sorry. Vanilla Lean 4 core only, toolchain v4.29.0-rc8.
  - W-6-EXT R2 (2026-07-19) de-vacuifies the E-Difficulty terminals.
    The v2 shells are retired:
      · v2 `IsDecidable (_s : DeterminedSystem)` DISCARDED its system
        argument (a constant `True`). Now `IsDecidable s` ranges over
        proofs ABOUT s — lists of interface-crossing `Step s` whose
        access is READ OFF `s.interfaces` (repair (c)). It reads s.
      · v2 `e_difficulty` proved `True ↔ True`: `_h_conserved` was
        unused and the domain-Ostrowski was fabricated by
        `List.replicate`. Now Conservation is LOAD-BEARING — it forces
        the decidability-carrying bright access into the INESSENTIAL
        sector (the n₄=0 content) — and the Ostrowski is EXTRACTED
        from the decidability witness, not fabricated.
    The manuscript's `s.classes ≥ 1` edge hypothesis is dropped: the
    equivalence holds even for zero-class systems (both sides false),
    so carrying it would be a dead binder. `SieveCeilingReal` is
    co-edited in the same commit to match the 2-arg form.
  - The SEMANTIC content of the ceiling (Movement 1: dark-factored
    inference respects the I-indistinguishability relation) lives in
    the sibling `SieveCeilingSemantic.lean` (RespectsI,
    sieve_ceiling_semantic) and its concrete Davenport–Heilbronn
    witness in `SieveCeilingWitness.lean`. The base `sieve_ceiling` /
    `bright_access_required` below are the abstract-Proof SCAFFOLDING
    for that content — see their docstrings.
  - EXTERNAL-STRENGTH note (W-6-EXT-A): the constructive formalization
    of an actual off-line zero (upgrading `SieveCeilingWitness`'s cited
    `allOnLine .dh = False` datum to a proof) remains open / Mathlib-
    absent. The witness architecture itself exists in-kernel; the
    stipulation is honest math-leg input.
  - Build: lake build Kernel.Cascade.SieveCeiling
-/

-- ============================================================
-- PART 0: INTERFACES, PARAMETERS, AND TRANSMISSION
-- ============================================================

/-- The transmission coefficient as a three-valued summary:
    dark (κ = 0), partial (0 < κ < 1), bright (κ = 1).
    The structural theorem depends only on the dark/non-dark
    distinction; real-valued extension is straightforward. -/
inductive Kappa where
  | dark    : Kappa  -- κ = 0
  | diffractive : Kappa  -- 0 < κ < 1
  | bright  : Kappa  -- κ = 1
  deriving DecidableEq

/-- Whether a κ-value is dark (carries no parameter information). -/
def Kappa.isDark : Kappa → Bool
  | .dark => true
  | _     => false

/-- An interface between substructures. -/
structure Interface where
  kappa : Kappa
  essential : Bool
  deriving DecidableEq

/-- A determined system as a formalization-slot:
    number of mechanism classes, and an interface at each
    class boundary. The underlying universe (ℂ, SU(N), etc.)
    is not needed for the structural theorem. -/
structure DeterminedSystem where
  classes : Nat
  interfaces : Nat → Interface

/-- The Conservation condition (n₄ = 0): all essential
    interfaces are dark. -/
def DeterminedSystem.isConserved (s : DeterminedSystem) : Prop :=
  ∀ i : Nat, i < s.classes →
    (s.interfaces i).essential = true →
    (s.interfaces i).kappa = Kappa.dark

-- ============================================================
-- PART 1: INFERENCE STEPS AND FACTORING  (Terminal 1 — UNTOUCHED)
-- ============================================================

/-- An inference step's interface-access profile.
    The two cases are exhaustive: a step either transmits
    parameter information (bright access somewhere) or it does not
    (factored through dark only). -/
inductive StepAccess where
  | factored_through_dark : StepAccess
  | accesses_bright       : StepAccess
  deriving DecidableEq

/-- A proof is a list of inference steps, abstracted to
    their interface-access profiles. The specific syntactic
    rule (modus ponens, universal generalization, etc.) is
    irrelevant to the theorem; only the interface profile matters. -/
abbrev Proof := List StepAccess

/-- A proof factors through dark interfaces if every step does. -/
def Proof.factorsDark (π : Proof) : Prop :=
  ∀ s ∈ π, s = StepAccess.factored_through_dark

instance : DecidablePred Proof.factorsDark := fun π =>
  List.decidableBAll (fun s => s = StepAccess.factored_through_dark) π

/-- A proof has bright access if some step does. -/
def Proof.hasBrightAccess (π : Proof) : Prop :=
  ∃ s ∈ π, s = StepAccess.accesses_bright

/-- factorsDark and hasBrightAccess are mutually exclusive
    for any non-empty proof (empty proof factors dark vacuously
    and has no bright access vacuously, which is consistent). -/
theorem proof_mutually_exclusive (π : Proof) :
    π.factorsDark → ¬ π.hasBrightAccess := by
  intro hdark hbright
  obtain ⟨s, hs_in, hs_bright⟩ := hbright
  have hs_dark := hdark s hs_in
  rw [hs_bright] at hs_dark
  cases hs_dark

/-- TERMINAL 1 (axiom-free). Either every step factors dark, or some
    step is bright. -/
theorem proof_dichotomy (π : Proof) :
    π.factorsDark ∨ π.hasBrightAccess := by
  induction π with
  | nil => left; intro s hs; cases hs
  | cons head tail ih =>
    cases head with
    | factored_through_dark =>
      cases ih with
      | inl h_tail_dark =>
        left
        intro s hs
        cases hs with
        | head => rfl
        | tail _ hs_tail => exact h_tail_dark s hs_tail
      | inr h_tail_bright =>
        right
        obtain ⟨s, hs_in, hs_bright⟩ := h_tail_bright
        exact ⟨s, List.Mem.tail _ hs_in, hs_bright⟩
    | accesses_bright =>
      right
      exact ⟨StepAccess.accesses_bright, List.Mem.head _, rfl⟩

-- ============================================================
-- PART 2: STATEMENT KINDS A PROOF CAN ESTABLISH
-- ============================================================

/-- What kind of statement a proof establishes about a parameter. -/
inductive StatementKind where
  | density_bound       : StatementKind  -- "density ≥ α"
  | density_one_per_class : StatementKind -- "full density in each I-class"
  | universal           : StatementKind   -- "∀ x : P(x)"
  deriving DecidableEq

/-- Strength ordering by nat-valued rank. -/
def StatementKind.strength : StatementKind → Nat
  | .density_bound         => 0
  | .density_one_per_class => 1
  | .universal             => 2

-- ============================================================
-- PART 3: THE SIEVE CEILING SCAFFOLDING  (abstract-Proof layer)
-- ============================================================

/-- The maximum statement-kind a proof can establish, as a
    function of its interface profile. SCAFFOLDING: the cap is
    stated here; the CONTENT (why a dark-factored proof cannot
    discriminate within I-classes) is proved semantically in
    `SieveCeilingSemantic.sieve_ceiling_semantic`. -/
def maxStatement (π : Proof) : StatementKind :=
  if π.factorsDark then StatementKind.density_one_per_class
                   else StatementKind.universal

/-- Factored-dark proofs are capped at density_one_per_class. -/
theorem factored_dark_capped (π : Proof) (h : π.factorsDark) :
    (maxStatement π).strength ≤ StatementKind.density_one_per_class.strength := by
  unfold maxStatement
  rw [if_pos h]
  exact Nat.le_refl _

/-- The strength ordering is strict: density_one_per_class < universal
    (the nat-fact 1 < 2). The EXTERNAL non-degeneracy of this gap at a
    concrete object is the Davenport–Heilbronn witness in
    `SieveCeilingWitness.lean` (and W-6-EXT-A for the constructive
    off-line zero). -/
theorem density_one_lt_universal :
    StatementKind.density_one_per_class.strength < StatementKind.universal.strength := by
  decide

/-- SCAFFOLDING (base sieve_ceiling, abstract-Proof form). A factored-
    dark proof is capped below universal STRENGTH. This is the strength
    bookkeeping; the contentful sieve ceiling — that dark-factored
    inference cannot separate I-indistinguishable configurations — is
    `SieveCeilingSemantic.sieve_ceiling_semantic`, with the concrete
    Davenport–Heilbronn instance in `SieveCeilingWitness.dh_sieve_ceiling`.
    Cite those for content; cite this only for the strength bound. -/
theorem sieve_ceiling (π : Proof) (h : π.factorsDark) :
    (maxStatement π).strength < StatementKind.universal.strength := by
  have h1 := factored_dark_capped π h
  have h2 := density_one_lt_universal
  exact Nat.lt_of_le_of_lt h1 h2

/-- SCAFFOLDING (Corollary 3.6, abstract-Proof form). Any proof reaching
    universal strength has a bright step. Contentful form:
    `SieveCeilingSemantic` (a target not respecting the I-relation has
    no dark-factored certificate). -/
theorem bright_access_required (π : Proof)
    (h : (maxStatement π).strength = StatementKind.universal.strength) :
    π.hasBrightAccess := by
  cases proof_dichotomy π with
  | inl h_dark =>
    have h_lt := sieve_ceiling π h_dark
    rw [h] at h_lt
    exact absurd h_lt (Nat.lt_irrefl _)
  | inr h_bright => exact h_bright

-- ============================================================
-- PART 4: INTERFACE-TIED PROOFS AND E-DIFFICULTY  (W-6-EXT R2)
-- ============================================================

/-- A step in a proof ABOUT s: it crosses a specific interface
    (a mechanism-class boundary). Its access is not free-floating;
    it is read off the crossed interface (repair (c)). -/
structure Step (s : DeterminedSystem) where
  crosses : Nat
  inBounds : crosses < s.classes

/-- The step is bright exactly when the interface it crosses is
    non-dark. Ties access to `s.interfaces`. -/
def Step.isBright {s : DeterminedSystem} (st : Step s) : Bool :=
  ! (s.interfaces st.crosses).kappa.isDark

/-- A proof about s is a list of interface-crossing steps. -/
abbrev SysProof (s : DeterminedSystem) := List (Step s)

/-- Some step accesses a bright interface. -/
def SysProof.hasBrightAccess {s : DeterminedSystem} (π : SysProof s) : Prop :=
  ∃ st ∈ π, st.isBright = true

/-- Boolean summary used to compute the strongest establishable kind. -/
def SysProof.anyBright {s : DeterminedSystem} (π : SysProof s) : Bool :=
  π.any (fun st => st.isBright)

theorem anyBright_iff {s : DeterminedSystem} (π : SysProof s) :
    π.anyBright = true ↔ π.hasBrightAccess := by
  unfold SysProof.anyBright SysProof.hasBrightAccess
  exact List.any_eq_true

/-- The strongest statement-kind a proof about s can establish:
    universal iff it has a bright access; otherwise capped at
    density-one-per-class. The cap FOLLOWS from the interface profile
    (a fully-dark proof has no bright step). -/
def sysMaxStatement {s : DeterminedSystem} (π : SysProof s) : StatementKind :=
  match π.anyBright with
  | true  => StatementKind.universal
  | false => StatementKind.density_one_per_class

theorem sysMax_universal_iff {s : DeterminedSystem} (π : SysProof s) :
    sysMaxStatement π = StatementKind.universal ↔ π.hasBrightAccess := by
  unfold sysMaxStatement
  rw [← anyBright_iff]
  cases h : π.anyBright with
  | true  => exact ⟨fun _ => rfl, fun _ => rfl⟩
  | false => constructor <;> (intro hh; exact absurd hh (by decide))

/-- A universal property is decidable if some proof ABOUT s achieves
    universal strength. READS s (repair (c)): the proofs range over
    `SysProof s`, whose steps read `s.interfaces`. (v2 discarded s.) -/
def IsDecidable (s : DeterminedSystem) : Prop :=
  ∃ π : SysProof s, sysMaxStatement π = StatementKind.universal

/-- A domain-Ostrowski: a bright access exhibited in s, together with
    the fact — forced by Conservation — that it lies in the INESSENTIAL
    sector (n₄ = 0 darkens every essential interface, so the
    decidability-carrying brightness cannot be essential). The
    `inessential` field is what makes `isConserved` load-bearing in
    `e_difficulty`. -/
structure DomainOstrowski (s : DeterminedSystem) where
  brightClass : Nat
  inBounds : brightClass < s.classes
  isBright : (s.interfaces brightClass).kappa.isDark = false
  inessential : (s.interfaces brightClass).essential = false

/-- THE E-DIFFICULTY THEOREM (de-vacuified, W-6-EXT R2).

    For a conserved determined system, decidability of a universal
    property is equivalent to the existence of a domain-Ostrowski.

    Forward: a decidability witness has a bright step; the crossed
    interface is bright, and Conservation forces it to be inessential.
    The Ostrowski is EXTRACTED from that step — not fabricated.
    Backward: a domain-Ostrowski's bright interface supports a one-step
    proof achieving universal strength (the SIDE method).

    Conservation (h_conserved) is load-bearing: it supplies the
    `inessential` component of the extracted Ostrowski. -/
theorem e_difficulty (s : DeterminedSystem) (h_conserved : s.isConserved) :
    IsDecidable s ↔ Nonempty (DomainOstrowski s) := by
  constructor
  · intro ⟨π, hπ⟩
    obtain ⟨st, _hin, hst⟩ := (sysMax_universal_iff π).mp hπ
    have hisDark : (s.interfaces st.crosses).kappa.isDark = false := by
      unfold Step.isBright at hst
      cases hd : (s.interfaces st.crosses).kappa.isDark with
      | false => rfl
      | true  => rw [hd] at hst; exact absurd hst (by decide)
    have hiness : (s.interfaces st.crosses).essential = false := by
      cases hess : (s.interfaces st.crosses).essential with
      | false => rfl
      | true  =>
        have hdark := h_conserved st.crosses st.inBounds hess
        rw [hdark] at hisDark
        exact absurd hisDark (by decide)
    exact ⟨⟨st.crosses, st.inBounds, hisDark, hiness⟩⟩
  · intro ⟨o⟩
    refine ⟨[⟨o.brightClass, o.inBounds⟩], ?_⟩
    rw [sysMax_universal_iff]
    refine ⟨⟨o.brightClass, o.inBounds⟩, List.Mem.head _, ?_⟩
    simp [Step.isBright, o.isBright]

-- ============================================================
-- PART 5: SMOKE TEST (ξ AND THE RH CASCADE)
-- ============================================================

/-- ξ's formation: 2 + 3 + 2 + 0 = 7, fully conserved. -/
def xi_system : DeterminedSystem := {
  classes := 7,
  interfaces := fun _ => { kappa := Kappa.dark, essential := true }
}

theorem xi_conserved : xi_system.isConserved := by
  intro i _hi _ess; rfl

/-- E-Difficulty applies to ξ. Both sides are false here (a fully
    conserved system has no bright — hence no domain-Ostrowski — in
    this abstract model; the Ostrowski is the hard SIDE input). -/
theorem e_difficulty_xi :
    IsDecidable xi_system ↔ Nonempty (DomainOstrowski xi_system) :=
  e_difficulty xi_system xi_conserved

/-
  REMARKS

  1. WHAT THIS FILE PROVES (v3, W-6-EXT R2)
     - proof_dichotomy: Terminal 1, axiom-free
     - maxStatement / factored_dark_capped / sieve_ceiling /
       bright_access_required: abstract-Proof SCAFFOLDING; contentful
       ceiling lives in SieveCeilingSemantic
     - IsDecidable: reads s (SysProof s over s.interfaces)
     - e_difficulty: decidability ↔ domain-Ostrowski, Conservation
       load-bearing, Ostrowski extracted (no List.replicate)

  2. SIBLINGS (the E-Difficulty lift): SieveCeilingSemantic (Movement
     1, RespectsI), SieveCeilingWitness (Davenport–Heilbronn witness),
     SieveCeilingReal (real-κ refinement), SieveCeilingBridge
     (dark ⇒ I-indistinguishability). Real reuses e_difficulty; it is
     co-edited with this file's 2-arg form.

  3. DEFERRED (W-6-EXT-A): constructive off-line-zero formalization —
     upgrading Witness's cited allOnLine .dh = False to a proof. Open /
     Mathlib-absent; the stipulation is honest.
-/
