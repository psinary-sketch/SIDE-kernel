# SIDE-kernel v1.2 — deposit notes

Author-side deposit-preparation record for the v1.2 Zenodo release.
The tag `v1.2` sits on the verified commit `b1407b2`; this notes file
rides *after* it on `main`, so the SHA triple below points at the tagged
commit, not at this notes commit. Deposit itself remains author-gated
behind `DEPOSIT_VERIFICATION_PROTOCOL`; this file records the verification,
it does not perform the Zenodo upload.

Verification run: 2026-07-10 (resumed after a power-loss interruption of the
prior session; Mathlib sources restored at `e960b84`, mtimes normalised, tree
rebuilt green — 3593 jobs, exit 0).

## v1.2 tag — SHA triple

- **Verified commit (`git rev-list -n 1 v1.2`):** `b1407b2231c650d6d938cfa649f589fd388f669c`
- **Remote annotated-tag object (`git ls-remote origin refs/tags/v1.2`):** `82c3a1d48a76d9935d18f3804cdd0eff5f4df014`
- **Remote peeled commit (`git ls-remote origin refs/tags/v1.2^{}`):** `b1407b2231c650d6d938cfa649f589fd388f669c` — equals the verified commit ✓

The verified commit `b1407b2` is `f18e143` (CartanBBridge T3 set-aside enactment)
plus one non-mathematical commit that adds a junction-safety operational rule to
`AGENTS.md` (+6 lines only; no Lean source touched).

## native_decide census (R2)

`git grep "by native_decide" HEAD -- '*.lean'` → **0 matches**. The only textual
occurrence of `native_decide` anywhere in the tracked Lean tree is a prose comment
(`legacy/FmodifProbe.lean:34`, `-- Try native_decide or norm_num`) — non-executable.
Corpus-wide the tactic is eliminated.

## Axiom audit (R3) — verbatim `#print axioms` output

Run via `lake env lean AxiomAudit_v1_2.lean` (scratch module, not tracked) at the
tagged commit, after `lake build`. Every §25.8 Kernel Concordance terminal plus the
three formation certificates named in the verification protocol:

```
'structural_exhaustiveness_proved' depends on axioms: [propext, Classical.choice, Quot.sound]
'SpectralCannonFull.spectral_cannon' depends on axioms: [propext, Classical.choice, Quot.sound]
'ConservationBridge.riemann_hypothesis' depends on axioms: [propext, Classical.choice, Quot.sound]
'techne_kernel_integration.rh_from_structural_exhaustiveness' depends on axioms: [propext, Classical.choice, Quot.sound]
'techne_kernel_integration.structural_exhaustiveness_iff_rh' depends on axioms: [propext, Classical.choice, Quot.sound]
'SIDEKernel.formation' does not depend on any axioms
'SIDEKernel.formation_count' does not depend on any axioms
'DomainOstrowski.formation_count' does not depend on any axioms
```

Concordance with the monograph §25.8 table (`day1/A_Place_to_Stand.md`, v5.5):

| Terminal | Module | Expected profile | Observed | Verdict |
|---|---|---|---|---|
| `structural_exhaustiveness_proved` (Route 1) | `Bridge/TheBridgeComplete.lean` | `{propext, Classical.choice, Quot.sound}` | same | ✓ |
| `SpectralCannonFull.spectral_cannon` (Route 2) | `Kernel/SpectralCannonFull.lean` | `{propext, Classical.choice, Quot.sound}` | same | ✓ |
| `ConservationBridge.riemann_hypothesis` (Route 3) | `Bridge/ConservationBridge.lean` | `{propext, Classical.choice, Quot.sound}` | same | ✓ |
| `techne_kernel_integration.rh_from_structural_exhaustiveness` | `Kernel/Integration.lean` | `{propext, Classical.choice, Quot.sound}` | same | ✓ |
| `techne_kernel_integration.structural_exhaustiveness_iff_rh` | `Kernel/Integration.lean` | `{propext, Classical.choice, Quot.sound}` | same | ✓ |
| `SIDEKernel.formation` | `Kernel/Core.lean` | (none) — axiom-free | no axioms | ✓ |
| `SIDEKernel.formation_count` | `Kernel/Core.lean` | (none) — axiom-free | no axioms | ✓ |
| `DomainOstrowski.formation_count` | `MetaKernel.lean` | (none) — axiom-free | no axioms | ✓ |

