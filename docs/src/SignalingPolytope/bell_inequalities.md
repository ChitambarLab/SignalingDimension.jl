# Signaling Polytope: Bell Inequalities

A linear inequality ``\langle\mathbf{G},\mathbf{P}\rangle\leq \gamma`` is defined as a Bell inequality of
a signaling polytope ``\mathcal{C}_d^{X \to Y}`` if all channels ``\mathbf{P}\in\mathcal{C}_d^{X \to Y}``
satisfy the Bell inequality, that is,

```math
    \mathcal{C}_d^{X \to Y}\subset \{\mathbf{P}\in\mathcal{P}^{X \to Y}|\; \langle\mathbf{G},\mathbf{P}\rangle\leq \gamma \}.
```

A Bell inequality is  denoted by the tuple ``(\mathbf{G},\gamma)`` where ``\mathbf{G}\in\mathbb{R}^{Y\times X}``
and ``\gamma\in\mathbb{R}`` .
A signaling polytope Bell inequality ``(\mathbf{G},\gamma)`` is said to be tight
if it is a facet of the  ``\mathcal{C}_d^{X \to Y}`` signaling polytope see [Facets](@ref) section.
Tight Bell inequalities of a signaling polytope ``\mathcal{C}_d^{X \to Y}`` are
important because their violation witnesses the use of more than  ``d`` dit classical
communication.
Hence if ``\langle\mathbf{G},\mathbf{P}\rangle\nleq \gamma``, then ``\mathbf{P}\notin \mathcal{C}_d^{X \to  Y}``.

## Theoretical Facets

We provide several tight Bell inequality which bound general signaling polytopes.

```@docs
non_negativity_facet
maximum_likelihood_facet
ambiguous_guessing_facet
anti_guessing_facet
k_guessing_facet
coarse_grained_input_ambiguous_guessing_facet
```

### Affinely Independent Enumerations

To prove the tightness of the preceding facets, a set of ``X(Y -1)`` affinely independent
vertices must be shown to satisfy ``\gamma = \langle \mathbf{G}, \mathbf{V} \rangle``.
These enumerations a demonstrated with the following methods.

```@docs
aff_ind_maximum_likelihood_vertices
aff_ind_non_negativity_vertices
aff_ind_ambiguous_guessing_vertices
aff_ind_coarse_grained_input_ambiguous_guessing_vertices
aff_ind_anti_guessing_vertices
aff_ind_k_guessing_vertices
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
