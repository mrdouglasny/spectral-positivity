/-
Copyright (c) 2026 Michael R. Douglas. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Nonneg Matrix Powers and Positivity

Proves that nonneg matrices have nonneg powers, and that the truncated
matrix exponential of a nonneg matrix is nonneg. These are the building
blocks for the Metzler matrix exponential theorem (in MetzlerExp.lean).

## Main results (all PROVED)

- `Matrix.Nonneg.pow` — M ≥ 0 ⟹ M^k ≥ 0
- `Matrix.Nonneg.sum` — sum of nonneg matrices is nonneg
- `Matrix.Nonneg.smul` — c ≥ 0 and M ≥ 0 ⟹ cM ≥ 0
- `truncated_exp_nonneg` — Σ_{k≤N} (tM)^k/k! ≥ 0 for M ≥ 0, t ≥ 0
- `markov_generator_nonneg_offdiag` — M ≥ 0 ⟹ (M-I) nonneg off-diagonal

## References

- Berman and Plemmons, *Nonnegative Matrices*, SIAM, 1994
-/

import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Data.Real.Basic

open Matrix BigOperators Finset

noncomputable section

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- A matrix has nonneg off-diagonal entries (Metzler condition). -/
def Matrix.NonnegOffDiag (L : Matrix n n ℝ) : Prop :=
  ∀ i j, i ≠ j → 0 ≤ L i j

/-- A matrix has all nonneg entries. -/
def Matrix.Nonneg (M : Matrix n n ℝ) : Prop :=
  ∀ i j, 0 ≤ M i j

/-- A nonneg matrix has nonneg powers. -/
theorem Matrix.Nonneg.pow {M : Matrix n n ℝ} (hM : M.Nonneg) (k : ℕ) :
    (M ^ k).Nonneg := by
  induction k with
  | zero => intro i j; simp [Matrix.one_apply]; split <;> norm_num
  | succ k ih =>
    intro i j
    rw [pow_succ, Matrix.mul_apply]
    apply Finset.sum_nonneg
    intro l _
    exact mul_nonneg (ih i l) (hM l j)

/-- Sum of nonneg matrices is nonneg. -/
theorem Matrix.Nonneg.sum {ι : Type*} {s : Finset ι}
    {M : ι → Matrix n n ℝ} (hM : ∀ i ∈ s, (M i).Nonneg) :
    (∑ i ∈ s, M i).Nonneg := by
  intro i j
  simp only [Matrix.sum_apply]
  apply Finset.sum_nonneg
  intro k hk
  exact hM k hk i j

/-- Scalar multiple of a nonneg matrix by a nonneg scalar is nonneg. -/
theorem Matrix.Nonneg.smul {M : Matrix n n ℝ} (hM : M.Nonneg) {c : ℝ} (hc : 0 ≤ c) :
    (c • M).Nonneg := by
  intro i j; simp; exact mul_nonneg hc (hM i j)

/-- The truncated matrix exponential Σ_{k=0}^{N} (tM)^k / k! is nonneg
when M is nonneg and t ≥ 0. -/
theorem truncated_exp_nonneg {M : Matrix n n ℝ} (hM : M.Nonneg) {t : ℝ} (ht : 0 ≤ t)
    (N : ℕ) :
    (∑ k ∈ range (N + 1), (1 / k.factorial : ℝ) • (t • M) ^ k).Nonneg := by
  apply Matrix.Nonneg.sum
  intro k _
  apply Matrix.Nonneg.smul
  · exact (hM.smul ht).pow k
  · positivity

/-- For a Markov operator M (nonneg entries), the generator L = M - I has
nonneg off-diagonal entries: L_{xy} = M_{xy} ≥ 0 for x ≠ y. -/
theorem markov_generator_nonneg_offdiag {m : Type*} [DecidableEq m]
    (M : Matrix m m ℝ) (hM : M.Nonneg) :
    (M - 1).NonnegOffDiag := by
  intro i j hij
  simp [Matrix.sub_apply, Matrix.one_apply, if_neg hij]
  exact hM i j

end
