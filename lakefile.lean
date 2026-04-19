import Lake
open Lake DSL
package kerneltest where
  leanOptions := #[]
require mathlib from git
  "https://github.com/leanprover-community/mathlib4"
@[default_target]
lean_lib KernelTest where
  srcDir := "."
lean_lib Kernel
lean_lib KernelSeventeen where
  srcDir := "."
  roots := #[`KernelSeventeen]
lean_lib Bridge
lean_lib PlatonicSolids where
  srcDir := "."
  roots := #[`PlatonicSolids]
lean_lib MetaKernel where
  roots := #[`MetaKernel]