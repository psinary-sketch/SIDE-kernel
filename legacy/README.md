# legacy/

Historical snapshots of kernel development. **Not part of the ship build.**

These files are retained to document the axiom-elimination journey
described in the companion monograph (*A Place to Stand*, Chapter 26):

- v1: 18 axioms, initial Balance + Layer1 framework
- v5: 2 axioms, seven Voices compiled
- v_schwarz: Schwarz reflection discharged
- v_product: Conservation compiled
- v61: PoissonExhaustion sorry filled
- v66: Final axiom discovered vacuously true, removed
- v66.1: +TypeLevel, +Simplicity, +Formation bridges

**Verification:** the active SIDE-kernel (`Kernel/`, `Bridge/`, `MetaKernel.lean`)
compiles with 0 sorry and 0 custom axioms. Files in this directory may
contain sorries and axioms from earlier development states; they are
**not** included in the default build (`lake build`) and their
correctness should not be assumed.

For the active kernel, see:
- `../Kernel/Root.lean` — active proof chain aggregator
- `../Bridge/TheBridgeComplete.lean` — seven mechanism classes, structural exhaustiveness
- `../MetaKernel.lean` — nine coupled-system κ instances

This directory is retained for reference and pedagogy, not for review.
