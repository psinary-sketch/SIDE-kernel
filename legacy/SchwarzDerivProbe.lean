import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Comp

open Complex

theorem conj_hasDerivAt (f : ℝ → ℂ) (f' : ℂ) (x : ℝ) (hf : HasDerivAt f f' x) :
    HasDerivAt (fun x => conjCLE (f x)) (conjCLE f') x := by
  have h := conjCLE.toContinuousLinearMap.hasFDerivAt.comp x hf.hasFDerivAt
  convert h.hasDerivAt using 1
  simp [ContinuousLinearMap.comp_apply, ContinuousLinearMap.toSpanSingleton_apply]
  rfl
