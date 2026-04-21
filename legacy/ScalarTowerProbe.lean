import Mathlib.Analysis.Complex.Basic
import Mathlib.NumberTheory.LSeries.RiemannZeta

open Complex

#check (inferInstance : IsScalarTower ℝ ℂ ℂ)
#check (inferInstance : NormedAlgebra ℝ ℂ)
#check @HasDerivAt.scomp
