\# SIDE Kernel



Lean 4 formalization of the SIDE proof of the Riemann Hypothesis.



\## What this proves



The kernel proves: \*\*if the mechanism catalogue is structurally exhaustive

for ξ(s), then the Riemann Hypothesis holds.\*\*



This is the conditional `rh\_from\_structural\_exhaustiveness` in

`Kernel/Integration.lean`.



The bridge files prove `StructuralExhaustiveness` unconditionally by

composing Ostrowski's theorem (from Mathlib), seven mechanism classes

(`native\_decide`), and per-class exclusion.



\## Numbers



\- \*\*360\*\* theorems, lemmas, and definitions

\- \*\*0\*\* `sorry` (unproved assertions)

\- \*\*0\*\* custom axioms

\- \*\*118\*\* files (63 core + 8 bridge + archive + config)



\## Build

```

lake build Kernel.Root

```



Requires Lean 4 and Mathlib. See `lean-toolchain` for the exact version.



\## Structure



\- `Kernel/` — Core formalization (self-contained, no Mathlib dependency)

\- `Bridge/` — Files that compile against Mathlib, grounding abstract types

\- `Kernel/archive/` — Development history (probe files, earlier iterations)



\## Mathlib contributions



Two theorems from this programme have been merged into Mathlib:

\- PR #36881: Logarithmic residue at simple zeros

\- PR #36865: Analytic order at zeros with vanishing value



Two are in review:

\- PR #36871: Nonvanishing in punctured neighborhoods

\- PR #36324: Schwarz reflection for completed Riemann zeta



\## Companion papers



The mathematical content — Conservation of Spectra, exhaustive enumeration,

per-class exclusions — is developed in seven companion papers.

\[Links to be added upon arXiv submission.]



\## AI disclosure



Lean code in this repository was developed with assistance from Claude

(Anthropic). Mathematical ideas, proof strategies, theorem statements,

and editorial decisions are the author's. All code compiles locally

without modification. This disclosure was also made on the Lean Zulip

community forum.



\## License



MIT

