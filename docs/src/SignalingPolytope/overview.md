# Signaling Polytope: Overview

Let ``\mathcal{C}_d^{X\to Y}`` denote the  set of classical signaling correlations
produced using one-way, noiseless classical communication and shared randomness.
This set is a convex polyhedron that we refer to as the *signaling polytope*.
As a convex polyhedron, the signaling polytope ``\mathcal{C}_d^{X \to Y}`` admits two equivalent descriptions[^Ziegler2012]:

* **Vertex Description:** Let ``\mathcal{V}_d^{X\to Y}\subset\mathcal{C}_d^{X\to Y}``
    denote the set of signaling polytope vertices.
    Then, the signaling polytope is defined as the convex-hull of its vertices ``\mathcal{V}_d^{X\to Y}``,

```math
    \mathcal{C}_d^{X \to Y} = \text{Conv}(\mathcal{V}_d^{X \to Y}).
```

* **Half-Space Description:** Let ``\mathcal{F}_d^{X \to Y}`` denote the set of
    closed half-space inequalities on ``\mathbb{R}^{Y \times X}`` that tightly bound
    the signaling polytope ``\mathcal{C}_d^{X\to Y}``.
    We  refer to an inequality in ``\mathcal{F}_d^{X \to Y}`` as a *facet*. Then, the signaling
    polytope is defined as the intersection of all inequalities in ``\mathcal{F}_d^{X\to Y}``,

```math
    \mathcal{C}_d^{X\to Y} = \cap\{\mathcal{F}_d^{X \to Y}\}.
```

