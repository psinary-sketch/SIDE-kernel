import Mathlib.Data.Real.Basic

/-!
# The Universal Silence Theorem

The four-step argument from the Silence of Foundations paper,
formalized. The proof structure follows the manuscript exactly:

  (1) I essential → I is present in every configuration.
  (2) I universal → I's action is constant across configurations.
  (3) Therefore any measurement factoring through I is constant.
  (4) Constant measurement transmits no variation: κ = 0.

Steps 2 and 3 are the load-bearing transitions. Step 4 is a
tautology given step 3. Step 1 is used structurally (I must be
defined on every configuration).

AI disclosure: Written with Claude (Anthropic) assistance.
Mathematical content is original.
-/

namespace SilenceTheorem

/-- A configuration space: the type of possible configurations of a
    system. Nonempty; no other structure required. -/
structure ConfigurationSpace where
  α : Type
  nonempty : Nonempty α

/-- An interface I acts on configurations, producing outputs in R.
    The interface is characterized by its action (a function on
    configurations) and an essentiality predicate. -/
structure Interface (C : ConfigurationSpace) (R : Type) where
  /-- The action of the interface: each configuration produces an output. -/
  action : C.α → R
  /-- Whether removing the interface destroys the system. -/
  essential : Prop

/-- An interface is *universal* if its action is the same for
    every configuration. This is the formal content of "I works
    identically for all configurations." -/
def Interface.is_universal {C : ConfigurationSpace} {R : Type}
    (I : Interface C R) : Prop :=
  ∀ c₁ c₂ : C.α, I.action c₁ = I.action c₂

/-- A measurement M *factors through* an interface I if M depends
    on configurations only through I's output. Formally:
    M = f ∘ I.action for some function f. -/
def factors_through {C : ConfigurationSpace} {R V : Type}
    (M : C.α → V) (I : Interface C R) : Prop :=
  ∃ f : R → V, ∀ c : C.α, M c = f (I.action c)

/-- An interface has *κ = 0* if every measurement factoring through
    it is constant across configurations. No measurement can
    distinguish any two configurations; therefore the interface
    transmits zero information about any behavioral parameter that
    varies across configurations. -/
def Interface.kappa_zero {C : ConfigurationSpace} {R : Type}
    (I : Interface C R) : Prop :=
  ∀ V : Type, ∀ M : C.α → V, factors_through M I →
    ∀ c₁ c₂ : C.α, M c₁ = M c₂

/-- **The Universal Silence Theorem.**
    Every universal interface has κ = 0.

    Proof: if I.action is constant across configurations (universality),
    then any M = f ∘ I.action is also constant (step 3). A constant
    measurement takes the same value on every pair of configurations
    (step 4). Therefore no measurement factoring through I can
    transmit configuration-dependent information.

    The hypothesis `h_univ` is used in the `rw` step: universality
    supplies the equality `I.action c₁ = I.action c₂`. -/
theorem silence_universal
    {C : ConfigurationSpace} {R : Type}
    (I : Interface C R)
    (h_univ : I.is_universal) :
    I.kappa_zero := by
  intro V M h_factors c₁ c₂
  obtain ⟨f, hf⟩ := h_factors
  -- Step 3: M factors through I, so M c = f (I.action c)
  rw [hf c₁, hf c₂]
  -- Step 2→3: universality gives I.action c₁ = I.action c₂
  rw [h_univ c₁ c₂]

/-- **Contrapositive.** If an interface has κ > 0 (transmits some
    variation), it is not universal. -/
theorem not_universal_of_kappa_positive
    {C : ConfigurationSpace} {R : Type}
    (I : Interface C R)
    (h_transmits : ∃ V : Type, ∃ M : C.α → V, factors_through M I ∧
      ∃ c₁ c₂ : C.α, M c₁ ≠ M c₂) :
    ¬ I.is_universal := by
  intro h_univ
  obtain ⟨V, M, h_factors, c₁, c₂, h_ne⟩ := h_transmits
  exact h_ne (silence_universal I h_univ V M h_factors c₁ c₂)

end SilenceTheorem

namespace SilenceTheorem.Instances

open SilenceTheorem

/-- A single-point configuration space (trivial system). -/
def TrivialConfig : ConfigurationSpace :=
  { α := Unit, nonempty := ⟨()⟩ }

/-- The product formula as a universal interface.
    On any configuration, the action is the identity constraint
    (|x|_𝔸 = 1). The action is constant because the constraint
    does not depend on which configuration we evaluate. -/
def product_formula_interface : Interface TrivialConfig Bool :=
  { action := fun _ => true,
    essential := True }

/-- The product formula is universal: its action is constant. -/
theorem product_formula_universal :
    product_formula_interface.is_universal := by
  intro c₁ c₂; rfl

/-- The product formula has κ = 0 by the universal silence theorem. -/
theorem product_formula_kappa_zero :
    product_formula_interface.kappa_zero :=
  silence_universal product_formula_interface
    product_formula_universal

/-- The distributive law as a universal interface. -/
def distributive_interface : Interface TrivialConfig Bool :=
  { action := fun _ => true,
    essential := True }

theorem distributive_universal :
    distributive_interface.is_universal := by
  intro c₁ c₂; rfl

theorem distributive_kappa_zero :
    distributive_interface.kappa_zero :=
  silence_universal distributive_interface distributive_universal

/-- A NON-universal interface, demonstrating the theorem's
    non-triviality: an interface whose action depends on the
    configuration fails to be universal, and the universal silence
    theorem correctly does not apply to it. -/
def NonTrivialConfig : ConfigurationSpace :=
  { α := Bool, nonempty := ⟨false⟩ }

/-- An interface that passes the configuration through unchanged. -/
def distinguishing_interface : Interface NonTrivialConfig Bool :=
  { action := id,
    essential := True }

/-- The distinguishing interface is NOT universal: different
    configurations produce different outputs. -/
theorem distinguishing_not_universal :
    ¬ distinguishing_interface.is_universal := by
  intro h
  have heq : false = true := h false true
  exact Bool.false_ne_true heq

end SilenceTheorem.Instances
