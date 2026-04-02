import Mathlib.Tactic
import Mathlib.Data.Nat.Prime.Basic

namespace QIndependence

theorem prime_pow_eq_one (p : Nat) (hp : Nat.Prime p) (k : Nat) (h : p ^ k = 1) :
    k = 0 := by
  rcases k with _ | k
  . rfl
  . exfalso
    have h1 : p ^ (k + 1) >= p := Nat.le_of_dvd (by omega) (dvd_pow_self p (by omega))
    have h2 : p >= 2 := hp.two_le
    omega

theorem distinct_prime_pow (p q : Nat) (hp : Nat.Prime p) (hq : Nat.Prime q)
    (hne : Ne p q) (a b : Nat) (h : p ^ a = q ^ b) :
    a = 0 := by
  rcases a with _ | a
  . rfl
  . exfalso
    have hdvd : Dvd.dvd p (q ^ b) := by rw [<- h]; exact dvd_pow_self p (by omega)
    have h1 : Dvd.dvd p q := hp.dvd_of_dvd_pow hdvd
    have h2 : p = q := by
      rcases hq.eq_one_or_self_of_dvd p h1 with h3 | h3
      . exfalso; exact Nat.Prime.one_lt hp |>.ne' h3
      . exact h3
    exact hne h2

end QIndependence
