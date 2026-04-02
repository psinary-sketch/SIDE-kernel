-- TECHNE KERNEL — Root Module
-- Import this file to build the entire active kernel.
-- March 5, 2026

-- Foundation
import Kernel.Layer1
import Kernel.XiDef
import Kernel.StructuralCount

-- Seven Voices
import Kernel.Voice1
import Kernel.Voice2
import Kernel.Voice3
import Kernel.Voice3b
import Kernel.Voice5
import Kernel.Voice6
import Kernel.Voice7

-- Schwarz Reflection
import Kernel.SchwarzDischarge

-- Product Formula + Conservation
import Kernel.ProductFormula_v2
import Kernel.ProductFormula_Clean
import Kernel.ProductFormula_Rat

-- FOCUS + Antisymmetry + Codim2
import Kernel.Focus
import Kernel.ThomBridge

-- Spectral Cannon + Perpendicular Crossing
import Kernel.SpectralCannon
import Kernel.SpectralCannonFull4
import Kernel.PerpendicularCrossing

-- Frobenius Uniqueness
import Kernel.Frobenius
import Kernel.Stormer
import Kernel.Trivium
import Kernel.ModularGroup
import Kernel.Alexander

-- Poisson Exhaustion
import Kernel.PoissonExhaustion

-- NOTE: Integration.lean and RouteBv4.lean excluded pending
-- Mathlib API repair (Phase 3). They contain the original
-- gate_e_exhaustive path. The equivalent content is covered by
-- ThomBridge (codim2_avoidance) and SpectralCannon (all_zeros_simple).
