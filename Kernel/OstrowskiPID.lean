import Mathlib.Tactic
import Mathlib.RingTheory.Int.Basic
import Mathlib.RingTheory.PrincipalIdealDomain

namespace OstrowskiPID

-- Z is a PID
theorem int_pid : IsPrincipalIdealRing Int := inferInstance

-- In a PID, every irreducible element generates a maximal ideal
-- Mathlib: Ideal.IsPrincipal.isMaximal or PrincipalIdealRing.isMaximal
-- Let's just verify the concrete cases we need:

-- 2 is prime in Z
theorem two_prime_int : Prime (2 : Int) := by decide
-- 3 is prime in Z
theorem three_prime_int : Prime (3 : Int) := by decide

-- For any prime p in Z, p.natAbs is a Nat.Prime
-- This connects integer primes to natural primes
-- which connects to padicNorm infrastructure

end OstrowskiPID
