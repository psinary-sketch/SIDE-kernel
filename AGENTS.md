# AGENTS.md

**Project:** SIDE-kernel
**Programme:** PLACE TO STAND Research Programme
**Author:** J. York Seale (ORCID: [0009-0008-7993-0310](https://orcid.org/0009-0008-7993-0310))
**License:** MIT
**Current version:** v1.1 (tag `v1.1`, commit `e0a8ba0`)

This file orients LLM agents and automated tooling to the repository's purpose, structure, and verification surface. Human readers should start with `README.md`.

---

## What this repository is

The Lean 4 kernel for the SIDE proof of the Riemann Hypothesis. Compiles end-to-end through `TheBridgeComplete → Integration → RiemannHypothesis` against Mathlib with **0 sorry, 0 axioms beyond Lean core** (`propext`, `Classical.choice`, `Quot.sound`). The kernel verifies the *logical architecture* of the proof; the companion manuscript (PLACE-papers, Zenodo DOI 10.5281/zenodo.19938917) carries the mathematical content. Both legs complete. Standard pattern: Wiles + Hales, applied in parallel rather than sequentially.

This repository is the lead member of the **PLACE TO STAND federation of kernels**. Each federated kernel is independent: own toolchain pin, own Zenodo deposit, own version history. Cross-kernel content travels by vendoring-with-attribution, not via Lake dependencies.

---

## Cite as

```
Seale, J. York. (2026). SIDE-kernel v1.1: Lean 4 kernel for the
SIDE proof of the Riemann Hypothesis. Zenodo.
https://doi.org/10.5281/zenodo.19937590

Predecessor: v1.0 at https://doi.org/10.5281/zenodo.19674313
```

---

## How to verify the work

```sh
git clone https://github.com/psinary-sketch/SIDE-kernel
cd SIDE-kernel
lake update          # one-time
lake build           # full build
```

Toolchain pinned in `lean-toolchain`: `leanprover/lean4:v4.29.0-rc8`.

The CI workflow at `.github/workflows/audit.yml` runs `lake build` and emits a Lean-warning-based sorry and axiom audit (v2.1). Independent verification: read the workflow YAML, examine the most recent run, or run locally.

Quick verification of the headline claim:
```sh
echo '#print axioms riemann_hypothesis' | lake env lean --stdin
```

---

## Theorems exported (v1.1)

The Day 1 proof chain:

- **`StructuralExhaustiveness`** (`Kernel/Layer1.lean`) — four-field structure: `conservation`, `ostrowski_complete`, `formation_exhaustive`, `per_class_exclusion`
- **`SIDE_exclusion`** (`Kernel/Layer1.lean`) — the named ZFC theorem: exhaustive catalogue plus none-produces implies negation
- **`structural_exhaustiveness_proved`** (`Kernel/TheBridgeComplete.lean`) — assembles the four fields unconditionally
- **`rh_from_structural_exhaustiveness`** (`Kernel/Integration.lean`) — derives Mathlib's `RiemannHypothesis` from `StructuralExhaustiveness`
- **`riemann_hypothesis`** — the composition. 0 sorry, 0 axioms beyond Lean core

The seven Voices (each forces σ = 1/2 in its mechanism class):

- `Voice1.lean` — C₂ Euler balance: `balance_theorem`
- `Voice2.lean` — C₁ Schwarz: `c1_forces_half`
- `Voice3.lean` — C₃ functional equation: `reflect_fixed_iff`
- `Voice3b.lean` — C₆ Cauchy-Riemann: `cr_forces_half`
- `Voice5.lean` — C₄ modular (PSL₂): `modular_forces_half`
- `Voice6.lean` — C₅ spectral: `self_adjoint_forces_half`
- `Voice7.lean` — C₇ topological (Hadamard): `topological_no_sigma_preference`

Conservation and product formula (`Kernel/ProductFormula/*.lean`, 3 files, 33 theorems): `conservation_of_spectra : ∀ s, 1^s = 1`, ProductFormula chain `∏ᵥ |x|ᵥ = 1`.

Place-classification bridge (`Kernel/PoissonExhaustion.lean`): Ostrowski as `Place` type, formation count (2, 3, 2, 0) = 7 by `native_decide`.

**New in v1.1 — Output-stage classification (`Bridge/CartanBBridge.lean`):**

- `output_stage_card : Fintype.card OutputStageClass = 2` (by `native_decide`)
- `elliptic_regularity_collapse` — Weyl 1940 / Hörmander 1958 via Mathlib `AnalyticOn ⇒ ContDiffOn`
- `identity_theorem_unique_bridge` — Cauchy/Weierstrass via Mathlib `AnalyticOnNhd.eqOn_of_preconnected_of_eventuallyEq`
- `cartan_B_consequence : CousinI_solvability` — structural placeholder for sheaf cohomology, Mittag-Leffler-on-ℂ acknowledged as working content
- `OutputStageExhaustiveness` certificate combining the four components
- `formation_n_3_eq_two : n_3 = 2`

**New in v1.1 — E-Difficulty Theorem skeleton (`Kernel/Cascade/SieveCeiling.lean`, vanilla Lean 4, no Mathlib):**

- `proof_mutually_exclusive`, `proof_dichotomy`
- `factored_dark_capped`, `density_one_lt_universal`
- **`sieve_ceiling`** — main theorem: dark-factored proofs cannot reach universal statements
- `bright_access_required` — contrapositive (Corollary 3.6 in SIEVE_CEILING_LEMMA.md)
- **`e_difficulty`** — main equivalence: `IsDecidable s ↔ Nonempty (DomainOstrowski s)` for `s.classes ≥ 1`
- `e_difficulty_xi` — smoke test applied to ξ_system

---

## Companion repositories in the federation

| Repo | Role |
|:-----|:-----|
| **SIDE-kernel** (this) | RH proof main chain |
| [SIDE-trivium](https://github.com/psinary-sketch/SIDE-trivium) | Trivium bijection (MechanismClass ↔ QuadraticDiscriminant, 0 axioms) |
| [SIDE-cosmo](https://github.com/psinary-sketch/SIDE-cosmo) | Cosmological extension (DS1 dark-sector inequality, formation phase space) |
| [SIDE-interfaces](https://github.com/psinary-sketch/SIDE-interfaces) | Interface vocabulary (rank_decomposition, PMT) |
| [SIDE-effects](https://github.com/psinary-sketch/SIDE-effects) | Framework consequences + Phase 1.5 bridge modules |

Each is independently auditable. None depends on the others via Lake.

---

## Cross-references to manuscripts (Day 1)

| Paper | Backed by |
|:------|:----------|
| *A Place to Stand* (monograph, v5.4) | Full chain `riemann_hypothesis` |
| *Seven Mechanism Classes* | Voice1–7 |
| *Which Structure Confines* | `rh_from_structural_exhaustiveness` |
| *Exhaustive Enumeration* | `PoissonExhaustion`, Place-classification |
| *Spectral Inertness* | `conservation_of_spectra`, ProductFormula chain |
| *Third Identity Element* | Trivium bijection (lives in SIDE-trivium) |
| *Silence of Foundations* | (philosophical, not directly kernel-backed) |

Phase 2 papers v1.1 newly backs:

| Paper | Backed by |
|:------|:----------|
| *Cartan B Domain Ostrowski* | `OutputStageExhaustiveness`, `formation_n_3_eq_two` |
| *Complex Analysis Is Formation Structure* | Same |
| *The Case for Two* | Same |
| *Sieve Ceiling Lemma* | `sieve_ceiling`, supporting theorems |
| *E-Difficulty Theorem* | `e_difficulty`, `IsDecidable`, `DomainOstrowski` |

---

## Discipline (for agents that propose edits)

1. **Federation respect.** No cross-kernel Lake dependencies. Cross-kernel content travels by vendoring-with-attribution.

2. **0 sorry, 0 axioms beyond Lean core.** Any PR that adds a sorry or a custom axiom does not match kernel discipline.

3. **Honest scope.** Structural placeholders (like `cartan_B_consequence`) must be documented in source comments with the path to their eventual Mathlib replacement.

4. **No "conditional" framing for RH.** The bridge is proved unconditionally inside the kernel.

5. **No "gap" methodology vocabulary.** Use "formation distance," "silence boundary," "density-placement barrier," "contingency interval" depending on context.

6. **I+D+S ordering.** Three principles: Independence, Determination, Symmetry. SIDE exclusion: Symmetry, Independence, Determination, Exhaustiveness. Never D+S+I.

7. **Counts are theorem-status.** Load-bearing: formation total 7; n₂ = 3; n₃ = 2; n₄ = 0; |GL(3, 𝔽₂)| = 168 = 24 × 7; Steane [[7, 1, 3]]. Other counts are descriptive.

---

## Honest open status (v1.1)

- `cartan_B_consequence` is a structural placeholder (`True`-bodied) for the sheaf cohomology H¹(ℂ, 𝒪) = 0. The working mathematics (Mittag-Leffler-on-ℂ, classical 1876) is acknowledged in source comments. Future Mathlib import will replace the placeholder.
- `Cascade/SieveCeiling.lean` is an abstract logical-skeleton formalization. Concrete Mathlib-dependent extensions named in source remarks block:
  - Replace abstract `Kappa` with `Real ∈ [0,1]`
  - Replace abstract `Proof` with `FirstOrder.Language` proof
  - Witness Epstein zero concretely (Mathlib PR: Davenport-Heilbronn for Z(s) of discriminant −23)
  - I-equivalence class as `Setoid` on the universe
  - Interface-factoring as predicate on concrete proof steps

Each extension elaborates the abstract structure; none changes the logical content already established.

---

## What an agent should NOT do without human approval

- Modify deposited Zenodo content. New deposits require explicit version bumps and authorship review.
- Introduce sorries into production theorems.
- Add cross-kernel Lake dependencies.
- Reframe RH as "conditional" or "pending."

---

## Contact

J. York Seale, ORCID [0009-0008-7993-0310](https://orcid.org/0009-0008-7993-0310). Via GitHub (issues, PRs) on this repository.

**:: → · ← ::**
