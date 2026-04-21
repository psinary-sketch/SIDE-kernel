import Lake
open Lake DSL

package sidekernel where
  leanOptions := #[]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "e960b84129b3caf423ecf0ea7409a8758a47012c"

@[default_target]
lean_lib Kernel where
  srcDir := "."
  globs := #[.submodules `Kernel]

lean_lib Bridge where
  srcDir := "."
  globs := #[.submodules `Bridge]

lean_lib MetaKernel where
  roots := #[`MetaKernel]
