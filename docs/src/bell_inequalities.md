# Bell Inequalities

A linear inequality ``\langle\mathbf{G},\mathbf{P}\rangle\leq \gamma`` is defined as a Bell inequality of
a signaling polytope ``\mathcal{C}_d^{X \to Y}`` if all channels ``\mathbf{P}\in\mathcal{C}_d^{X \to Y}``
satisfy the Bell inequality, that is,

```math
    \mathcal{C}_d^{X \to Y}\subset \{\mathbf{P}\in\mathcal{P}^{X \to Y}|\; \langle\mathbf{G},\mathbf{P}\rangle\leq \gamma \}.
```

A Bell inequality is  denoted by the tuple ``(\mathbf{G},\gamma)`` where ``\mathbf{G}\in\mathbb{R}^{Y\times X}``
and ``\gamma\in\mathbb{R}`` .
It is useful to apply a game interpretation to a Bell inequality.
In the case of local signaling scenarios, a Bell inequality can be interpreted
as a cooperative guessing game played by Alice and Bob.
In this interpretation, Alice is shown an input ``x\in[X]`` and sends a message
to Bob using a limited amount of communication.
Bob then makes a guess ``y\in[Y]``.
The matrix ``\mathbf{G}`` specifies the reward for outputting ``y`` when
given input ``x``.
The objective of the game is then to score higher than ``\gamma``, that is, the
objective is to violate the Bell inequality ``(\mathbf{G}, \gammma)``.
Hence Alice and Bob strategize their encoding and decoding schemes to maximize the
reward.
If they are able to score higher than ``\gamma``, then Alice and Bob "win" the game.

We now discuss a subset of general Bell inequalities for signaling polytopes.
Further details about these inequalities are provided in [ref to paper](broken link).

```@docs
k_guessing_game
ambiguous_guessing_game
```

## Tight Bell Inequalities

A signaling polytope Bell inequality ``(\mathbf{G},\gamma)`` is said to be tight
if it is a facet of the  ``\mathcal{C}_d^{X \to Y}`` signaling polytope see [Facets](@ref) section.
Tight Bell inequalities of a signaling polytope ``\mathcal{C}_d^{X \to Y}`` are
important because their violation witnesses the use of more than  ``d`` dit classical
communication.
Hence if ``\langle\mathbf{G},\mathbf{P}\rangle\nleq \gamma``, then ``\mathbf{P}\notin \mathcal{C}_d^{X \to  Y}``.
We provide a catalog of tight Bell inequality which bound general signaling polytopzes.
See [ref to paper](broken link) for details.

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

## Theoretical Facets

The following list of Bell inequalities are proven to be tight in Reference [link to paper](broken link).
Each of the following methods constructs a canonical facet for the signaling polytope ``\mathcal{C}_d^{X \to Y}``.
The constructed facet inequalities are represented using the `BellScenario.BellGame` type.
All row and column permutations of facets are also facets of ``\mathcal{C}_d^{X \to Y}``.

```@docs
maximum_likelihood_facet
ambiguous_guessing_facet
anti_guessing_facet
k_guessing_facet
coarse_grained_input_ambiguous_guessing_facet
non_negativity_facet
```

## Verification of Theoretical Facets

To verify the tightness of a Bell inequality, ``X(Y-1)`` affinely independent
vertices must be found to satisfy ``\gamma = \langle \mathbf{G}, \mathbf{V} \rangle``.
We demonstrate these enumerations for the set of facets described above.
The [`test/unit/affinely_independent_enumerations.jl`](https://github.com/ChitambarLab/SignalingDimension.jl/blob/master/test/unit/affinely_independent_enumerations.jl)
verify that each of these enumerations scale across a wide range of scenarios.

```@docs
aff_ind_maximum_likelihood_vertices
aff_ind_non_negativity_vertices
aff_ind_ambiguous_guessing_vertices
aff_ind_coarse_grained_input_ambiguous_guessing_vertices
aff_ind_anti_guessing_vertices
aff_ind_k_guessing_vertices
```
