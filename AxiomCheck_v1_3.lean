import Bridge.TheBridgeComplete
import Bridge.ConservationBridge
import Kernel.SpectralCannonFull
import Kernel.Integration
import Kernel.Core
import Bridge.CrossClassExclusion
import MetaKernel

-- §25.8 Kernel Concordance table entries — re-profiled at v1.3 (W-7 existential)
#print axioms structural_exhaustiveness_proved                 -- Route 1 (TheBridgeComplete; unconditional)
#print axioms SpectralCannonFull.spectral_cannon               -- Route 2
#print axioms ConservationBridge.riemann_hypothesis            -- Route 3 (statement changed: existential hyp)
#print axioms techne_kernel_integration.rh_from_structural_exhaustiveness
#print axioms techne_kernel_integration.structural_exhaustiveness_iff_rh
#print axioms SIDEKernel.formation
#print axioms techne_kernel_cross_exclusion.all_pairs_excluded

-- W-7 changed consumers (ConservationBridge, existential ConservationHypothesis)
#print axioms ConservationBridge.structural_exhaustiveness_proved
#print axioms ConservationBridge.conservation_activates_balance
