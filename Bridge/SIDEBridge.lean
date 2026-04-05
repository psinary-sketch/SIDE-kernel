import Mathlib.NumberTheory.LSeries.RiemannZeta
import Kernel.Layer1
import Kernel.Voice1
import Kernel.Voice2
import Kernel.Voice3
import Kernel.AnalyticBridge
import Kernel.SpectralCannonFull4
import Kernel.PerpendicularCrossing

open Complex techne_kernel
open techne_kernel_voice1 techne_kernel_voice2 techne_kernel_voice3

namespace SIDEBridge

def OffLineOrNonSimple (s : ℂ) : Prop :=
  completedRiemannZeta₀ s = 0 ∧ 0 < s.re ∧ s.re < 1 ∧
  (s.re ≠ 1 / 2 ∨ deriv completedRiemannZeta₀ s = 0)

-- C₁: Balance. Voice1 proves p^{-σ} = p^{-(1-σ)} ↔ σ=1/2
-- produces := the zero is off-line (balance is violated)
def C1 : MechanismClass ℂ OffLineOrNonSimple :=
  { name := "Balance"
    produces := fun s => s.re ≠ 1 / 2 }

-- C₂: Conjugation. Voice2 proves symmetries agree iff σ=1/2
def C2 : MechanismClass ℂ OffLineOrNonSimple :=
  { name := "Conjugation"
    produces := fun s => s.re ≠ 1 / 2 }

-- Simplicity class: the zero has deriv = 0 (on the line)
def C_simple : MechanismClass ℂ OffLineOrNonSimple :=
  { name := "Simplicity"
    produces := fun s => s.re = 1 / 2 ∧ deriv completedRiemannZeta₀ s = 0 }

def voice_classes : List (MechanismClass ℂ OffLineOrNonSimple) := [C1, C2, C_simple]

def xi_catalogue : ExhaustiveCatalogue ℂ OffLineOrNonSimple :=
  { classes := voice_classes
    covers_all := by
      intro s hs
      obtain ⟨hz, hlo, hhi, h_bad⟩ := hs
      rcases h_bad with h_off | h_deriv
      -- Case 1: off-line zero. C1 produces it.
      · exact ⟨C1, List.Mem.head _, h_off⟩
      -- Case 2: deriv = 0 on the line. Need s.re = 1/2.
      · by_cases h12 : s.re = 1 / 2
        · exact ⟨C_simple, List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)),
            ⟨h12, h_deriv⟩⟩
        · exact ⟨C1, List.Mem.head _, h12⟩ }

/-! ## Named Hypotheses (ξ pattern) -/

/-- RH hypothesis: all critical-strip zeros are on the line. -/
def RHHypothesis : Prop :=
  ∀ (s : ℂ), completedRiemannZeta₀ s = 0 →
  0 < s.re → s.re < 1 → s.re = 1 / 2

/-- Simplicity hypothesis: zeros on the critical line are simple. -/
def SimplicityHypothesis : Prop :=
  ∀ (s : ℂ), completedRiemannZeta₀ s = 0 →
  s.re = 1 / 2 → deriv completedRiemannZeta₀ s ≠ 0

/-- NoneProduces for ξ, conditional on RH + Simplicity.
    Zero sorry. The three case splits close from the hypotheses. -/
theorem xi_none_produces
    (h_rh : RHHypothesis) (h_simp : SimplicityHypothesis)
    (s : ℂ)
    (hs : completedRiemannZeta₀ s = 0)
    (hlo : 0 < s.re) (hhi : s.re < 1) :
    NoneProduces ℂ OffLineOrNonSimple xi_catalogue.classes s := by
  intro C hC h_prod
  unfold xi_catalogue voice_classes at hC
  cases hC with
  | head =>
    -- C = C1, h_prod : s.re ≠ 1/2
    exact absurd (h_rh s hs hlo hhi) h_prod
  | tail _ hC => cases hC with
    | head =>
      -- C = C2, h_prod : s.re ≠ 1/2
      exact absurd (h_rh s hs hlo hhi) h_prod
    | tail _ hC => cases hC with
      | head =>
        -- C = C_simple, h_prod : s.re = 1/2 ∧ deriv = 0
        obtain ⟨h_on, h_deriv⟩ := h_prod
        exact absurd (h_simp s hs h_on) (not_not.mpr h_deriv)
      | tail _ hC => nomatch hC

/-- SIDE exclusion bridge, conditional on RH + Simplicity. Zero sorry. -/
theorem side_exclusion_bridge
    (h_rh : RHHypothesis) (h_simp : SimplicityHypothesis)
    (s : ℂ)
    (hs : completedRiemannZeta₀ s = 0)
    (hlo : 0 < s.re) (hhi : s.re < 1) :
    s.re = 1 / 2 ∧ deriv completedRiemannZeta₀ s ≠ 0 := by
  have h_not := SIDE_exclusion xi_catalogue (xi_none_produces h_rh h_simp s hs hlo hhi)
  simp only [OffLineOrNonSimple, not_and, not_or, not_not] at h_not
  exact h_not hs hlo hhi

end SIDEBridge
