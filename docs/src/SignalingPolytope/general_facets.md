# Signaling Polytope: Bell Inequalities

The Bell inequalities (facets) of the signaling polytope bound the signaling correlations
for ``d``-dit classical communication.
If a channel ``\mathbf{P}\in\mathcal{P}^{n \to n'}`` violates a Bell inequality ``\mathbf{F}\supset \mathcal{C}_d^{n \to n'}``,
then ``\mathbf{P}\notin\mathcal{C}_d^{n \to n'}``.
Therefore, the signaling dimension of ``\mathbf{P}`` is greater than ``d``, that is, ``\kappa(\mathbf{P}) > d``.

## Theoretical Facets

We provide several tight Bell inequality which bound general signaling polytopes.

```@docs
non_negativity_game
success_game
ambiguous_game
error_game
generalized_error_game
coarse_grained_input_ambiguous_game
```

### Affinely Independent Enumerations

To prove the tightness of the preceeding facet, a set of ``n(n'-1)`` affinely independent
vertices must be shown to satisfy ``\gamma = \langle \mathbf{G}, \mathbf{V} \rangle``.
These enumerations a demonstrated with the following methods.

```@docs
aff_ind_success_game_strategies
aff_ind_non_negativity_game_strategies
aff_ind_ambiguous_game_strategies
aff_ind_coarse_grained_input_ambiguous_game_strategies
aff_ind_error_game_strategies
aff_ind_generalized_error_game_strategies
```

### Verification

Unit tests in [`test/unit/affinely_independent_enumerations.jl`] verify that each of
these affinely independent enumerations scale across a wide range of scenarios.


## Computed Facets

Using the adjacency decomposition technique, we've computed a broad range of signaling polytope facets.
Computed facets of the signaling polytope are found in the [`data/`](https://github.com/ChitambarLab/SignalingDimension.jl/tree/master/data)
directory.

### Quick Adjacency Decompositions

In the [`data/quick_adjacency_decomposition/`](https://github.com/ChitambarLab/SignalingDimension.jl/tree/master/data/quick_adjacency_decomposition)
directory, the adjacency decomposition algorithm is used to find the generating facets of the signaling polytope.
The polytope computation scripts are found in the [`script/quick_adjacency_decomposition/`](https://github.com/ChitambarLab/SignalingDimension.jl/tree/master/script/quick_adjacency_decomposition) directory. They are intended to run quickly on a laptop computer.

Data is provided in two formats:
* `.txt` files are human readable
* `.ieq` file format readable by BellScenario.jl.

## Complete Polytopes

### Verification

### adjacency

### complete computations
