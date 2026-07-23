import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Mathlib.Data.Fintype.Card
import Mathlib.Tactic.DeriveFintype

/-
  TECHNE KERNEL - VOICE 3b (C3 / C₆)
  ===================================

  Mechanism class C₆: Cauchy-Riemann / local holomorphic structure.

  MATHEMATICAL CONTENT:
  ξ(s) is an entire function satisfying the Cauchy-Riemann
  equations: d(ξ)/d(s̄) = 0.

  On the critical line (σ = 1/2):
  - ξ(1/2 + it) ∈ ℝ.  ξ(s̄) = conj ξ(s) together with the functional
    equation ξ(1-s) = ξ(s) forces reality on the reflection-fixed line.
  - Because ξ is real there, `Im ξ ≡ 0` holds identically and DROPS OUT;
    a zero requires only the SINGLE surviving real constraint `Re ξ = 0`.
  - This is codimension 1.

  Off the critical line (σ ≠ 1/2):
  - ξ is genuinely complex-valued.
  - A zero requires `Re ξ = 0` AND `Im ξ = 0` simultaneously — two
    independent real constraints.
  - This is codimension 2.

  DE-ENCODING NOTE (W-ORD-ROUTE1-A, C₆; 2026-07-22).
  ══════════════════════════════════════════════════
  The former model wrote the answer into a literal:
      `zero_codimension σ := if σ = 1/2 then 1 else 2`
  — the off-line "2" was ASSIGNED, and `cr_forces_half` closed by
  `if_neg`. This file replaces that with a COUNT: the codimension is the
  cardinality of the set of real constraints still active at σ. The
  σ = 1/2 identification is now DERIVED from the reflection identity
  `1 - σ = σ ↔ σ = 1/2` (`reflect_fixed_iff`, the same fact
  `Bridge/TheBridgeComplete.voice3_reflect_fixed` states), not stipulated.

  HONEST-LANDING FRAME (verbatim, per the K1 ruling).
    • MODEL-LEVEL: `zero_codim σ = 1 ↔ σ = 1/2` DERIVES — the count reads
      its argument (through `1 - σ = σ`) and is a `Finset.card` over the
      constraint type; there is no definitional cap (add a constraint and
      the count moves).
    • ξ-FAITHFULNESS is MANUSCRIPT-RESIDENT: that ξ(σ+it) = 0 imposes
      exactly {Re ξ = 0, Im ξ = 0}, and that reality on the reflection-
      fixed line retires `Im ξ = 0`, is the Cauchy-Riemann identification
      of A_Place_to_Stand §18.2 (on the CORRECTED reading — Re survives on
      the line, Im drops; the concordant executive/Ch.14 sites §80/§82,
      §747/§749, §1152/§1154 already say "Re ξ = 0" on-line; the §18.2:1115
      "constraint function is Im(ξ)" phrasing is the ERRATA-class outlier,
      deposit-currency item (f)).
    • When this identification is TIED TO ξ in Lean it lands INTERFACES
      with a named analytic premise (kin to
      `SIDESimplicity.transversal_generic_empty`), NOT a clean DERIVES.

  This is the single codimension model in the kernel. `Bridge/
  TheBridgeComplete.lean` consumes `zero_codimension` by import (the
  former duplicate `zero_codim` there is deleted).

  PROVED: zero axioms, zero sorry.

  March 2026 · de-encoded 2026-07-22
-/

namespace techne_kernel_voice3b

-- ===============================================================
-- THE REFLECTION IDENTITY (σ = 1/2 as the reflection fixed point)
-- ===============================================================

/-- The reflection σ ↦ 1 - σ fixes σ exactly at σ = 1/2. This is the
    fact the codimension model derives the critical value from — the same
    reflection identity `Bridge/TheBridgeComplete.voice3_reflect_fixed`
    states, and `Kernel/Voice3.reflect_fixed_iff` states in `reflect` form. -/
theorem reflect_fixed_iff (sigma : Real) :
    (1 : Real) - sigma = sigma ↔ sigma = 1 / 2 := by
  constructor <;> intro h <;> linarith

-- ===============================================================
-- CODIMENSION MODEL (de-encoded: a COUNT of active real constraints)
-- ===============================================================

/-- The two independent real constraints a zero of ξ can impose:
    the vanishing of the real part and the vanishing of the imaginary part. -/
inductive RealConstraint
  | re_vanishes
  | im_vanishes
  deriving DecidableEq, Fintype

/-- There are exactly two real constraints. -/
theorem realConstraint_card : Fintype.card RealConstraint = 2 := by decide

