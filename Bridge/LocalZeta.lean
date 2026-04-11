import Mathlib.NumberTheory.Ostrowski
import Kernel.Core

theorem neg_eq_neg_one_sub_iff {α : Type*} [Field α] [CharZero α] (s : α) :
    -s = -(1 - s) <-> s = 1 / 2 := by
  constructor
  · intro h
    have h1 : s = 1 - s := neg_inj.mp h
    field_simp
    linear_combination h1
  · intro h; rw [h]; ring

theorem formation_count : 2 + 3 + 2 + 0 = 7 := SIDEKernel.formation