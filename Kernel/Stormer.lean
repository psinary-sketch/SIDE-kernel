import Mathlib.Tactic

namespace Stormer

def divideOut (n p : Nat) : Nat :=
  if p <= 1 then n
  else if h2 : n = 0 then 0
  else if n % p = 0 then divideOut (n / p) p
  else n
termination_by n
decreasing_by
  apply Nat.div_lt_self
  exact Nat.pos_of_ne_zero h2
  exact Nat.lt_of_not_le (by assumption)

def smooth23 (n : Nat) : Bool :=
  if n == 0 then false
  else divideOut (divideOut n 2) 3 == 1

def consecSmooth (n : Nat) : Bool :=
  smooth23 n && smooth23 (n + 1)

theorem pair_1_2 : consecSmooth 1 = true := by native_decide
theorem pair_2_3 : consecSmooth 2 = true := by native_decide
theorem pair_3_4 : consecSmooth 3 = true := by native_decide
theorem pair_8_9 : consecSmooth 8 = true := by native_decide

theorem no_other_pairs :
    forall n, n < 20 -> consecSmooth n = true -> n = 1 \/ n = 2 \/ n = 3 \/ n = 8 := by
  native_decide

theorem max_smooth_in_pair :
    forall n, n < 20 -> consecSmooth n = true -> n + 1 <= 9 := by
  native_decide

end Stormer
