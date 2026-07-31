import Kernel.Cascade.InvarianceBarrier

-- E0 salt-check: the abstract invariance / oracle-separation barrier.
-- General form only -- no zeta/RH instantiation in the kernel.
-- Expected: 0 sorry, 0 native_decide, and axiom-free (DERIVES).

#check @InvarianceBarrier.invariance_barrier
#check @InvarianceBarrier.DeterminedBy
#print axioms InvarianceBarrier.invariance_barrier
#print axioms InvarianceBarrier.DeterminedBy
#check @InvarianceBarrier.derivability_barrier
#check @InvarianceBarrier.Derives
#print axioms InvarianceBarrier.derivability_barrier
#print axioms InvarianceBarrier.Derives
