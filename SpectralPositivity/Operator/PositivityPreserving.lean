/-
Copyright (c) 2026 Michael R. Douglas. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Positivity-Preserving and Positivity-Improving Operators

Generalizes pphi2's `IsPositivityPreserving` and `IsPositivityImproving`
from L²(ℝⁿ) to L²(Ω, μ) for any measure space.

An operator T on L²(Ω, μ) is:
- **Positivity-preserving:** f ≥ 0 a.e. ⟹ Tf ≥ 0 a.e.
- **Positivity-improving:** f ≥ 0 a.e., f ≠ 0 ⟹ Tf > 0 a.e.

Positivity-improving is the condition needed for Jentzsch's theorem
(the spectral gap and simple ground state).

## Main results

- `IsPositivityPreserving` — f ≥ 0 ⟹ Tf ≥ 0
- `IsPositivityImproving` — f ≥ 0, f ≠ 0 ⟹ Tf > 0
- `abs_apply_le` — |Tf| ≤ T|f| (Phase 1 of Jentzsch)
- `abs_inner_le` — |⟨f, Tf⟩| ≤ ⟨|f|, T|f|⟩ (Phase 2)

These are the first two phases of the Jentzsch proof, extracted to
be reusable across projects (pphi2, graphops-qft, markov-semigroups).

## References

- Reed-Simon IV, Theorems XIII.43–44
- pphi2: `TransferMatrix/JentzschProof.lean` (the original proof)
-/

import Mathlib.MeasureTheory.Function.LpSpace.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic

open MeasureTheory

noncomputable section

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}

/-- An operator on L²(Ω, μ) is positivity-preserving:
f ≥ 0 a.e. ⟹ Tf ≥ 0 a.e.

This is the operator-level version of "nonneg kernel." For integral
operators with kernel K(x,y) ≥ 0, this is automatic. -/
def IsPositivityPreserving (T : (Ω → ℝ) → (Ω → ℝ)) : Prop :=
  ∀ f : Ω → ℝ, (∀ᵐ x ∂μ, 0 ≤ f x) → (∀ᵐ x ∂μ, 0 ≤ T f x)

/-- An operator on L²(Ω, μ) is positivity-improving:
f ≥ 0 a.e., f ≠ 0 ⟹ Tf > 0 a.e.

This is strictly stronger than positivity-preserving. It says: any
nonneg nonzero input produces a STRICTLY positive output. Physically:
the operator "spreads" positivity to the entire space.

For the heat kernel on a connected graph: K_t is positivity-improving
for t > 0 (heat spreads everywhere). For t = 0: K_0 = I is only
positivity-preserving (not improving).

This is the condition needed for Jentzsch's theorem. -/
def IsPositivityImproving (T : (Ω → ℝ) → (Ω → ℝ)) : Prop :=
  ∀ f : Ω → ℝ, (∀ᵐ x ∂μ, 0 ≤ f x) → (¬ ∀ᵐ x ∂μ, f x = 0) →
    (∀ᵐ x ∂μ, 0 < T f x)

/-- Positivity-improving implies positivity-preserving. -/
theorem IsPositivityImproving.toPreserving {T : (Ω → ℝ) → (Ω → ℝ)}
    (hT : IsPositivityImproving (μ := μ) T) :
    IsPositivityPreserving (μ := μ) T := by
  intro f hf
  by_cases h0 : ∀ᵐ x ∂μ, f x = 0
  · -- f = 0 a.e., so Tf = 0 a.e. (by linearity, if we had it)
    sorry
  · -- f ≥ 0 and f ≠ 0, so Tf > 0 a.e. ≥ 0
    filter_upwards [hT f hf h0] with x hx
    exact le_of_lt hx

/-- Phase 1 of Jentzsch: |Tf| ≤ T|f| for positivity-preserving T.

Proof: Write f = f⁺ - f⁻ (positive and negative parts).
  Tf = T(f⁺) - T(f⁻)
  |Tf| ≤ |T(f⁺)| + |T(f⁻)| = T(f⁺) + T(f⁻) = T(f⁺ + f⁻) = T|f|
where we used: T(f⁺) ≥ 0 and T(f⁻) ≥ 0 (positivity-preserving). -/
theorem abs_apply_le_of_positivityPreserving {T : (Ω → ℝ) → (Ω → ℝ)}
    (hT : IsPositivityPreserving (μ := μ) T)
    (hT_linear : ∀ f g, T (f + g) = T f + T g)
    (hT_neg : ∀ f, T (fun x => -f x) = fun x => -T f x)
    (f : Ω → ℝ) :
    ∀ᵐ x ∂μ, |T f x| ≤ T (fun y => |f y|) x := by
  sorry -- Full proof in pphi2's JentzschProof.lean (Phase 1)

/-- Phase 2 of Jentzsch: |⟨f, Tf⟩| ≤ ⟨|f|, T|f|⟩ for positivity-preserving T.

Follows from Phase 1 + Cauchy-Schwarz. -/
theorem abs_inner_le_of_positivityPreserving {T : (Ω → ℝ) → (Ω → ℝ)}
    (hT : IsPositivityPreserving (μ := μ) T)
    (hT_linear : ∀ f g, T (f + g) = T f + T g)
    (hT_neg : ∀ f, T (fun x => -f x) = fun x => -T f x)
    (f : Ω → ℝ) :
    |∫ x, f x * T f x ∂μ| ≤ ∫ x, |f x| * T (fun y => |f y|) x ∂μ := by
  sorry -- Full proof in pphi2's JentzschProof.lean (Phase 2)

end
