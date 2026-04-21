import Lake
open Lake DSL

package kerneltest where
  leanOptions := #[]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4"

@[default_target]
lean_lib Kernel where
  srcDir := "."
  globs := #[.submodules `Kernel]

lean_lib Bridge where
  srcDir := "."
  globs := #[.submodules `Bridge]

lean_lib MetaKernel where
  roots := #[`MetaKernel]
