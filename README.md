# SIDE Kernel

Lean 4 formalization of the SIDE proof of the Riemann Hypothesis.

**J. York Seale** — https://orcid.org/0009-0008-7993-0310

## Quick start

```bash
git clone https://github.com/psinary-sketch/SIDE-kernel
cd SIDE-kernel
lake build Kernel.Root
```

Build time: ~5 minutes with cached Mathlib.
Expected output: 3580 jobs, 0 errors.

## Building

The kernel uses per-module builds. The default `lake build` target is not configured for the ship build; build specific modules instead:

```bash
lake build Kernel.Voice1
lake build Kernel.Kappa
lake build Kernel.SilenceTheorem
lake build Bridge.EulerBalance
lake build Bridge.CrossClassExclusion
lake build Bridge.TheBridgeComplete
lake build MetaKernel
```

Or build all ship modules in one invocation:

```bash
lake build Kernel.Voice1 Kernel.Kappa Kernel.SilenceTheorem Bridge.EulerBalance Bridge.CrossClassExclusion Bridge.TheBridgeComplete MetaKernel
```

To build the full active kernel (import manifest for every shipped module), use the `Kernel.Root` target:

```bash
lake build Kernel.Root
```

The `Kernel/archive/` directory contains historical probe files with `sorry` tactics in them; these are explicitly out of scope for the ship build and are not imported by any compiled module. Do not build targets under `Kernel/archive/`.

## What it proves

TheBridgeComplete.lean proves `StructuralExhaustiveness` unconditionally. Integration.lean derives `RiemannHypothesis` (Mathlib's definition). The full chain compiles end-to-end.

`produces_offline` is defined as a meaningful proposition for each of the seven mechanism classes — what it would mean for that class to produce a zero off the critical line — and then refuted by a named Voice theorem. No wildcard. No definitional `False`. Seven derivations from seven compiled Voice theorems.

## Numbers

- **360** theorems, lemmas, and definitions
- **0** `sorry` (unproved assertions)
- **0** custom axioms
- **68** compiled files (63 core + 5 bridge)

## Key files

Canonical reading order:

`Formation.lean` → `Voice1.lean` → `PoissonExhaustion.lean` → `Integration.lean`

Bridge files:

- `TheBridgeComplete.lean` — SE proved, 7 derived exclusions, Ostrowski from Mathlib
- `CSSThreshold.lean` — Steane [[7,1,3]] threshold verified by `native_decide`
- `OstrowskiBridge.lean` — Ostrowski exhaustive, formation n₂ = 3

## Structure

- `Kernel/` — Core formalization (63 files)
- `Bridge/` — Files compiling against Mathlib, grounding abstract types in Mathlib API
- `Kernel/archive/` — Development history (probe files, earlier iterations)

## Mathlib contributions

Two theorems from this programme have been merged into Mathlib:

- PR #36881: Logarithmic residue at simple zeros — **Merged**
- PR #36865: Analytic order at zeros with vanishing value — **Merged**

Two were submitted and closed:

- PR #36871: Nonvanishing in punctured neighborhoods — Closed
- PR #36324: Schwarz reflection for completed Riemann zeta — Closed

## Companion papers

The mathematical content — Conservation of Spectra, exhaustive enumeration, per-class exclusions — is developed in seven companion papers available at https://github.com/psinary-sketch/PLACE-papers.

## AI disclosure

*Computational workflow assisted by Claude (Anthropic). Mathematical content, proof strategies, and editorial decisions are the author's.*

## License

MIT
