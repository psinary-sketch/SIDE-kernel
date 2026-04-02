import Mathlib.Tactic
import Mathlib.Analysis.Calculus.Deriv.Basic

open Filter Topology

namespace DoubleZero

theorem energy_pos_at_simple_zero (f : Real -> Real) (x0 f' : Real)
    (hfx : f x0 = 0) (hf' : f' > 0) :
    f x0 ^ 2 + f' ^ 2 > 0 := by
  rw [hfx]; simp; positivity

theorem energy_zero_at_double_zero (f : Real -> Real) (x0 : Real)
    (hfx : f x0 = 0) :
    f x0 ^ 2 + (0 : Real) ^ 2 = 0 := by
  rw [hfx]; ring

end DoubleZero
