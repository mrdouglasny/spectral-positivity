/-
Copyright (c) 2026 Michael R. Douglas. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Jentzsch's Theorem (Generalized Perron-Frobenius)

For a compact, self-adjoint, positivity-improving operator T on L²(Ω, μ):
1. The spectral radius λ₀ > 0 is a simple eigenvalue
2. The corresponding eigenfunction ψ₀ > 0 a.e. (strictly positive)
3. All other eigenvalues satisfy |λ| < λ₀ (strict spectral gap)

This is the infinite-dimensional generalization of the Perron-Frobenius
theorem for positive matrices. It is the spectral foundation for:
- Mass gap in P(Φ)₂ (pphi2)
- Spectral gap of graphop semigroups (graphops-qft)
- Exponential mixing from Bakry-Émery curvature (markov-semigroups)

## The 7-phase proof (from pphi2)

1. |Tf| ≤ T|f| (positivity-preserving)
2. |⟨f, Tf⟩| ≤ ⟨|f|, T|f|⟩ (consequence of Phase 1)
3. If Tf = λ₀f, then T|f| = λ₀|f| (ground state has positive absolute value)
4. By positivity-improving: ψ₀ > 0 a.e. (ground state strictly positive)
5. Every λ₀-eigenvector has constant sign (from strict positivity)
6. λ₀ is simple (multiplicity 1)
7. |λ| < λ₀ for all other eigenvalues (spectral gap)

The full proof is in pphi2's `JentzschProof.lean` (1082 lines, fully proved).
This file states the theorem in the general (measure-space) setting and
will eventually contain the ported proof.

## Main results

- `jentzsch_theorem` — the full Jentzsch theorem (Phases 1-7)
- `ground_state_positive` — ψ₀ > 0 a.e. (Phase 4)
- `ground_state_simple` — λ₀ has multiplicity 1 (Phase 6)
- `spectral_gap` — |λ| < λ₀ for λ ≠ λ₀ (Phase 7)

## References

- Reed-Simon IV, Theorems XIII.43–44
- Simon, *Functional Integration and Quantum Physics* (2005), §I.13
- pphi2: `TransferMatrix/JentzschProof.lean` (1082 lines, fully proved)
-/

import SpectralPositivity.Operator.PositivityPreserving

open MeasureTheory

noncomputable section

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}

/-- **Jentzsch's theorem** for compact self-adjoint positivity-improving
operators on L²(Ω, μ).

Given:
- T : compact, self-adjoint, positivity-improving on L²(Ω, μ)
- An eigenbasis {b_i} with eigenvalues {λ_i}
- At least 2 eigenvectors (the space is nontrivial)

Conclusion: there exists a unique "ground" index i₀ such that:
1. λ_{i₀} > 0 (ground eigenvalue is strictly positive)
2. λ_{i₀} is simple: if λ_i = λ_{i₀} then i = i₀
3. |λ_i| < λ_{i₀} for all i ≠ i₀ (strict spectral gap)

The proof is in pphi2's `JentzschProof.lean` via the 7-phase
variational absolute value trick. This file will contain the
ported proof once the dependencies are resolved. -/
theorem jentzsch_theorem
    {ι : Type*} [DecidableEq ι]
    (T : (Ω → ℝ) → (Ω → ℝ))
    (hT_improving : IsPositivityImproving (μ := μ) T)
    (hT_sa : ∀ f g, ∫ x, T f x * g x ∂μ = ∫ x, f x * T g x ∂μ)
    (b : ι → (Ω → ℝ))  -- eigenbasis
    (eigenval : ι → ℝ)
    (h_eigen : ∀ i, T (b i) = fun x => eigenval i * b i x)
    (h_nt : ∃ j k : ι, j ≠ k)  -- nontrivial (≥ 2 eigenvectors)
    :
    ∃ i₀ : ι,
      (0 < eigenval i₀) ∧
      (∀ i, eigenval i = eigenval i₀ → i = i₀) ∧
      (∀ i, i ≠ i₀ → |eigenval i| < eigenval i₀) := by
  sorry -- Full proof: 1082 lines in pphi2's JentzschProof.lean

/-- The ground state eigenfunction is strictly positive a.e.
(Phase 4 of the Jentzsch proof.) -/
theorem ground_state_positive
    (T : (Ω → ℝ) → (Ω → ℝ))
    (hT_improving : IsPositivityImproving (μ := μ) T)
    (ψ₀ : Ω → ℝ) (λ₀ : ℝ) (hλ₀ : 0 < λ₀)
    (h_eigen : T ψ₀ = fun x => λ₀ * ψ₀ x)
    (h_nonneg : ∀ᵐ x ∂μ, 0 ≤ ψ₀ x)
    (h_nonzero : ¬ ∀ᵐ x ∂μ, ψ₀ x = 0) :
    ∀ᵐ x ∂μ, 0 < ψ₀ x := by
  sorry -- From h_eigen and hT_improving: T(ψ₀) = λ₀ψ₀ > 0 a.e.
  -- So ψ₀ = (1/λ₀) T(ψ₀), and T maps nonneg nonzero to strictly positive.

/-- The spectral gap: all eigenvalues other than λ₀ satisfy |λ| < λ₀.
(Phase 7 of the Jentzsch proof.) -/
theorem spectral_gap
    {ι : Type*} [DecidableEq ι]
    (T : (Ω → ℝ) → (Ω → ℝ))
    (hT_improving : IsPositivityImproving (μ := μ) T)
    (hT_sa : ∀ f g, ∫ x, T f x * g x ∂μ = ∫ x, f x * T g x ∂μ)
    (eigenval : ι → ℝ) (i₀ : ι)
    (h_ground : ∀ i, eigenval i ≤ eigenval i₀)
    (h_simple : ∀ i, eigenval i = eigenval i₀ → i = i₀) :
    ∀ i, i ≠ i₀ → |eigenval i| < eigenval i₀ := by
  sorry -- Phases 5-7 of the Jentzsch proof

end
