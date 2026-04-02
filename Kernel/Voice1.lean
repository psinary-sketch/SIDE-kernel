import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Data.Nat.Prime.Basic

namespace techne_kernel_voice1

open Real

def prime_as_real (p : Nat) (_ : Nat.Prime p) : Real := (p : Real)

lemma prime_gt_one {p : Nat} (hp : Nat.Prime p) : (1 : Real) < prime_as_real p hp := by
  unfold prime_as_real
  exact_mod_cast Nat.Prime.one_lt hp

lemma rpow_injective {p : Real} (hp : 1 < p) :
    Function.Injective (fun x : Real => p ^ x) := by
  intro x y hxy
  rcases lt_trichotomy x y with hlt | heq | hgt
  . exact absurd hxy (ne_of_lt ((rpow_lt_rpow_left_iff hp).mpr hlt))
  . exact heq
  . exact absurd hxy (ne_of_gt ((rpow_lt_rpow_left_iff hp).mpr hgt))

theorem balance_theorem (p : Nat) (hp : Nat.Prime p) (s : Real) :
    (prime_as_real p hp) ^ (-s) = (prime_as_real p hp) ^ (-(1 - s))
    <-> s = 1 / 2 := by
  constructor
  . intro h_eq
    have hp_gt_one := prime_gt_one hp
    have inj := rpow_injective hp_gt_one
    have h_exp_eq : -s = -(1 - s) := inj h_eq
    linarith
  . intro h_sigma
    rw [h_sigma]
    ring_nf

theorem balance_at_half (p : Nat) (hp : Nat.Prime p) :
    (prime_as_real p hp) ^ (-(1/2 : Real)) = (prime_as_real p hp) ^ (-(1 - 1/2 : Real)) := by
  exact (balance_theorem p hp (1/2)).mpr rfl

theorem voice_1_uniqueness (p : Nat) (hp : Nat.Prime p) (s : Real) :
    Not (s = 1 / 2) ->
    Not ((prime_as_real p hp) ^ (-s) = (prime_as_real p hp) ^ (-(1 - s))) := by
  intro h_ne h_eq
  exact h_ne ((balance_theorem p hp s).mp h_eq)

structure Voice1Derivation where
  prime : Nat
  prime_prop : Nat.Prime prime
  sigma : Real
  balance_eq : (prime_as_real prime prime_prop) ^ (-sigma) =
               (prime_as_real prime prime_prop) ^ (-(1 - sigma))
  sigma_is_half : sigma = 1 / 2 :=
    (balance_theorem prime prime_prop sigma).mp balance_eq

end techne_kernel_voice1