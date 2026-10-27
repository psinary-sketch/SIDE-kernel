import Lake
open Lake DSL

package sidekernel where
  leanOptions := #[]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "de5ce8a9a66a4aa68a9bdbb35b63a06d34d9ca11"

@[default_target]
lean_lib Kernel where
  srcDir := "."
  globs := #[.submodules `Kernel]

lean_lib Bridge where
  srcDir := "."
  globs := #[.submodules `Bridge]

lean_lib MetaKernel where
  roots := #[`MetaKernel]
