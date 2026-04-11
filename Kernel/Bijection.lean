import Mathlib.Tactic
import Kernel.Core

namespace Bijection

inductive MechClass where
  | C1 | C2 | C3 | C4 | C5 | C6 | C7
  deriving DecidableEq, Fintype

inductive IdElem where
  | I1 | I2 | I3 | I4 | I5 | I6 | I7
  deriving DecidableEq, Fintype

def bij : MechClass -> IdElem
  | .C1 => .I1 | .C2 => .I2 | .C3 => .I3
  | .C4 => .I4 | .C5 => .I5 | .C6 => .I6 | .C7 => .I7

theorem bij_injective : Function.Injective bij := by decide
theorem bij_surjective : Function.Surjective bij := by decide

theorem bij_bijective : Function.Bijective bij :=
  And.intro bij_injective bij_surjective

theorem mech_card : Fintype.card MechClass = 7 := by native_decide
theorem id_card : Fintype.card IdElem = 7 := by native_decide
theorem formation : 2 + 3 + 2 + 0 = 7 := SIDEKernel.formation

end Bijection
