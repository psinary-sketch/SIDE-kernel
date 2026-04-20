# SIDE-kernel — Phase 1.5 Roadmap

Internal planning document. The kernel currently formalizes three
independent routes to σ = 1/2 (see monograph §25.5). Phase 1.5
work extends the formalization, route by route, with each task
kernel-internal.

## Task 1 — Conservation of Spectra in Lean

Replace `ConservationHypothesis` in `Bridge/ConservationBridge.lean`
with a proved theorem against Mathlib's `riemannZeta`.

**Mathematical content:** Chapter 13 of the monograph "A Place
to Stand" — Conservation of Spectra, proved within ZFC from
Tate's thesis. The product formula ∏_v |x|_v = 1 is spectrally
inert: 1^s = 1 contributes no s-dependent information. Therefore
every ξ-zero forces the Euler balance equation at some prime.

**Lean target:** A theorem of the form

```
theorem conservation_of_spectra : ConservationHypothesis
```

using Mathlib's `riemannZeta`, `riemannZeta_eulerProduct_tprod`,
and adelic infrastructure. Kernel-internal — no Mathlib PR
required, no upstream contribution.

**Effect:** Route 3 closes from `ConservationBridge.riemann_hypothesis`
through to `RiemannHypothesis` without an external hypothesis.

## Task 2 — Spectral Cannon extension

Extend `Kernel/Cascade/Simplicity.lean` to formalize the full
simplicity reduction: `(∀ ρ, simple zero) → RiemannHypothesis`.

**Mathematical content:** Chapter 22 of the monograph plus the
companion paper THE_CASE_FOR_SIMPLICITY. The R-curve monotonicity
formula plus the perpendicular crossing theorem plus the Mechanism
Theorem at the derivative level.

**Lean targets:**
- `Kernel/Cascade/Simplicity.lean` already has the structural
  skeleton; the three remaining `sorry` tactics close as the
  chain matures
- `Kernel/Cascade/Tier1.lean` Phragmén-Lindelöf-dependent step
  either resolves through Mathlib's growing complex-analysis
  library or stays as the documented infrastructure boundary

**Effect:** Route 2 extends from the local theorems (pure
imaginary derivative, Cauchy-Riemann transversality, perpendicular
crossing) to the global RH conclusion via simplicity.

## Task 3 — R-curve formalization

First Lean formalization of the R-curve monotonicity chain
(Routes 4 in the monograph's prose-only catalogue).

**Mathematical content:** Companion paper P22_RCURVE_MONOTONICITY_REVISED.
Five theorems: Monotonicity Formula (V′ = |ξ′|²/β), Beta-V Identity,
Equivalence Chain (Lagarias 1999), Gamma Growth (Stirling),
Rotation Bound. Reduces RH to "no R-curve folds."

**Lean targets:**
- New file `Kernel/Cascade/RCurve.lean` (or similar location)
  defining R-curves as level sets {Re(ξ) = 0} through critical-line
  zeros, with the monotonicity formula
- The Lagarias equivalence as a compiled chain
- The Gamma growth bound from Mathlib's Stirling infrastructure

**Effect:** A fourth compiled route in the kernel, independent
of Routes 1–3, with its own machinery (R-curve geometry rather
than mechanism enumeration, perpendicular crossing, or Conservation).

## Notes

All three tasks live within the kernel's own namespace. None
requires Mathlib upstream contribution. Each compiles or fails
on its own merits without affecting the existing three routes,
which remain at zero `sorry`, zero axioms.

The kernel grows route by route. Convergence at σ = 1/2 strengthens
with each route. The mathematical content of each route exists
in the manuscripts; the Lean formalization is engineering.

---

Last updated: 2026-04-20
