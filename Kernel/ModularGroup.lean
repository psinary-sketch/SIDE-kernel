import Mathlib.Tactic

namespace ModularGroup

-- S and T as plain integer matrices (avoiding Mathlib name collisions)
def genS : Matrix (Fin 2) (Fin 2) Int := !![0, -1; 1, 0]
def genT : Matrix (Fin 2) (Fin 2) Int := !![1, 1; 0, 1]

-- S^2 = -I in SL_2(Z)
theorem genS_sq : genS * genS = !![-1, 0; 0, -1] := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [genS, Matrix.mul_apply, Fin.sum_univ_two]

-- (ST)^3 = -I in SL_2(Z)
theorem genST_cubed : genS * genT * (genS * genT) * (genS * genT) = !![-1, 0; 0, -1] := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [genS, genT, Matrix.mul_apply, Fin.sum_univ_two]

-- In PSL_2(Z) = SL_2(Z)/{+-I}:
--   genS has order 2 (S^2 = -I, so S^2 = I in PSL)
--   genS*genT has order 3 ((ST)^3 = -I, so (ST)^3 = I in PSL)
-- Therefore PSL_2(Z) has generators of orders 2 and 3
-- The primes {2,3} ARE the modular group

end ModularGroup
