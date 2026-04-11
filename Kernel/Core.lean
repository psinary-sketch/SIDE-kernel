import Mathlib.Data.Nat.Prime.Basic

/-
  KERNEL CORE — CANONICAL SHARED DECLARATIONS
  =============================================

  Single source of truth for declarations used across
  multiple kernel files. Import this instead of duplicating.

  Contents:
  • Place inductive (Ostrowski classification)
  • Stage counts n1–n4
  • formation_count theorem (2+3+2+0=7)
-/

namespace SIDEKernel

-- ============================================================
-- PLACES OF ℚ (Ostrowski classification)
-- ============================================================

/-- A place of ℚ: archimedean or p-adic for a prime p.
    Canonical definition used across the kernel. -/
inductive Place where
  | archimedean : Place
  | padic : (p : Nat) → Nat.Prime p → Place
  deriving DecidableEq

-- ============================================================
-- STAGE COUNTS
-- ============================================================

/-- n₁ = 2: primitive stage (additive + multiplicative groups of ℤ). -/
def n1 : Nat := 2

/-- n₂ = 3: transformation stage (functional eq + modular + spectral). -/
def n2 : Nat := 3

/-- n₃ = 2: output stage (local Cauchy-Riemann + global Hadamard). -/
def n3 : Nat := 2

/-- n₄ = 0: interface stage (all interfaces are s-dark). -/
def n4 : Nat := 0

-- ============================================================
-- FORMATION COUNT
-- ============================================================

/-- The formation count: 2 + 3 + 2 + 0 = 7 mechanism classes. -/
theorem formation_count : n1 + n2 + n3 + n4 = 7 := by native_decide

/-- The formation count as a bare arithmetic fact. -/
theorem formation : 2 + 3 + 2 + 0 = 7 := by native_decide

end SIDEKernel