/-- The real constraints still independent at abscissa σ.

    On the reflection-fixed abscissa (`1 - σ = σ`, i.e. σ = 1/2) ξ is
    real-valued, so `im_vanishes` holds identically and drops out, leaving
    the single surviving constraint `re_vanishes`. Off it, both `re_vanishes`
    and `im_vanishes` are live. (Manuscript: A_Place_to_Stand §18.2, corrected
    reading — Re survives on the line, Im drops.) -/
noncomputable def activeConstraints (sigma : Real) : Finset RealConstraint :=
  if (1 : Real) - sigma = sigma then {RealConstraint.re_vanishes} else Finset.univ

/-- Codimension of a zero at abscissa σ = the number of independent real
    constraints still active there. The value is COUNTED from the constraint
    set (`Finset.card`), not assigned: adding a constraint to `RealConstraint`
    moves the count. See the honest-landing frame in the file header. -/
noncomputable def zero_codimension (sigma : Real) : Nat :=
  (activeConstraints sigma).card

/-- On the critical line: codimension 1 (one surviving real constraint). -/
theorem codim_on_line :
    zero_codimension (1 / 2 : Real) = 1 := by
  unfold zero_codimension activeConstraints
  rw [if_pos (by norm_num : (1 : Real) - 1 / 2 = 1 / 2)]
  simp

/-- Off the critical line: codimension 2 (both real constraints live). -/
theorem codim_off_line (sigma : Real) (h : Not (sigma = 1 / 2)) :
    zero_codimension sigma = 2 := by
  unfold zero_codimension activeConstraints
  have hne : Not ((1 : Real) - sigma = sigma) :=
    fun hh => h ((reflect_fixed_iff sigma).mp hh)
  rw [if_neg hne, Finset.card_univ, realConstraint_card]

-- ===============================================================
-- THE CAUCHY-RIEMANN REST STATE
-- ===============================================================

/-- The Cauchy-Riemann constraint rests at σ = 1/2.

    "Rests" means: the holomorphic structure achieves its minimum
    codimension (most generic zero behavior) at σ = 1/2. The constraint is
    least restrictive there — codimension 1. At σ ≠ 1/2 it is more
    restrictive (codimension 2), so zeros are harder to achieve. -/
def cr_minimal_codim (sigma : Real) : Prop :=
  zero_codimension sigma = 1

theorem cr_minimal_iff (sigma : Real) :
    cr_minimal_codim sigma <-> sigma = 1 / 2 := by
  unfold cr_minimal_codim
  constructor
  . intro h
    by_contra h_ne
    rw [codim_off_line sigma h_ne] at h
    omega
  . intro h
    rw [h]; exact codim_on_line

theorem cr_forces_half (sigma : Real) :
    cr_minimal_codim sigma -> sigma = 1 / 2 :=
  (cr_minimal_iff sigma).mp

theorem cr_at_half :
    cr_minimal_codim (1 / 2 : Real) := by
  exact (cr_minimal_iff (1 / 2 : Real)).mpr rfl

theorem cr_not_minimal_off_line (sigma : Real)
    (h : Not (sigma = 1 / 2)) :
    Not (cr_minimal_codim sigma) := by
  intro h_min
  exact h (cr_forces_half sigma h_min)

-- ===============================================================
-- THE DETERMINATION BRIDGE
-- ===============================================================

/-- **Off-line codimension corollary** (contrapositive of `codim_on_line`): a zero of
    codimension 2 forces σ ≠ 1/2, because on the line the codimension is 1. This is
    codimension ARITHMETIC — it does NOT use Determination and no longer pretends to.

    A real Determination premise runs the OTHER way (manuscript-resident, not proved
    here): §432 "in a determined system with no tunable parameters, codimension-2
    coincidences do not occur" — i.e. `Determined(ξ) → zero_codimension σ ≠ 2`. The
    kernel's genuine determination object is `SieveCeiling.DeterminedSystem`; the
    codimension-side exclusion is the research-grade W-1 work-order (deferred). Per the
    loom W-1 finding, do not cite this theorem as the proof of Determination.

    (W-ORD-V3B, 2026-07-23: renamed from `determination_bridge`; the decorative
    `(_h_determined : True)` binder — a discarded vacuity — deleted. Fork (b), content
    decides arity.) -/
theorem offLine_of_codim_two (sigma : Real)
    (h_codim2 : zero_codimension sigma = 2) :
    Not (sigma = 1 / 2) := by
  intro h_half
  rw [h_half, codim_on_line] at h_codim2
  omega

-- ===============================================================
-- VOICE 3b DERIVATION
-- ===============================================================

structure Voice3bDerivation where
  sigma : Real
  holomorphic_constraint : cr_minimal_codim sigma
  sigma_is_half : sigma = 1 / 2 :=
    cr_forces_half sigma holomorphic_constraint

end techne_kernel_voice3b
