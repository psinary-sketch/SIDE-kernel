import Mathlib.NumberTheory.EulerProduct.DirichletLSeries
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Kernel.Voice1

/-!
# EulerBalance: Voice1 grounded in Mathlib's `riemannZeta`

Voice1 (`Kernel/Voice1.lean`) proves the real algebraic identity
  `p ^ (-σ) = p ^ (-(1 - σ))  ↔  σ = 1/2`
for any prime `p`, with both sides as `Real` powers (`Real.rpow`).

Mathlib's `riemannZeta_eulerProduct_tprod`
(`Mathlib/NumberTheory/EulerProduct/DirichletLSeries.lean`) states
  `∏' p : Nat.Primes, (1 - (p : ℂ) ^ (-s))⁻¹ = riemannZeta s`     (Re s > 1).

The local Euler factor at `p` is `F_p(s) = (1 - p ^ (-s))⁻¹`. We promote
Voice1's real balance to the modulus of the inner exponential `p ^ (-s)`
of each factor: via `‖(p : ℂ) ^ z‖ = p ^ (Re z)`, the symmetry
`‖p ^ (-s)‖ = ‖p ^ (-(1 - s))‖` reduces to a real exponent equation, which
Voice1 pins to `Re s = 1/2`. This is the precise sense in which Voice1
talks about the Euler factors of `riemannZeta`.
-/

namespace techne_kernel_voice1_euler

open Complex

/-- Modulus balance of the Euler-factor exponential.
For any prime `p` and any complex `s`,
  `‖(p : ℂ) ^ (-s)‖ = ‖(p : ℂ) ^ (-(1 - s))‖  ↔  Re s = 1/2`.

Proof: take complex norms, apply `‖(p : ℂ) ^ z‖ = (p : ℝ) ^ z.re`,
and apply Voice1's `balance_theorem` to `σ = s.re`. -/
theorem cpow_balance_iff_re_half
    (p : Nat) (hp : Nat.Prime p) (s : ℂ) :
    ‖(p : ℂ) ^ (-s)‖ = ‖(p : ℂ) ^ (-(1 - s))‖ ↔ s.re = 1/2 := by
  have hp_pos : 0 < p := hp.pos
  rw [norm_natCast_cpow_of_pos hp_pos, norm_natCast_cpow_of_pos hp_pos,
      neg_re, neg_re, sub_re, one_re]
  have h := techne_kernel_voice1.balance_theorem p hp s.re
  unfold techne_kernel_voice1.prime_as_real at h
  exact h

/-- The same statement quantified over `Nat.Primes`, the index type
used by Mathlib's `riemannZeta_eulerProduct_tprod`. -/
theorem euler_factor_inner_balance
    (p : Nat.Primes) (s : ℂ) :
    ‖(p : ℂ) ^ (-s)‖ = ‖(p : ℂ) ^ (-(1 - s))‖ ↔ s.re = 1/2 := by
  have hp_pos : 0 < (p.val : ℕ) := p.prop.pos
  have hcast : ((p : ℂ)) = ((p.val : ℕ) : ℂ) := by
    simp
  rw [hcast]
  exact cpow_balance_iff_re_half p.val p.prop s

/-- Witness: the factor `(1 - (p : ℂ) ^ (-s))⁻¹` whose inner balance
we pinned above is exactly the factor in Mathlib's Euler product for
`riemannZeta`. -/
example (s : ℂ) (hs : 1 < s.re) :
    ∏' p : Nat.Primes, (1 - (p : ℂ) ^ (-s))⁻¹ = riemannZeta s :=
  riemannZeta_eulerProduct_tprod hs

end techne_kernel_voice1_euler
