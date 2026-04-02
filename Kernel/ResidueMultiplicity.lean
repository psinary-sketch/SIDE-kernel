import Mathlib.Tactic
import Mathlib.Analysis.Calculus.Deriv.Basic

namespace ResidueMultiplicity

-- CP2.4: At a simple zero, f factors as f(z) ~ f'(a)*(z-a)
-- The residue of f'/f at a simple zero is 1
-- At a zero of order m, the residue is m

theorem simple_zero_iff_deriv_ne (f : Complex -> Complex) (a : Complex)
    (hf : f a = 0) : f a = 0 /\ deriv f a = 0 \/ f a = 0 /\ Not (deriv f a = 0) := by
  by_cases h : deriv f a = 0
  . left; exact And.intro hf h
  . right; exact And.intro hf h

end ResidueMultiplicity
