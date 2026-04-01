/-
Copyright (c) 2026 Michael R. Douglas. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Positivity-Preserving and Positivity-Improving Operators

The definitions and basic properties are in JentzschProof.lean
(ported from pphi2). This file re-exports them for clean API access.

Definitions work on Lp ℝ 2 volume for any MeasureSpace Ω:
- `IsPositivityPreserving T` — f ≥ 0 ⟹ Tf ≥ 0
- `IsPositivityImproving T` — f ≥ 0, f ≠ 0 ⟹ Tf > 0 a.e.
- `IsPositivityImproving' T` — Lp-lattice version of improving

See JentzschProof.lean for the full Jentzsch theorem using these.
-/

-- All definitions are in JentzschProof.lean to avoid duplication.
-- Import Jentzsch.lean which re-exports JentzschProof.lean.
