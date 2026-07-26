import Mathlib.Data.Complex.Basic

/-!
# The derivative-level exclusion catalogue (Program Four (ii), Phase 2)

The SIDE catalogue applied one level down: excluding the codimension-2 coincidence
`ξ(ρ) = ξ′(ρ) = 0` (a double zero), per mechanism class. **Honest frame:** this strengthens the
simplicity route by compiling it, and it meets the same totality clause one level down — the
per-class→joint step at ξ′ needs its own h2-analogue. A parallel frontier and a genuine
strengthening, **not a bypass**.

**Wire, don't duplicate.** C₁'s derivative content is the Perpendicular-Crossing Theorem
`(deriv completedRiemannZeta₀ ⟨1/2,t⟩).re = 0` — already compiled as `SpectralCannonFull.spectral_cannon`
(SIDE-kernel `Kernel/SpectralCannonFull.lean`, pin `691295b`, `{propext, Classical.choice, Quot.sound}`).
It is **cross-referenced at its pin, not re-proven**; the reduction below is stated abstractly over ℂ
and consumes exactly its conclusion (`z.re = 0`).

**The replication finding (Phase 1).** The conjunction-shaped difficulty replicates here: per-class
compiled (C₁) + an open joint step; the **derivative h2 = uniform transversality `Im ξ′(ρ) ≠ 0` = the
simplicity conjecture**; the T3′/T3″ shared-witness / countermodel structure recurs at the joint step.
This is the E-Difficulty theory's **second instance**, on the same system one level down — same
*structure*, different *content*: level 0's clause is arithmetic (the Euler sign clause
`λ_Z ≥ −λ_A`), the derivative clause is **geometric** (transversality). The numerical design-check
confirms the distinction: Davenport–Heilbronn (no Euler product) still has **simple** off-line zeros
(doubly-sourced), so derivative-simplicity is not Euler-specific.

Salt-check discipline: the graded catalogue records the **honest per-class grade**, never encodes
"no class produces a double zero" as a definition; the one genuine derivation (C₁'s reduction)
consumes the perpendicular-crossing structure; the joint step is a **named premise**, never encoded.
-/

namespace SIDEDerivative

/-- The seven mechanism classes, for the derivative-level catalogue. -/
inductive DerivClass | c1 | c2 | c3 | c4 | c5 | c6 | c7
deriving DecidableEq, Repr

/-- The three-grade vocabulary. -/
inductive Grade | derives | interfaces | notCompiled
deriving DecidableEq, Repr

/-- The **honest** per-class grade of the derivative-level exclusion of `ξ(ρ)=ξ′(ρ)=0`, graded at the
Phase-2 read. NOT "all excluded" (that would encode); each grade is a claim about what is compiled.
* C₁ **DERIVES** — perpendicular crossing (`spectral_cannon`, wired @ pin).
* C₃ **NOT-COMPILED** — `|ξ′|>0` uniform = the simplicity bound, computed (30 zeros) not proved.
* C₂ **INTERFACES** — the Euler-analogue; carries the derivative-h2 named premise.
* C₄–C₇ **INTERFACES** — the Part-III per-class arguments concern zero *location*, not
  derivative-degeneracy; "constrain without degenerating" (§22.5) is an inherited claim whose
  derivative exclusion is **not independently compiled** at ξ′. -/
def derivGrade : DerivClass → Grade
  | .c1 => .derives
  | .c3 => .notCompiled
  | .c2 => .interfaces
  | .c4 => .interfaces
  | .c5 => .interfaces
  | .c6 => .interfaces
  | .c7 => .interfaces

/-- **Only C₁ genuinely DERIVES at the derivative level** — the honest count, compiled from the grade
map (not stipulated as a verdict on the others). -/
theorem exactly_c1_derives :
    (List.filter (fun c => decide (derivGrade c = Grade.derives))
      [DerivClass.c1, .c2, .c3, .c4, .c5, .c6, .c7]).length = 1 := by decide

/-- **C₁ derivative reduction (wired from `spectral_cannon`).** On the critical line the crossing gives
`Re ξ′(ρ) = 0`; so a double zero (`ξ′(ρ) = 0`) reduces to `Im ξ′(ρ) = 0`. Abstract over ℂ, consuming
`z.re = 0`; the concrete hypothesis is `spectral_cannon` (@ pin, cited). -/
theorem onLine_doubleZero_iff_imDeriv_zero {z : ℂ} (hRe : z.re = 0) :
    z = 0 ↔ z.im = 0 := by
  constructor
  · intro h; rw [h]; rfl
  · intro him; exact Complex.ext hRe him

/-- **The joint step — the derivative h2 as a NAMED PREMISE (never encoded).** Under the crossing
(`z.re = 0`, wired from `spectral_cannon`), being **not a double zero** is *equivalent* to
**transversality** (`z.im ≠ 0`): the crossing collapses the two-real-condition simplicity to the
single condition `z.im ≠ 0`. `hRe` is load-bearing here — it is consumed in the reduction's `.mpr`
direction (that `z.im = 0` *suffices* for a double zero on the line). Uniform transversality — this
equivalence holding at every critical-line zero — **is** the simplicity conjecture: the derivative
h2, carried openly as INTERFACES, not proved here. -/
theorem no_onLine_double_iff_transversal {z : ℂ} (hRe : z.re = 0) : z ≠ 0 ↔ z.im ≠ 0 :=
  not_congr (onLine_doubleZero_iff_imDeriv_zero hRe)

end SIDEDerivative
