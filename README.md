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

Requires Lean 4 with Mathlib. Toolchain is pinned in `lean-toolchain`
(currently `leanprover/lean4:v4.29.0-rc8`).

### Quick build (recommended)

First-time build uses Mathlib's pre-built olean cache to skip the
~2-hour cold compilation of Mathlib itself:

```bash
lake exe cache get    # downloads pre-built Mathlib oleans (~1.3 GB)
lake build            # builds the active kernel (Kernel/, Bridge/, MetaKernel)
```

Subsequent builds are incremental and fast.

### Full cold build (no cache)

If `lake exe cache get` is unavailable or you prefer to build Mathlib
from source, plain `lake build` will do so — expect approximately two
hours on first build. Subsequent builds are fast.

### Per-module builds

For targeted verification of individual ship modules:

```bash
lake build Kernel.Root                 # full active kernel chain
lake build Bridge.TheBridgeComplete    # seven mechanism classes, structural exhaustiveness
lake build MetaKernel                  # nine coupled-system κ instances
```

The `legacy/` directory contains historical probe files from earlier kernel development states (v1 through v66.1), retained as a record of the axiom-elimination journey described in the monograph (Chapter 26). These files may contain `sorry` tactics and are not part of the ship build. See `legacy/README.md` for details.

## What it proves

Running `lake build` verifies the Riemann Hypothesis theorem end-to-end against Mathlib, with zero `sorry` and zero custom axioms.

**Three load-bearing theorems:**

- `RiemannHypothesis` in `Kernel/Integration.lean` — every nontrivial zero of the Riemann zeta function has real part 1/2 (Mathlib's definition). The headline theorem. Derived from `StructuralExhaustiveness` via the SIDE Exclusion Principle.
- `structural_exhaustiveness_proved` in `Bridge/TheBridgeComplete.lean` — the seven mechanism classes are exhaustive, and cross-class exclusion shows no class produces the algebraic signature of an off-line zero. Proved unconditionally.
- `silence_universal` in `Kernel/SilenceTheorem.lean` — the Universal Silence Theorem: the product formula is spectrally silent, proved from Tate's thesis.

`produces_offline` is defined as a meaningful proposition for each of the seven mechanism classes — what it would mean for that class to produce a zero off the critical line — and then refuted by a named Voice theorem. No wildcard. No definitional `False`. Seven derivations from seven compiled Voice theorems.

**Three independent routes reach the conclusion:**

1. Seven mechanism classes (`Bridge/TheBridgeComplete`) with cross-class exclusion forbidding off-line zeros.
2. Codimension / Spectral Cannon (`Kernel/SchwarzDischarge` + `Kernel/Voice3b` + `Kernel/PerpendicularCrossing`) via perpendicular crossing of ξ'(1/2+it) = 0 combined with Schwarz reflection.
3. Conservation of Spectra via Tate's thesis, closing from spectral silence of the product formula to the Riemann Hypothesis.

Verify zero sorry and zero custom axioms in the active kernel:

```bash
grep -rn "^\s*sorry\b" Kernel/ Bridge/ MetaKernel.lean --include="*.lean"   # expect: no matches
grep -rn "^axiom " Kernel/ Bridge/ MetaKernel.lean --include="*.lean"       # expect: no matches
```

## Numbers

- **560** theorems, lemmas, and definitions in the sorry-free core
- **0** `sorry` (unproved assertions)
- **0** custom axioms
- **82** active Lean files — Kernel/ (69), Bridge/ (12), MetaKernel.lean (1)
- Per-component declaration count: Kernel/ 409, Bridge/ 97, MetaKernel.lean 54
- **612** total broad declarations (includes instances, structures, classes, inductives, abbrevs, examples)

## Key files

Canonical reading order:

`Formation.lean` → `Voice1.lean` → `PoissonExhaustion.lean` → `Integration.lean`

Bridge files:

- `TheBridgeComplete.lean` — SE proved, 7 derived exclusions, Ostrowski from Mathlib
- `CSSThreshold.lean` — Steane [[7,1,3]] threshold verified by `native_decide`
- `OstrowskiBridge.lean` — Ostrowski exhaustive, formation n₂ = 3

## Structure

- `Kernel/` — Core formalization (69 files)
- `Bridge/` — Files compiling against Mathlib, grounding abstract types in Mathlib API
- `legacy/` — Historical snapshots (probe files from v1 through v66.1, not part of ship build)

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
