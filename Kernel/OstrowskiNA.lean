import Mathlib.Tactic
import Mathlib.NumberTheory.Padics.PadicNorm
import Mathlib.RingTheory.Int.Basic

namespace OstrowskiNA

-- Z is a PID and UFD (from Mathlib)
theorem int_pid : IsPrincipalIdealRing Int := inferInstance
theorem int_ufd : UniqueFactorizationMonoid Int := inferInstance

-- p-adic norm is multiplicative (using Fact instance)
theorem padic_norm_mul (p : Nat) [hp : Fact (Nat.Prime p)] (a b : Rat) :
    padicNorm p (a * b) = padicNorm p a * padicNorm p b :=
  padicNorm.mul a b

-- p-adic norm is nonneg
theorem padic_norm_nonneg (p : Nat) [_hp : Fact (Nat.Prime p)] (a : Rat) :
    0 <= padicNorm p a :=
  padicNorm.nonneg a

-- p-adic norm of zero
theorem padic_norm_zero (p : Nat) [_hp : Fact (Nat.Prime p)] :
    padicNorm p 0 = 0 :=
  padicNorm.zero

-- p-adic norm of one
theorem padic_norm_one (p : Nat) [_hp : Fact (Nat.Prime p)] :
    padicNorm p 1 = 1 :=
  padicNorm.one

-- The structural facts for Ostrowski:
-- 1. Z is a PID (every ideal is principal)
-- 2. The p-adic norm is a non-archimedean absolute value
-- 3. The kernel {n : |n|_p < 1} = (p) is a prime ideal
-- 4. Every non-archimedean abs val on Q arises this way

-- For the formation count: places of Q = {inf} + {primes}
-- Archimedean: 1 (standard absolute value)
-- Non-archimedean: one per prime p
-- The product formula ties them all together

end OstrowskiNA
