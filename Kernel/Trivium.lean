import Mathlib.Tactic
import Mathlib.Analysis.SpecialFunctions.Complex.Circle

open Complex

namespace Trivium

theorem norm_squared : 3 + 2 + 1 + 0 + 1 + 2 + 3 = (12 : Nat) := by native_decide

theorem component_count : 7 = (7 : Nat) := rfl

theorem aperture_denominator : 7 - 1 = (6 : Nat) := by native_decide

theorem bright_eigenvalue : 3 + 2 + 1 + 0 + 1 + 2 + 3 = (12 : Nat) := norm_squared

theorem dark_multiplicity : 7 - 1 = (6 : Nat) := aperture_denominator

theorem quarter_twist_sq : I ^ 2 = (-1 : Complex) := by rw [sq]; exact I_mul_I

theorem quarter_twist_fourth : I ^ 4 = (1 : Complex) := by
  have h : I ^ 4 = (I ^ 2) ^ 2 := by ring
  rw [h, quarter_twist_sq]; norm_num

theorem is_720_return : I ^ 4 = (1 : Complex) := quarter_twist_fourth

end Trivium