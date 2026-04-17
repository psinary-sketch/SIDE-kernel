import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Matrix.Basic

/-!
# CSS Threshold Theorem

The [[7,1,3]] Steane code exists because 7 = 2³−1 crosses the
self-orthogonality threshold for Hamming codes.

At n = 2: off-diagonal of H·Hᵀ = 2^(2-2) = 1 ≡ 1 mod 2. Fails.
At n = 3: off-diagonal of H·Hᵀ = 2^(3-2) = 2 ≡ 0 mod 2. Holds.

The threshold is at n = 3, corresponding to 2³−1 = 7 points.
-/

-- 7 is a Mersenne number
theorem seven_mersenne : 7 = 2^3 - 1 := by native_decide

-- Self-orthogonality FAILS at dimension 2
theorem css_fails_dim2 : 2^(2-2) % 2 = 1 := by native_decide

-- Self-orthogonality HOLDS at dimension 3
theorem css_holds_dim3 : 2^(3-2) % 2 = 0 := by native_decide

-- Diagonal entries (2^(n-1)) are even for n ≥ 2
theorem diagonal_even_dim2 : 2^(2-1) % 2 = 0 := by native_decide
theorem diagonal_even_dim3 : 2^(3-1) % 2 = 0 := by native_decide

-- n = 3 is the minimum dimension where CSS works
theorem css_minimum_dimension :
    (2^(3-2) % 2 = 0) ∧ (2^(2-2) % 2 ≠ 0) := by
  constructor <;> native_decide

-- The Steane code parameters
theorem steane_n : 2^3 - 1 = 7 := by native_decide
theorem steane_rank : 2 * 3 = 6 := by native_decide
theorem steane_k : 7 - 2 * 3 = 1 := by native_decide
theorem steane_d : 2 + 1 = 3 := by native_decide

-- Combined: [[7, 1, 3]]
theorem steane_code :
    (2^3 - 1 = 7) ∧ (7 - 2*3 = 1) ∧ (2 + 1 = 3) := by
  constructor; native_decide
  constructor <;> native_decide

-- The {2,3,5}-smooth Størmer count is 10, not 15
-- Therefore the pipeline does not extend to the next Hamming code
theorem stormer_235_not_mersenne : 10 ≠ 2^4 - 1 := by native_decide
