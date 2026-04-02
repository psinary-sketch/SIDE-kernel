import Mathlib.Tactic

namespace Frobenius

def frobeniusNumber (a b : Nat) : Int := a * b - a - b

theorem frobenius_two_three : frobeniusNumber 2 3 = 1 := by native_decide

theorem frobenius_two_five : frobeniusNumber 2 5 = 3 := by native_decide

theorem frobenius_three_four : frobeniusNumber 3 4 = 5 := by native_decide

theorem frobenius_two (b : Nat) :
    frobeniusNumber 2 b = (b : Int) - 2 := by
  unfold frobeniusNumber; omega

theorem frobenius_large (a b : Nat) (ha : a >= 3) (hb : b >= a + 1) :
    frobeniusNumber a b >= 5 := by
  unfold frobeniusNumber; nlinarith

theorem unique_gapfree (a b : Nat) (ha : a >= 2) (hb : b >= a + 1)
    (hfrob : frobeniusNumber a b = 1) : a = 2 /\ b = 3 := by
  unfold frobeniusNumber at hfrob
  have hab : ((a : Int) - 1) * ((b : Int) - 1) = 2 := by linarith
  have ha1 : (a : Int) - 1 >= 1 := by omega
  have hb1 : (b : Int) - 1 >= 2 := by omega
  have : (a : Int) - 1 = 1 := by nlinarith
  have : (b : Int) - 1 = 2 := by nlinarith
  constructor <;> omega

end Frobenius