The [`BellScenario.LocalPolytope`](https://chitambarlab.github.io/BellScenario.jl/stable/LocalPolytope/overview/#BellScenario.LocalPolytope)
module provides tools for computing each of these representations.

## Vertices

A signaling polytope vertex ``\mathbf{V}\in\mathcal{V}_d^{X \to Y}`` must satisfy:
* Elements ``V(y|x) \in \{0,1\}`` for all ``y\in\mathcal{Y}`` and ``x\in\mathcal{X}``
* ``\text{Rank}(\mathbf{V}) \leq d``

The total number of vertices in ``\mathcal{V}_d^{X \to Y}`` is then counted by [^DallArno2017]

```math
|\mathcal{V}_d^{X \to Y}| = \sum_{c=1}^d \left\{X \atop c \right\}\binom{Y}{c}c!,
```

where ``\{\}`` denotes Stirling's number of the second kind and ``\binom{Y}{c}``
denotes ``Y`` ``choose`` ``c``.

### Code Example: Counting Vertices

Signaling polytope vertices can be counted using the [`BellScenario.LocalPolytope.num_vertices`](https://chitambarlab.github.io/BellScenario.jl/dev/LocalPolytope/vertices/#BellScenario.LocalPolytope.num_vertices) method.

```@example counting_signaling_polytope_vertices
using BellScenario

X = 4    # num inputs
Y = 4    # num outputs
d = 2    # dit signaling

scenario = LocalSignaling(X, Y, d)

# Count the number of vertices for the signaling polytope
num_vertices = LocalPolytope.num_vertices(scenario)
```

### Code Example: Enumerating Vertices

The set of vertices ``\mathcal{V}_d^{X \to Y}`` can be enumerated  using the [`BellScenario.LocalPolytope.vertices`](https://chitambarlab.github.io/BellScenario.jl/dev/LocalPolytope/vertices/#BellScenario.LocalPolytope.vertices) method.
Since vertices have 0/1 elements, they can be represented by [`BellScenario.DeterministicStrategy`](https://chitambarlab.github.io/BellScenario.jl/dev/BellScenario/strategies/#BellScenario.DeterministicStrategy).

!!! note "Vertex Normalization"
    The columns of a channel ``\mathbf{P}\in\mathcal{P}^{X \to Y}`` are normalized
    such that ``\sum_{y=1}^Y P(y|x) = 1`` for all ``x``.
    Therefore, ``\mathbf{P}`` can be represented in a `"normalized"` subspace where the
    ``Y``-th row of matrix ``\mathbf{P}`` is removed.


!!! note "Vectorization"
    The polytope transformation software used by the `BellScenario.LocalPolytope`
    module requires vertices to be represented as vectors.
    Hence a column-major vectorization is used both vertices and facets in the polytope
    computations.

```@example enumerating_signaling_polytope_vertices
using BellScenario

X = 4    # num inputs
Y = 4    # num outputs
d = 2    # dit signaling

scenario = LocalSignaling(X, Y, d)

# Compute vertices in the "normalized" subspace.
# These vertices can be fed directly into polytope transformation methods.
vertices = LocalPolytope.vertices(scenario)

# Convert each vertex into a `DeterministicStrategy` matrix form.
deterministic_strategies = map(v -> convert(DeterministicStrategy, v, scenario), vertices)
```

## Facets

Let the tuple ``(\mathbf{G},\gamma) \in \mathcal{F}_d^{X \to Y}`` designate a facet of
``\mathcal{C}_d^{X \to Y}`` where ``\mathbf{G}\in \mathbb{R}^{Y\times X}``
and ``\gamma\in \mathbb{R}``.
The half-space inequality is then expressed as

```math
\gamma \geq \langle \mathbf{G}, \mathbf{P}\rangle = \sum_{x,y}G_{y,x}P(y|x)
```

where ``\langle\mathbf{G},\mathbf{P}\rangle`` is simply the Euclidean inner product
with some matrix ``\mathbf{P}\in\mathcal{P}^{X\to Y}``.
A facet``(\mathbf{G},\gamma)\in\mathcal{F}_d^{X \to Y}`` must satisfy:
* ``\gamma \geq \langle \mathbf{G}, \mathbf{V} \rangle`` for all vertices ``\mathbf{V} \in \mathcal{V}_d^{X \to Y}``.
* ``\gamma = \langle \mathbf{G}, \mathbf{V} \rangle`` for at least ``X(Y-1)`` affinely independent vertices ``\mathbf{V} \in \mathcal{V}_d^{X \to Y}``.

A facet inequaliity ``(\mathbf{G},\gamma)\in\mathcal{F}_d^{X \to Y}`` tightly bounds
the signaling polytope ``\mathcal{C}_d^{X\to Y}``,
therefore, if ``\gamma \ngeq \langle\mathbf{G},\mathbf{P}\rangle``, then ``\mathbf{P}\notin\mathcal{C}_d^{X \to Y}``.
Hence the inequalities ``(\mathbf{G},\gamma)\in\mathcal{F}_d^{X \to Y}`` can verify
whether a channel ``\mathbf{P}\in\mathcal{P}^{X\to Y}`` is also contained by the signaling
polytope ``\mathcal{C}_d^{X \to Y}``.
Within the context of Bell scenarios, these facets are referred to as tight Bell inequalities.
Then, the violation of a tight Bell inequality witnesses the use of more communication
than the ``d`` dit string considered by ``\mathcal{C}_d^{X \to Y}``.

### Code Example: Complete Facet Enumeration

A facet inequality is represented by the  [`BellScenario.BellGame`](https://chitambarlab.github.io/BellScenario.jl/dev/BellScenario/games/#BellScenario.BellGame)
type. Note however, that the polytope computation software represents  mmatrix ``\mathbf{G}``
with a column-major vectorization in the ``"normalized"`` subspace.

!!! note "Facet Normal Form"
    For any half-space inequality ``(\mathbf{G},\gamma)``,  ``\gamma`` and ``\mathbf{G}``
    are not unique.
    Therefore, a *normal form* must be established for facets.
    The normal form used in this work is as follows:
        1. The elements of matrix ``\mathbf{G}`` are non-negative integers and
        2. The corresponding bound ``\gamma`` is a non-negative integer.

!!! warning "Performance of Facet Computations"
    Facet computations fail to perform for large numbers of vertices and vertices
    with large dimension. The number of vertices scale exponentially with the number
    of inputs and outputs, while the dimension scales as ``X(Y-1)``.

```@example
using BellScenario

X = 3    # num inputs
Y = 3    # num outputs
d = 2    # dit signaling

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

The values of input ``x`` and output ``y`` for a signaling scenario are merely labels.
Rearranging these labels cannot change the structure of the signaling polytope.
Hence the signaling polytope is invariant under permutations of inputs and outputs[^Rosset2014].
This permutation symmetry results in a transitivity of vertices and facets.
That is, any permutation of a vertex (or facet) is also  a vertex (or facet) of ``\mathcal{C}_d^{X \to Y}``.
Furthermore, we define a vertex class (facet class) as the set of all vertices
(facets) generated by taking row/column permutations.
Hence, there exists a canonical set of generator vertices and facets whose permutations
describe the complete set of signaling polytope facets ``\mathcal{F}_d^{X \to Y}``.
Since the number of permutations scale as ``(X!)`` and ``(Y!)``, the set
of generators is dramatically reduces in the total number vertices and facets needed
to describe the polytope.

Given  the permutation symmetry of singaling polytopes, the adjacency decomposition
technique [^Christof2001] is an effective algorithm for computing the generator facets
of a convex polytope.
Key advantages of the adjacency decomposition technique include:
* The complete set of facets does not need to be stored in memory, only the generator facets.
* If not run to completion, a partial list of generator facets is obtained.
* The computation can be widely parallelized.

### Code Example: Adjacency Decomposition

The adjacency decomposition greatly reduces facet computation times and can be performed on
signaling polytopes using the [`BellScenario.LocalPolytope.adjacency_decomposition`](https://chitambarlab.github.io/BellScenario.jl/stable/LocalPolytope/adjacency_decomposition/#BellScenario.LocalPolytope.adjacency_decomposition) method.
Please refer to BellScenario.jl documentation for additional details on the arguments,
outputs, and implementation of the adjacency decomposition algorithm.

!!! note "Lexicographic Normal Form"
    The generator facet for a facet class is arbitrary.
    Therefore, we establish a lexicographic ordering for each permutation in a facet
    class.
    The facets computed by `BellScenario.LocalPolytope.adjacency_decompostion`
    are presented in their *lexicographic normal form* which is maximal in the lexicographic ordering
    of the facet class.

```@example
using BellScenario

X = 6    # num inputs
Y = 4    # num outputs
d = 2    # dit signaling

scenario = LocalSignaling(X, Y, d)

# Compute vertices in the "normalized" subspace.
vertices = LocalPolytope.vertices(scenario)

# The adjacency decomposition requires a facet to seed the algorithm.
facet_seed = BellGame([1 0 0 0 0 0;0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0], 2)

# Compute the complete set of generator facets
adj_dict = LocalPolytope.adjacency_decomposition(vertices, facet_seed, scenario)

# The generator facets are the keys of returned dictionary
for bell_game in keys(adj_dict)
    println(bell_game.β, " ≥ ", bell_game.game, "\n")
end
```

### References
[^Ziegler2012]:
    Ziegler, Günter M. Lectures on polytopes. Vol. 152. Springer Science & Business Media, 2012.

[^DallArno2017]:
    Dall’Arno, Michele, et al. "No-hypersignaling principle." Physical Review Letters 119.2 (2017): 020401.

[^Rosset2014]:
    Rosset, Denis, Jean-Daniel Bancal, and Nicolas Gisin. "Classifying 50 years of Bell inequalities." Journal of Physics A: Mathematical and Theoretical 47.42 (2014): 424022.

[^Christof2001]:
    Christof, Thomas, and Gerhard Reinelt. "Decomposition and parallelization techniques for enumerating the facets of combinatorial polytopes." International Journal of Computational Geometry & Applications 11.04 (2001): 423-437.
