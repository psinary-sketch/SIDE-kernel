/-
  SieveCeilingReal.lean

  First lift slot of the E-Difficulty skeleton: the abstract
  three-valued Kappa of Kernel/Cascade/SieveCeiling.lean is replaced
  by a real-valued transmission coefficient k in [0,1], with
  dark <-> k = 0. The variance-ratio reading k = 1 - Var[P|I]/Var[P]
  lands in [0,1], which the bounds below record.

  The skeleton's structural theorems (sieve_ceiling, e_difficulty,
  proof_dichotomy, bright_access_required) do not mention Kappa, so
  they are reused verbatim by import. This module supplies the
  real-valued interface and conservation layer, and a refinement
  showing a real-k system maps onto the abstract skeleton -- which
  transfers e_difficulty to the real system.

  Mathlib-dependent (Real). The vanilla skeleton stays vanilla.

  J. York Seale, PLACE TO STAND Research Programme
-/
import Mathlib.Data.Real.Basic
import Kernel.Cascade.SieveCeiling

namespace SieveCeilingReal

open Classical

/-- Real-valued transmission coefficient k in [0,1] at an interface.
    dark means k = 0 (carries no parameter information). -/
structure RInterface where
  kappa : Real
  kappa_nonneg : 0 ≤ kappa
  kappa_le_one : kappa ≤ 1
  essential : Bool

/-- Dark interface: k = 0. -/
def RInterface.isDark (I : RInterface) : Prop := I.kappa = 0

/-- A determined system with real-valued interfaces. -/
structure RDeterminedSystem where
  classes : Nat
  interfaces : Nat → RInterface

/-- Conservation (the n4 = 0 condition): every essential interface
    is dark, i.e. k = 0. -/
def RDeterminedSystem.isConserved (s : RDeterminedSystem) : Prop :=
  ∀ i : Nat, i < s.classes →
    (s.interfaces i).essential = true →
    (s.interfaces i).kappa = 0

/-- Collapse the real coefficient to the abstract three-valued token:
    0 to dark, 1 to bright, otherwise diffractive. -/
noncomputable def RInterface.toKappa (I : RInterface) : Kappa :=
  if I.kappa = 0 then Kappa.dark
  else if I.kappa = 1 then Kappa.bright
  else Kappa.diffractive

/-- k = 0 maps to the abstract dark token. -/
theorem RInterface.toKappa_dark_of_zero (I : RInterface) (h : I.kappa = 0) :
    I.toKappa = Kappa.dark := by
  unfold RInterface.toKappa
  rw [if_pos h]

/-- The abstract interface a real interface refines to. -/
noncomputable def RInterface.toInterface (I : RInterface) : Interface :=
  { kappa := I.toKappa, essential := I.essential }

/-- The abstract system a real system refines to. -/
noncomputable def RDeterminedSystem.toAbstract (s : RDeterminedSystem) :
    DeterminedSystem :=
  { classes := s.classes,
    interfaces := fun i => (s.interfaces i).toInterface }

/-- Real conservation refines to abstract conservation. -/
theorem isConserved_refines (s : RDeterminedSystem)
    (h : s.isConserved) : s.toAbstract.isConserved := by
  intro i hi hess
  have hk : (s.interfaces i).kappa = 0 := h i hi hess
  simp only [RDeterminedSystem.toAbstract, RInterface.toInterface]
  exact (s.interfaces i).toKappa_dark_of_zero hk

/-- E-Difficulty, transferred to a real-k system: for a conserved
    real system with at least one class, decidability of a universal
    property is equivalent to a domain-Ostrowski. -/
theorem e_difficulty_real (s : RDeterminedSystem)
    (h_cons : s.isConserved) (h_nt : s.classes ≥ 1) :
    IsDecidable s.toAbstract ↔ Nonempty (DomainOstrowski s.toAbstract) :=
  e_difficulty s.toAbstract (isConserved_refines s h_cons) h_nt

/-- xi's formation as a real-k system: 7 classes, every essential
    interface dark (k = 0). -/
noncomputable def xi_system_R : RDeterminedSystem :=
  { classes := 7,
    interfaces := fun _ =>
      { kappa := 0, kappa_nonneg := le_refl 0,
        kappa_le_one := zero_le_one, essential := true } }

theorem xi_conserved_R : xi_system_R.isConserved := by
  intro i _ _; rfl

theorem e_difficulty_xi_R :
    IsDecidable xi_system_R.toAbstract ↔
      Nonempty (DomainOstrowski xi_system_R.toAbstract) :=
  e_difficulty_real xi_system_R xi_conserved_R (by decide)

end SieveCeilingReal
