import Mathlib.Tactic
import Mathlib.NumberTheory.Padics.PadicNorm

namespace OstrowskiClassify

theorem padic_norm_prime_lt_one (p : Nat) [hp : Fact (Nat.Prime p)] :
    padicNorm p (p : Rat) < 1 := by
  apply padicNorm.padicNorm_p_lt_one
  exact hp.out.one_lt

theorem kernel_prime (p : Nat) [hp : Fact (Nat.Prime p)] (a b : Rat)
    (ha : padicNorm p a <= 1) (hb : padicNorm p b <= 1)
    (hab : padicNorm p (a * b) < 1) :
    padicNorm p a < 1 \/ padicNorm p b < 1 := by
  rw [padicNorm.mul] at hab
  by_contra h
  push_neg at h
  have ha1 : padicNorm p a = 1 := le_antisymm ha h.1
  have hb1 : padicNorm p b = 1 := le_antisymm hb h.2
  rw [ha1, hb1] at hab
  simp at hab

end OstrowskiClassify
