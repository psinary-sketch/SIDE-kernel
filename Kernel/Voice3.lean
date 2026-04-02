import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

namespace techne_kernel_voice3

def reflect (s : Real) : Real := 1 - s

theorem reflect_involution (s : Real) : reflect (reflect s) = s := by
  unfold reflect; ring

theorem reflect_fixed_point_forward (s : Real) :
    reflect s = s -> s = 1 / 2 := by
  unfold reflect; intro h; linarith

theorem reflect_fixed_point_reverse :
    reflect (1 / 2 : Real) = 1 / 2 := by
  unfold reflect; ring

theorem reflect_fixed_iff (s : Real) :
    reflect s = s <-> s = 1 / 2 := by
  constructor
  . exact reflect_fixed_point_forward s
  . intro h; rw [h]; exact reflect_fixed_point_reverse

theorem voice3_rests_at_half : reflect (1 / 2 : Real) = 1 / 2 :=
  reflect_fixed_point_reverse

theorem voice3_unique_rest (s : Real) (h : s = 1 / 2 -> False) :
    reflect s = s -> False := by
  intro h_fix
  exact h (reflect_fixed_point_forward s h_fix)

structure Voice3Derivation where
  sigma : Real
  symmetry_holds : reflect sigma = sigma
  sigma_is_half : sigma = 1 / 2 :=
    reflect_fixed_point_forward sigma symmetry_holds

end techne_kernel_voice3
