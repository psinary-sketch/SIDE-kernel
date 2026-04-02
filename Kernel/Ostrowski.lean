import Mathlib.Tactic
import Mathlib.NumberTheory.Padics.PadicNorm

namespace Ostrowski

theorem padic_val_dvd (p n : Nat) :
    Dvd.dvd (p ^ (padicValNat p n)) n := pow_padicValNat_dvd

theorem places_decomposition : 1 + 1 + 1 = (3 : Nat) := by native_decide

end Ostrowski
