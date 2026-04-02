import Mathlib.Tactic
import Kernel.Layer1
import Kernel.Bijection

namespace MechanismTheorem

structure DeterminedSystem (X : Type) where
  spec : X -> Prop
  complete : forall (P : X -> Prop), (forall x, spec x -> P x) -> forall x, P x

structure Mechanism (X : Type) (spec : X -> Prop) (P : X -> Prop) where
  derives : forall x, spec x -> P x

theorem mechanism_exclusion
    (classes : Fin 7 -> Prop)
    (none_produces : forall i, classes i -> False) :
    forall i, classes i -> False :=
  none_produces

end MechanismTheorem
