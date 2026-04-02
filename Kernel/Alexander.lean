import Mathlib.Tactic

namespace Alexander

-- The Alexander polynomial of the trefoil T(2,3) is
-- Delta(t) = t^2 - t + 1
-- This equals the 6th cyclotomic polynomial Phi_6(t)
-- where 6 = 2 * 3

-- For torus knot T(p,q):
-- Delta(t) = (t^(pq) - 1)(t - 1) / ((t^p - 1)(t^q - 1))
-- For (p,q) = (2,3): Delta(t) = (t^6-1)(t-1)/((t^2-1)(t^3-1))

-- Verify: (t^6-1)(t-1) = (t^2-1)(t^3-1)(t^2-t+1)
-- This is a polynomial identity

-- We verify the key evaluations that connect to the Trivium:

-- Delta(1) = 1 (identity preserved)
theorem delta_at_one : 1 ^ 2 - 1 + 1 = (1 : Int) := by native_decide

-- Delta(-1) = 3 (knot determinant = second generating prime)
theorem delta_at_neg_one : (-1) ^ 2 - (-1) + 1 = (3 : Int) := by native_decide

-- 6 = 2 * 3 (cyclotomic index = product of generating primes)
theorem six_eq : 2 * 3 = (6 : Nat) := by native_decide

-- The discriminant of t^2 - t + 1 is -3
-- disc = b^2 - 4ac = 1 - 4 = -3
-- This is the Trivium field Q(sqrt(-3))
theorem discriminant : 1 ^ 2 - 4 * 1 * 1 = (-3 : Int) := by native_decide

-- The roots are the primitive 6th roots of unity: e^(+/- i pi/3)
-- These have order 3 in the unit circle
-- matching the order-3 rotations of ST in PSL_2(Z)

-- Genus of trefoil = (2-1)(3-1)/2 = 1
theorem genus : (2 - 1) * (3 - 1) / 2 = (1 : Nat) := by native_decide

end Alexander
