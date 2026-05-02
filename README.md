# spectral-positivity

Perron-Frobenius theory, Jentzsch's theorem, and matrix/operator
positivity in Lean 4. A shared library used by:

- [pphi2](https://github.com/mrdouglasny/pphi2) — transfer matrix spectral gap
- [graphops-qft](https://github.com/mrdouglasny/graphops-qft) — heat kernel positivity on graphops
- [markov-semigroups](https://github.com/mrdouglasny/markov-semigroups) — positivity of Markov semigroups

## What this package provides

### Matrix level (`Matrix/`)
- **Nonneg matrix powers:** $M \geq 0 \Rightarrow M^k \geq 0$ (proved)
- **Metzler matrix exponential:** $L$ nonneg off-diagonal $\Rightarrow e^{tL} \geq 0$ for $t \geq 0$
  (the heat kernel on a graph has nonneg entries)
- **Decomposition:** $L = -cI + N$ with $N \geq 0$, so $e^{tL} = e^{-ct} e^{tN}$
- **M-matrix inverse positivity:** if $M$ is a nonsingular M-matrix
  (a $Z$-matrix with positive principal minors / equivalently $sI - A$
  with $A \geq 0$ entrywise and $s > \rho(A)$), then $M^{-1} > 0$
  entrywise. Theorem `Matrix.MMatrix.inverse_pos` in
  `Matrix/MMatrixInverse.lean`. Used by markov-semigroups for the
  diamagnetic-inequality chain and by graphops-qft for resolvent
  positivity.
- **M-matrix inverse non-negativity:** the same conclusion without the
  irreducibility hypothesis: $M$ PD with $M_{ij} \leq 0$ for $i \neq j$
  $\Rightarrow M^{-1} \geq 0$ entrywise. Theorem
  `Matrix.MMatrix.inverse_nonneg` in `Matrix/MMatrixInverse.lean`. Used
  by markov-semigroups (`Matrix/LaplaceTransform.lean` re-exports it as
  `m_matrix_inverse_nonneg`, the previously axiomatized form) for the
  diamagnetic chain consumed by pphi2N's QHJ thimble proofs.

### Operator level (`Operator/`)
- **Positivity-preserving:** $f \geq 0 \Rightarrow Tf \geq 0$ (on $L^2(\Omega, \mu)$)
- **Positivity-improving:** $f \geq 0$, $f \neq 0 \Rightarrow Tf > 0$ a.e.
- **Jentzsch's theorem:** For compact self-adjoint positivity-improving $T$:
  - Simple ground eigenvalue $\lambda_0 > 0$
  - Ground eigenfunction $\psi_0 > 0$ a.e.
  - Spectral gap: $|\lambda| < \lambda_0$ for all other eigenvalues

## Origin

The Jentzsch proof was originally developed in pphi2 (1082 lines, fully
proved) for the P(Phi)_2 transfer matrix. This package extracts and
generalizes it to work on any measure space, making it reusable.

The matrix positivity was developed in graphops-qft for heat kernels on
graphop semigroups.

## File structure

```
SpectralPositivity/
  Matrix/
    NonnegPower.lean      -- M ≥ 0 ⟹ M^k ≥ 0, truncated exp nonneg
    MetzlerExp.lean       -- Metzler decomposition, e^{tL} ≥ 0
    MMatrixInverse.lean   -- M-matrix ⟹ M⁻¹ > 0 entrywise
  Operator/
    PositivityPreserving.lean -- IsPositivityPreserving, IsPositivityImproving
    Jentzsch.lean             -- Jentzsch theorem (spectral gap)
```

## Building

```bash
lake update
lake build
```

## References

- Reed and Simon, *Methods of Modern Mathematical Physics IV*, 1978,
  Theorems XIII.43–44.
- Horn and Johnson, *Matrix Analysis*, Cambridge, 2013, Thm 8.5.5.
- Berman and Plemmons, *Nonnegative Matrices in the Mathematical
  Sciences*, SIAM, 1994.

## License

Copyright (c) 2026 Michael R. Douglas. Released under the Apache 2.0 license.
