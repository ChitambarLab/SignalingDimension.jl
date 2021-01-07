# Signaling Polytope: Overview

The *signaling polytope* is denoted ``\mathcal{C}_d^{n \to n'}`` and represents
the set of signaling correlations produced using one-way noiseless classical communication
and shared randomness.
The signaling polytope is a convex polyhedron and therefore, admits two equivalent descriptions.

* **Vertex Description:** The convex-hull of a finite set of extreme-points ``\mathcal{V}_d^{n \to n'}\subset\mathcal{P}_d^{n \to n'}``.

```math
\mathcal{C}_d^{n \to n'} = \text{Conv}(\mathcal{V}_d^{n \to n'})
```

* **Half-space Description:** The intersection of a finite set of half-spaces ``\mathcal{F}_d^{n \to n'}``.

```math
\mathcal{C}_d^{n \to n'} = \cap\{\mathcal{F}_d^{n \to n'}\}
```

The [`BellScenario.LocalPolytope`](https://chitambarlab.github.io/BellScenario.jl/stable/LocalPolytope/overview/#BellScenario.LocalPolytope)
provides tools for computing each of these representations.

## Vertices

A signaling polytope vertex ``\mathbf{V}\in\mathcal{V}_d^{n \to n'}`` must satisfy:
* ``\text{Rank}(\mathbf{V}) \leq d``
* Elements ``V(y|x) \in \{0,1\}`` for all ``y\in\mathcal{Y}`` and ``x\in\mathcal{X}``

Since the elements of a vertex are 0/1, they designate a [`BellScenario.DeterministicStrategy`](https://chitambarlab.github.io/BellScenario.jl/dev/BellScenario/strategies/#BellScenario.DeterministicStrategy).
However, `DeterministicStrategy` types contain redundant information because each of
the columns in the matrix are normalized, ``\sum_{y\in [n']} P(y|x) = 1``.
Therefore, the strategy can be represented in a `"normalized"` subspace where the
``n'``-th row of the matrix is removed.
Additionally, the polytope transformation software used by the `BellScenario.LocalPolytope`
module requires a vector input.
A column-major vectorization of the strategy matrix is then used to represent vertices
in the `"normalized"` subspace.

In total, the number of vertices are counted by

```math
|\mathcal{V}_d^{n \to n'}| = \sum_{c=1}^d \left\{X \atop c \right\}\binom{Y}{c}c!,
```

where ``\{ \}`` denotes Stirling's number of the second kind and ``\binom{n}{k}``
denotes ``n`` ``choose`` ``k`` [^DallArno2017].
Signaling polytope vertices can be counted using the [`BellScenario.LocalPolytope.num_vertices`](https://chitambarlab.github.io/BellScenario.jl/dev/LocalPolytope/vertices/#BellScenario.LocalPolytope.num_vertices) method and enumerated usig the [`BellScenario.LocalPolytope.vertices`](https://chitambarlab.github.io/BellScenario.jl/dev/LocalPolytope/vertices/#BellScenario.LocalPolytope.vertices) method.

### Code Example: Counting Vertices
```@example counting_signaling_polytope_vertices
using BellScenario

X = 4    # num inputs
Y = 4    # num outputs
d = 2    # d-dit signaling

scenario = LocalSignaling(X, Y, d)

# Count the number of vertices for the signaling polytope
num_vertices = LocalPolytope.num_vertices(scenario)
```

### Code Example: Enumerating Vertices
```@example enumerating_signaling_polytope_vertices
using BellScenario

X = 4    # num inputs
Y = 4    # num outputs
d = 2    # d-dit signaling

scenario = LocalSignaling(X, Y, d)

# Compute vertices in the "normalized" subspace.
# These vertices can be fed directly into polytope transformation methods.
vertices = LocalPolytope.vertices(scenario)

# Convert each vertex into a `DetermministicStrategy` matrix form.
deterministic_strategies = map(v -> convert(DeterministicStrategy, v, scenario), vertices)
```

## Facets

A signaling polytope facet ``\mathbf{F} \in \mathcal{F}_d^{n \to n'}`` is a half-space
inequality represented by a tuple ``(\gamma, \mathbf{G})`` containing an inequality upper
bound ``\gamma`` and real ``n'\times n`` matrix ``\mathbf{G}\in \mathbb{R}^{n'\times n}``.
A strategy matrix ``\mathbf{P}`` can be verified against a half-space inequality ``\mathbf{F}``
through the inner product

```math
\gamma \geq \langle \mathbf{G}, \mathbf{P}\rangle = \sum_{x,y}G_{y,x}P(y|x).
```

If the inequality is not satisfied, then ``\mathbf{P}`` violates facet ``\mathbf{F}``
and is not included in the signaling polytope.

A facet of ``\mathcal{C}_d^{n \to n'}`` must satisfy:
* ``\gamma \geq \langle \mathbf{G}, \mathbf{V} \rangle`` for all vertices ``\mathbf{V} \in \mathcal{V}_d^{n \to n'}``.
* ``\gamma = \langle \mathbf{G}, \mathbf{V} \rangle`` for at least ``n(n'-1)`` affinely independent vertices ``\mathbf{V} \in \mathcal{V}_d^{n \to n'}``.

Within the context of Bell scenarios, facets are equivalent to tight Bell inequalities.
Hence, their violation witnesses the use of resources of  greater operational value
than the set of classical resources considered for the particular  signaling polytope
``\mathcal{C}_d^{n \to n'}``.

Since the vertices of of the signaling polytope have  0/1 elements, ``\mathcal{C}_d^{n\to n'}``
is an integral polytope with rational facet inequality coefficients.
Therefore, any facet inequality ``\mathbf{F}\in\mathcal{F}_d^{n \to n'}`` can be
expressed in terms of integer coefficients.
Furthermore, the normalization constraints on strategies ``\mathbf{P} \in \mathcal{C}_d^{n \to n'}``
allows matrix ``\mathbf{G}`` to have non-negative entries and bound ``\gamma`` to
be positive.

This standard form for a facet inequality is represented by the [`BellScenario.BellGame`](https://chitambarlab.github.io/BellScenario.jl/dev/BellScenario/games/#BellScenario.BellGame)
type.
However, facets are initially computed in a vectorized form in the `"normalized"` subspace.

!!! warning "Performance of Facet Computations"
    Facet computations fail to perform for large numbers of vertices and vertices
    with large dimension. The number of vertices scale exponentially with the number
    of inputs and outputs, while the dimension scales as ``n(n'-1)``.


### Code Example: Complete Facet Enumeration

```@example
using BellScenario

X = 3    # num inputs
Y = 3    # num outputs
d = 2    # d-dit signaling

scenario = LocalSignaling(X, Y, d)

# Compute vertices in the "normalized" subspace.
vertices = LocalPolytope.vertices(scenario)

# Compute complete set of facets in "normalized" subspace.
facets = LocalPolytope.facets(vertices)["facets"]

# Convert each facet into `BellGame` form.
bell_games = map( f -> convert(BellGame, f, scenario), facets)

# printing γ ≥ G for each bell game
for bg in bell_games
    println(bg.β, " ≥ ", bg.game)
end
```

## Adjacency Decomposition

The input and output values a signaling scenario are merely labels.
Rearranging these labels cannot change the structure of the signaling correlations.
Therefore, the signaling polytope is invariant to permutations of inputs and outputs[^Rosset2014].

The permutation symmetry of the signaling polytope indicates that there is vertex
and facet transitivity.
This means that any permutation of the columns or rows of a strategy
or game matrix results in a new strategy or game indistinguishable from the original.
Hence, there exists a canonical set of generator vertices and facets whose permutations
describe the entire signaling polytope.

Since the number of permutations scale as factorial of ``n`` and ``n'``, the set
of generators is dramatic reduction in the number of total vertices and facets needed
to describe the polytope.
The canonical form of a generator facet or vertex is arbitrary and hence lexicographic
normal form is used as consistent ordering of matrices.

The adjacency decomposition technique [^Christof2001] exploits the permutation symmetry
of a polytope to compute a canonical set of generator facets.
This method greatly reduces the facet computation times and can be performed on
signaling polytopes using the [`BellScenario.LocalPolytope.adjacency_decomposition`](https://chitambarlab.github.io/BellScenario.jl/stable/LocalPolytope/adjacency_decomposition/#BellScenario.LocalPolytope.adjacency_decomposition) method.
Please refer to BellScenario.jl documentation for additional details on the arguments,
outputs, and implementation of the adjacency decomposition algorithm.

The advantages of the adjacency decomposition technique:
* The set of generator facets is much smaller than the complete set of facets reducing the amount of computation and size of output data.
* The computation does not need to be run to completion because a new generator facet is computed each iteration of the algorithm.
* The computation can be parallelized.

### Code Example: Adjacency Decomposition


```@example
using BellScenario

X = 4    # num inputs
Y = 4    # num outputs
d = 2    # d-dit signaling

scenario = LocalSignaling(X, Y, d)

# Compute vertices in the "normalized" subspace.
vertices = LocalPolytope.vertices(scenario)

# The adjacency decomposition requires a facet to seed the algorithm.
facet_seed = BellGame([1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1], 2)

# Compute the complete set of generator facets
adj_dict = LocalPolytope.adjacency_decomposition(vertices, facet_seed, scenario)

# The generator facets are the keys of returned dictionary
for bell_game in keys(adj_dict)
    println(bell_game.β, " ≥ ", bell_game.game)
end
```

### References
[^DallArno2017]: Dall’Arno, Michele, et al. "No-hypersignaling principle." Physical Review Letters 119.2 (2017): 020401.
[^Rosset2014]: Rosset, Denis, Jean-Daniel Bancal, and Nicolas Gisin. "Classifying 50 years of Bell inequalities." Journal of Physics A: Mathematical and Theoretical 47.42 (2014): 424022.
[^Christof2001]: Christof, Thomas, and Gerhard Reinelt. "Decomposition and parallelization techniques for enumerating the facets of combinatorial polytopes." International Journal of Computational Geometry & Applications 11.04 (2001): 423-437.
