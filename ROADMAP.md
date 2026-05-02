# Roadmap: Related Results

Current status: **0 sorries, 0 axioms** — all results compile cleanly against Mathlib v4.29.

## Current Results

| Module | Result | Status |
|--------|--------|--------|
| `Matrix/NonnegPower.lean` | $M \geq 0 \Rightarrow M^k \geq 0$ | Proved |
| `Matrix/NonnegPower.lean` | Truncated matrix exponential nonneg | Proved |
| `Matrix/NonnegPower.lean` | Markov generator has nonneg off-diagonal | Proved |
| `Matrix/MetzlerExp.lean` | Metzler decomposition $L = -cI + N$, $N \geq 0$ | Proved |
| `Matrix/MetzlerExp.lean` | $L$ Metzler $\Rightarrow e^{tL} \geq 0$ for $t \geq 0$ | Proved |
| `Matrix/MMatrixInverse.lean` | Strict positivity of $e^{-tM}$ for irreducible M-matrix | Proved |
| `Matrix/MMatrixInverse.lean` | Laplace transform identity for M-matrix inverse | Proved |
| `Matrix/MMatrixInverse.lean` | $M$ nonsingular M-matrix $\Rightarrow M^{-1} > 0$ entrywise (irreducible) | Proved |
| `Matrix/MMatrixInverse.lean` | $M$ PD Z-matrix $\Rightarrow M^{-1} \geq 0$ entrywise (no irreducibility) | Proved |
| `Operator/JentzschProof.lean` | Phase 1: $\lvert Tf \rvert \leq T\lvert f \rvert$ a.e. | Proved |
| `Operator/JentzschProof.lean` | Phase 2: $\lvert \langle f, Tf \rangle \rvert \leq \langle \lvert f \rvert, T\lvert f \rvert \rangle$ | Proved |
| `Operator/JentzschProof.lean` | Phase 3: $\lvert f \rvert$ is a ground state | Proved |
| `Operator/JentzschProof.lean` | Phase 4: Ground state $\psi_0 > 0$ a.e. | Proved |
| `Operator/JentzschProof.lean` | Phase 5: Eigenvectors have constant sign | Proved |
| `Operator/JentzschProof.lean` | Phase 6: $\lambda_0$ is simple | Proved |
| `Operator/JentzschProof.lean` | Phase 7: Spectral gap $\lvert \lambda \rvert < \lambda_0$ | Proved |

## Proposed Additions

### 1. Perron–Frobenius for Nonneg Matrices

**File:** `Matrix/PerronFrobenius.lean` (new)
**Statement:** If $A \geq 0$ is irreducible, then:
- The spectral radius $r(A)$ is a simple eigenvalue of $A$
- There exists a corresponding eigenvector $v > 0$ (all entries strictly positive)
- $\lvert \lambda \rvert \leq r(A)$ for all eigenvalues $\lambda$, with equality only for the $h$ eigenvalues $r(A) e^{2\pi i k/h}$ where $h$ is the period of $A$

**Proof strategy:** Either specialize Jentzsch to finite dimensions (the matrix acts on $\ell^2(n)$, which is $L^2$ over a counting measure), or give the classical combinatorial proof via $A^k$ growth. The specialization route reuses existing work.
**Difficulty:** Medium–Hard. The specialization route needs the connection between matrix irreducibility and the positivity-improving condition on $\ell^2$.
**References:** Horn–Johnson Ch. 8; Seneta, *Non-negative Matrices and Markov Chains*, Springer, 2006.

### 2. Krein–Rutman Theorem

**File:** `Operator/KreinRutman.lean` (new)
**Statement:** Let $E$ be a Banach space with a total cone $K$, and let $T : E \to E$ be compact with $T(K) \subseteq K$ and $r(T) > 0$. Then $r(T)$ is an eigenvalue with an eigenvector in $K$.
**Proof strategy:** Approximate $r(T)$ by eigenvalues of $T + \varepsilon u \otimes \phi$ (rank-one perturbation making $T$ strongly positive), extract a convergent subsequence of normalized eigenvectors. This is the standard Schaefer/Deimling proof.
**Difficulty:** Hard. Requires ordered Banach space infrastructure (cones, normal cones, total cones) that is not yet in Mathlib. The Jentzsch proof sidesteps this by working directly in $L^2$ lattice structure.
**References:** Krein–Rutman (1948); Deimling, *Nonlinear Functional Analysis*, Ch. 19; Schaefer, *Banach Lattices and Positive Operators*.

### 3. Kernel Positivity-Improving Criterion

**File:** `Operator/KernelPositivity.lean` (new)
**Statement:** An integral operator $Tf(x) = \int K(x,y) f(y)\, d\mu(y)$ on $L^2(\Omega, \mu)$ is positivity-improving if and only if $K(x,y) > 0$ for $\mu \otimes \mu$-a.e. $(x,y)$.
**Proof strategy:** The forward direction uses test functions supported on small sets. The reverse direction is a direct computation: if $f \geq 0$, $f \neq 0$, then $Tf(x) = \int K(x,y) f(y)\, d\mu(y) > 0$ a.e. since $K > 0$ a.e. and $f > 0$ on a set of positive measure.
**Difficulty:** Medium. Needs `Mathlib.MeasureTheory.Integral` and the connection between $L^2$ functions and their pointwise representatives.
**References:** Reed–Simon IV, Theorem XIII.44; Simon, *Functional Integration and Quantum Physics*, Prop. I.12.

### 4. Spectral Radius Equals Norm for Positive Operators

**File:** `Operator/SpectralRadius.lean` (new)
**Statement:** For a compact self-adjoint positivity-preserving operator $T$ on $L^2(\Omega, \mu)$, the spectral radius satisfies $r(T) = \lVert T \rVert$.
**Proof strategy:** For self-adjoint operators, $\lVert T \rVert = \sup \lvert \langle f, Tf \rangle \rvert / \lVert f \rVert^2$. By Phase 2 (already proved), the supremum is attained at $\lvert f \rvert$, and $\langle \lvert f \rvert, T\lvert f \rvert \rangle \geq \lvert \langle f, Tf \rangle \rvert$, so the sup is attained at a nonneg function. Combined with the spectral theorem, this gives $r(T) = \lVert T \rVert$.
**Difficulty:** Easy–Medium. Most ingredients are already in JentzschProof.lean; this is a corollary extraction.
**References:** Reed–Simon I, Theorem VI.6; Simon, *Trace Ideals*, Ch. 2.

## Suggested Priority

| Priority | Result | Rationale |
|----------|--------|-----------|
| 1 | Perron–Frobenius | Most-cited result in the area, natural finite-dim companion to Jentzsch |
| 2 | Kernel criterion | Connects abstract Jentzsch theorem to concrete applications |
| 3 | Spectral radius = norm | Quick corollary of existing work |
| 4 | Krein–Rutman | Important but hard; needs cone infrastructure not yet in Mathlib |
