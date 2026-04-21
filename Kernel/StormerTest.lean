import Mathlib.Tactic

namespace Stormer

/-- Remove all factors of p from n -/
def divideOut (n p : Nat) : Nat :=
  if h1 : p ≤ 1 then n
  else if h2 : n = 0 then 0
  else if n % p = 0 then divideOut (n / p) p
  else n
termination_by n
decreasing_by
  apply Nat.div_lt_self
  · exact Nat.pos_of_ne_zero h2
  · exact Nat.lt_of_not_le h1

/-- n is {2,3}-smooth -/
def smooth23 (n : Nat) : Bool :=
  if n == 0 then false
  else divideOut (divideOut n 2) 3 == 1

/-- Both n and n+1 are {2,3}-smooth -/
def consecSmooth (n : Nat) : Bool :=
  smooth23 n && smooth23 (n + 1)

-- Find all consecutive smooth pairs up to 10000
#eval (List.range 10000).filter consecSmooth
-- Expected: [1, 2, 3, 8]

end Stormer
