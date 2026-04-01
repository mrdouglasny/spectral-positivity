/-
Copyright (c) 2026 Michael R. Douglas. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Metzler Matrix Exponential Positivity (stub)

A Metzler matrix (nonneg off-diagonal) generates a positive semigroup:
e^{tL} ≥ 0 for all t ≥ 0.

The full proof requires the matrix exponential (NormedSpace.exp) with
a NormedRing instance on Matrix n n ℝ. This is available in Mathlib
but requires careful instance management. The proof strategy is in
NonnegPower.lean (truncated exponential nonneg + decomposition).

TODO: complete using Mathlib.Analysis.Normed.Algebra.MatrixExponential.
-/

import SpectralPositivity.Matrix.NonnegPower
