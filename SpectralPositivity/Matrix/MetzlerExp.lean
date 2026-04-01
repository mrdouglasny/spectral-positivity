/-
Copyright (c) 2026 Michael R. Douglas. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Metzler Matrix Exponential Positivity

A Metzler matrix (= matrix with nonneg off-diagonal entries) generates
a positive semigroup: e^{tL} ≥ 0 entrywise for all t ≥ 0.

This is the matrix-level foundation for heat kernel positivity on
graphs. The Laplacian L = M - dI (where M is adjacency with nonneg
entries) is Metzler, so the heat kernel e^{tL} has nonneg entries.

## The decomposition proof

Write L = -cI + N where c = max_i |L_{ii}| and N = L + cI ≥ 0.
Then e^{tL} = e^{-ct} · e^{tN}. Since N ≥ 0 entrywise, e^{tN} ≥ 0.
Since e^{-ct} > 0, the product is ≥ 0.

## Main results

- `metzler_exp_nonneg` — L Metzler ⟹ e^{tL} ≥ 0 for t ≥ 0
- `metzler_decompose` — L = -cI + N with N ≥ 0
- `exp_commuting_scalar` — e^{A+cI} = e^c · e^A

## References

- Horn and Johnson, *Matrix Analysis*, Cambridge, 2013, Thm 8.5.5
- Berman and Plemmons, *Nonnegative Matrices*, SIAM, 1994
-/

import SpectralPositivity.Matrix.NonnegPower

open Matrix BigOperators Finset

noncomputable section

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Decomposition of a Metzler matrix: L = -cI + N where N ≥ 0.

Given L with nonneg off-diagonal entries, choose c so that c + L_{ii} ≥ 0
for all i (i.e., c ≥ max_i |L_{ii}|). Then N = L + cI has:
- N_{ij} = L_{ij} ≥ 0 for i ≠ j (from Metzler condition)
- N_{ii} = L_{ii} + c ≥ 0 (from choice of c) -/
def metzlerDecompose (L : Matrix n n ℝ) (hL : L.NonnegOffDiag)
    (c : ℝ) (hc : ∀ i, 0 ≤ L i i + c) :
    { N : Matrix n n ℝ // N.Nonneg ∧ L = -c • (1 : Matrix n n ℝ) + N } where
  val := L + c • 1
  property := by
    constructor
    · intro i j
      simp [Matrix.add_apply, Matrix.smul_apply, Matrix.one_apply]
      by_cases hij : i = j
      · subst hij; simp; exact hc i
      · simp [hij]; exact hL i j hij
    · ext i j; simp; ring

/-- For commuting matrices: e^{A + cI} = e^c · e^A.
Since cI commutes with everything, this always holds. -/
theorem exp_add_scalar_matrix (A : Matrix n n ℝ) (c t : ℝ) :
    Matrix.exp ℝ (t • (A + c • (1 : Matrix n n ℝ))) =
    Real.exp (c * t) • Matrix.exp ℝ (t • A) := by
  sorry -- needs: Matrix.exp_add for commuting matrices + t • (cI) = (ct) • I

/-- **Metzler matrix exponential theorem.**

If L has nonneg off-diagonal entries, then e^{tL} ≥ 0 for all t ≥ 0.

Proof: L = -cI + N with N ≥ 0. Then:
  e^{tL} = e^{t(-cI + N)} = e^{-ct} · e^{tN}
  - e^{tN} ≥ 0 (from NonnegPower.truncated_exp_nonneg in the limit)
  - e^{-ct} > 0
  - Product ≥ 0 -/
theorem metzler_exp_nonneg (L : Matrix n n ℝ) (hL : L.NonnegOffDiag)
    (t : ℝ) (ht : 0 ≤ t) :
    (Matrix.exp ℝ (t • L)).Nonneg := by
  -- Step 1: Choose c = max_i |L_{ii}| (or any c making L + cI nonneg)
  -- For now, use c = Finset.sup' univ ... (fun i => |L i i|)
  sorry
  -- Step 2: Decompose L = -cI + N with N ≥ 0
  -- Step 3: exp(tL) = exp(-ct) · exp(tN) by exp_add_scalar_matrix
  -- Step 4: exp(tN) ≥ 0 by truncated_exp_nonneg (taking limit of partial sums)
  -- Step 5: exp(-ct) > 0, so product ≥ 0

end