Every route terminal is exactly the standard-three profile
`{propext, Classical.choice, Quot.sound}`; every formation certificate is axiom-free.
No `sorryAx`, no `Lean.ofReduceBool`, no `_native.native_decide.ax_*` anywhere.

**Delta from v1.1 (per PLACE-papers FINDINGS `F.2026-07-10-c`).** At the citable v1.1
deposit (`e0a8ba0`, DOI 10.5281/zenodo.19937590), Route 1 `structural_exhaustiveness_proved`
was DIRTY — it carried `seven_classes._native.native_decide.ax_1_1` transitively — and
`SIDEKernel.formation` / `SIDEKernel.formation_count` carried `_native.native_decide.ax_1_1`.
Routes 2 and 3 and `DomainOstrowski.formation_count` were already clean at v1.1. v1.2 brings
the three v1.1-dirty terminals to the standard-three / axiom-free profile.

## Zenodo description delta (ready for paste)

> **v1.2 (July 2026).** Eliminates `native_decide` corpus-wide across `Bridge/` and
> `Kernel/`, replacing each tactic site with `decide`; a full `git grep "by native_decide"`
> over the Lean sources now returns zero. Every route terminal — Route 1
> (`structural_exhaustiveness_proved`), Route 2 (`SpectralCannonFull.spectral_cannon`),
> Route 3 (`ConservationBridge.riemann_hypothesis`) — now reports exactly
> `{propext, Classical.choice, Quot.sound}` under `#print axioms`, and the formation
> certificates (`SIDEKernel.formation`, `SIDEKernel.formation_count`,
> `DomainOstrowski.formation_count`) are axiom-free. **Routes 2 and 3 were already at that
> standard-three profile at v1.1; v1.2 brings Route 1 and the formation certificates — which
> depended on `native_decide` at v1.1 — to the same standard.** **The `CartanBBridge` T3
> pillar (Cousin-I / Stein property of ℂ) is set aside as an open, in-source
> scope-acknowledgment per the loom ruling of 2026-06-15 (enacted at commit `f18e143`); the
> prior `cartan_B_consequence`, which proved a placeholder `Prop` by `trivial`, is retired —
> T1 (elliptic regularity for ∂̄) and T2 (Identity Theorem) are unchanged.** No mathematical
> changes to any theorem statement claimed proved at v1.1, other than the T3 retirement.

## Stale-tag remediation (recorded per tag discipline)

A stale `v1.2` tag was found on `origin` **and** locally, both peeling to commit
`5260498` (annotated-tag object `a51152e`) — pre-`native_decide`-elimination content
(`native_decide` still live in `Kernel/Core.lean`; Route-2 file still named
`SpectralCannonFull4.lean`). That tag had never been deposited to Zenodo or cited.
It was deleted from `origin` (`git push origin :refs/tags/v1.2`) and locally
(`git tag -d v1.2`), then re-cut fresh as an annotated tag on the verified commit
`b1407b2`. Post-remediation the old `5260498` / `a51152e` pair is gone from `origin`;
the peeled SHA now equals the verified commit above.

## Provenance

- CartanBBridge T3 set-aside: loom ruling 2026-06-15, kernel enactment at commit `f18e143`.
- Monograph scope match: PLACE-papers commit `a980f21` ("v5.5 scope correction: CartanBBridge T3 set aside").
- v1.1→v1.2 deposit-gap finding: PLACE-papers `FINDINGS.md` `F.2026-07-10-c`.
- This verification: PLACE-papers `FINDINGS.md` `F.2026-07-10-d` + relay `reports/2026-07-10-v1-2-verification.md`.

## Deposit itself

Deposit remains **author-side** behind `DEPOSIT_VERIFICATION_PROTOCOL`. This notes file
records the verification results and the Zenodo description delta; the Zenodo upload is
not performed by this run.
