import Mathlib.Data.Int.Basic
import Mathlib.Data.Complex.Basic

/-!
# DistributiveDark: The distributive law is spectrally inert

The distributive law a(b+c) = ab+ac is an identity of ℤ.
The spectral parameter s ∈ ℂ does not appear in it.
Therefore the distributive law carries no s-dependent information.

The distributive law a(b+c) = ab+ac is an identity of Z in which no s appears; this file compiles it and its s-quantified restatements. Its use in Step (9) (per-class to all-combinations exclusion) is the manuscript's argument, not compiled here.

Mathematical content is original.
-/

namespace DistributiveDark

/-- Left distributivity: a(b+c) = ab + ac. -/
theorem left_distrib_int (a b c : ℤ) :
    a * (b + c) = a * b + a * c := mul_add a b c

/-- Right distributivity: (a+b)c = ac + bc. -/
theorem right_distrib_int (a b c : ℤ) :
    (a + b) * c = a * c + b * c := add_mul a b c

/-- The distributive law holds for all s : ℂ.
    The proof `mul_add a b c` does not reference s.
    This is what "s-dark" means formally. -/
theorem distributive_s_dark (a b c : ℤ) :
    ∀ _s : ℂ, a * (b + c) = a * b + a * c :=
  fun _ => mul_add a b c

/-- Conservation: the distributive law's truth value
    is constant across all values of s. -/
theorem distributive_conservation (a b c : ℤ) :
    ∀ (_s₁ _s₂ : ℂ), a * (b + c) = a * b + a * c :=
  fun _ _ => mul_add a b c

/-!
### Summary

The product formula: 1^s = 1        (s-dark, Lean-verified in ProductFormula chain)
The distributive law: a(b+c) = ab+ac (s-dark, this file)

Both couplings are s-dark. The product formula's compiled form 1^s = 1 and the distributive law contain no s. That per-class exclusion with these couplings gives global exclusion is the Conservation argument of Step (9), not compiled.
This is the Conservation argument of Step (9).
-/

end DistributiveDark
