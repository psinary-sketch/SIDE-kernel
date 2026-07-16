import Mathlib.NumberTheory.LSeries.RiemannZeta
import Kernel.XiDef
import Kernel.PoissonExhaustion
import Kernel.Integration
open Complex techne_kernel_xidef techne_kernel_voice1 PoissonExhaustion techne_kernel_integration

namespace ConservationBridge

/-- The Conservation hypothesis (existential form): every ξ-zero forces the
    Euler balance equation at SOME prime.  This is the programme's one counted
    premise (monograph §27.3), stated at the multiplicative place — NOT the
    discharged Chapter 13 theorem (the s-darkness of the product formula is the
    unconditional *certificate* that motivates it, a distinct proposition).
    Named hypothesis (ξ pattern), not sorry.

    W-7 enactment (2026-07-16): the definition was weakened from the universal
    form (`∀ p`, balance at EVERY prime) to this existential form (`∃ p`, at
    SOME prime), aligning the compiled def with the prose the monograph has
    always named (§25.5: "at some prime") and with
    `PoissonExhaustion.BalanceContradiction`.  Truth-plausibility screen: the
    existential is strictly WEAKER than the universal, so `riemann_hypothesis`
    below becomes a strictly STRONGER theorem (weaker hypothesis, same
    conclusion); every consumer that could supply the universal can supply the
    existential.  The conclusion is unchanged; only the hypothesis moved, in
    the direction that strengthens the result. -/
def ConservationHypothesis : Prop :=
  ∀ (σ : ℝ), is_xi_zero σ →
  ∃ (p : Nat) (hp : Nat.Prime p),
  (prime_as_real p hp) ^ (-σ) = (prime_as_real p hp) ^ (-(1 - σ))

/-- Conservation of Spectra: at any nontrivial zero of ζ,
    the Euler product structure is active at some prime. Conditional on
    ConservationHypothesis (ξ pattern, existential form). Zero sorry. -/
theorem conservation_activates_balance
    (h_cons : ConservationHypothesis) (σ : ℝ) (h : is_xi_zero σ) :
    ∃ (p : Nat) (hp : Nat.Prime p),
    (prime_as_real p hp) ^ (-σ) = (prime_as_real p hp) ^ (-(1 - σ)) :=
  h_cons σ h

/-- The structural exhaustiveness follows from Conservation + Voice1.
    Conditional on ConservationHypothesis. Zero sorry.

    The balance at a SINGLE prime already forces σ = 1/2: `balance_theorem` is
    prime-generic, so the existential witness `⟨p, hp, hbal⟩` discharges the
    goal exactly as the former `p = 2` instance did. -/
theorem structural_exhaustiveness_proved
    (h_cons : ConservationHypothesis) : StructuralExhaustiveness := by
  intro σ h_zero
  obtain ⟨p, hp, hbal⟩ := conservation_activates_balance h_cons σ h_zero
  exact (balance_theorem p hp σ).mp hbal

/-- The Riemann Hypothesis, conditional on Conservation. Zero sorry. -/
theorem riemann_hypothesis
    (h_cons : ConservationHypothesis) : RiemannHypothesis :=
  rh_from_structural_exhaustiveness (structural_exhaustiveness_proved h_cons)

end ConservationBridge
