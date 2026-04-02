import Mathlib.NumberTheory.Ostrowski

theorem neg_eq_neg_one_sub_iff (s : Real) :
    -s = -(1 - s) <-> s = 1 / 2 := by
  constructor
  · intro h; linarith
  · intro h; rw [h]; ring

theorem formation_count : 2 + 3 + 2 + 0 = 7 := by native_decide