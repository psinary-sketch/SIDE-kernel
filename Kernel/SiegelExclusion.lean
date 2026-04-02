import Mathlib.Tactic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace SiegelExclusion

theorem pi_pos : (0 : Real) < Real.pi := Real.pi_pos
theorem pi_div_four_pos : (0 : Real) < Real.pi / 4 := by positivity
theorem conductor_from_prime : 2 ^ 2 = (4 : Nat) := by native_decide
theorem totient_four : Nat.totient 4 = 2 := by native_decide

end SiegelExclusion
