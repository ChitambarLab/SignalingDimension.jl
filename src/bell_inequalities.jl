export k_guessing_game, ambiguous_guessing_game

export maximum_likelihood_facet, anti_guessing_facet, ambiguous_guessing_facet, k_guessing_facet, non_negativity_facet
export coarse_grained_input_ambiguous_guessing_facet

"""
The ``k``-guessing game is a general family of Bell inequalities for signaling polytopes.
For any integer ``k\\in[0,Y]`` a ``k``-guessing game Bell inequality
``(\\mathbf{G}_{\\text{K}},\\gamma_{\\text{K}})``
bounds the signaling polytope ``\\mathcal{C}_d^{\\binom{Y}{k}\\to Y }``.
The columns of matrix ``\\mathbf{G}_{\\text{K}}\\in \\mathbf{R}^{Y \\times \\binom{Y}{k}}``
consist of all ``\\binom{Y}{k}`` ways to arrange ``k`` unit elements and ``(Y-k)``
null elements.
Hence each input ``x\\in[X]`` corresponds to a unique set of ``k`` correct
answers out of ``Y`` possible answers.
The upper bound is  ``\\gamma_{\\text{K}} = \\binom{Y}{k} - \\binom{Y-d}{k}``.

A ``k``-guessing game Bell inequality is constructed with the `k_guessing_game`
method,

```julia
k_guessing_game(Y :: Int64, d :: Int64, k :: Int64) :: BellGame
```

Parameters:
* `Y` - The number of outputs
* `d` - The signaling dimension
* `k` - The number of unit elements in each column. Must satisfy `Y ≥ k ≥ 0`.

For example,

```jldoctest k_guessing_game
using SignalingDimension

G_K = k_guessing_game(6,2,3)

# output

6×20 BellScenario.BellGame:
 1  1  1  1  1  1  1  1  1  1  0  0  0  0  0  0  0  0  0  0
 1  1  1  1  0  0  0  0  0  0  1  1  1  1  1  1  0  0  0  0
 1  0  0  0  1  1  1  0  0  0  1  1  1  0  0  0  1  1  1  0
 0  1  0  0  1  0  0  1  1  0  1  0  0  1  1  0  1  1  0  1
 0  0  1  0  0  1  0  1  0  1  0  1  0  1  0  1  1  0  1  1
 0  0  0  1  0  0  1  0  1  1  0  0  1  0  1  1  0  1  1  1
```

The upper bound is then

```jldoctest k_guessing_game
G_K.β

# output

16
```

The `k_guessing_game` can alternatively take a `BellScenario.LocalSignaling(X, Y, d)` scenario as input.

```julia
k_guessing_game( scenario :: LocalSignaling, k :: Int64 ) :: BellGame
```

A `DomainError` is thrown if `scenario.X !=  binomial(scenario.Y, k)`.
"""
function k_guessing_game(scenario :: LocalSignaling, k :: Int64) :: BellGame
    if scenario.X != binomial(scenario.Y, k)
        throw(DomainError(scenario.X, "Number of inputs `X` must be `binomial(Y, k)`."))
    end

    k_guessing_game(scenario.Y, scenario.d, k)
end
function k_guessing_game(Y :: Int64, d :: Int64, k :: Int64) :: BellGame
    if !(Y ≥ k ≥ 0)
        throw(DomainError(k, "Input k must satisfy `Y  ≥ k ≥ 0`"))
    end

    game = hcat(map( combo -> begin
        a = zeros(Int64, Y)
        a[combo] .= 1
        return a
    end, combinations(1:Y, k))...)

    max_score = binomial(Y,k) - binomial(Y-d,k) #sum(map(i -> binomial(Y-i, k-1), 1:d))

    BellGame(game, max_score)
end

"""
Ambiguous guessing games are a family of Bell inequalities for signaling polytopes.
An ambiguous guessing game, denoted by ``(\\mathbf{G}_{\\text{Q}},\\gamma_{\\text{Q}})``, bounds the
signaling polytope ``\\mathcal{C}_d^{X \\to Y}``.
The ``Y \\times X`` matrix ``\\mathbf{G}_{\\text{Q}}`` is described as having two types of rows:
* *Guessing Rows*: one column contains a non-zero element of value ``(X - d + 1)``;
* *Ambiguous Rows*: each column contains a ``1``.

For any integer ``k \\in [0,Y]`` An ambiguous guessing game is defined to have ``k`` guessing rows
and ``(Y-k)`` ammbiguous rows.
The upper bound on the  ambiguous guessing game Bell inequality is then ``\\gamma_{\\text{Q}} = d(X-d+1)``.

The `ambiguous_guessing_game` method constructs an ambiguous guessing game Bell inequality with `k`
guessing rows.

```julia
ambiguous_guessing_game(X::Int64, Y::Int64, d::Int64, k::Int64) :: BellGame
```

Parameters:
* `X` - The number of inputs
* `Y` - The number of outputs
* `d` - The signaling dimension
* `k` - Th number of guessing rows. Must satisfy `Y ≥ k ≥ 0`.

For example, the following constructed ambiguous guessing game has four guessing
rows and  3 ambiguous rows.

```jldoctest ambiguous_guessing_game
using SignalingDimension

(X, Y, d) = (6, 7, 3)

k = 4        # num guessing rows

G_Q = ambiguous_guessing_game(X, Y, d, k)

# output

7×6 BellScenario.BellGame:
 4  0  0  0  0  0
 0  4  0  0  0  0
 0  0  4  0  0  0
 0  0  0  4  0  0
 1  1  1  1  1  1
 1  1  1  1  1  1
 1  1  1  1  1  1
```

```jldoctest ambiguous_guessing_game
G_Q.β

# output

12
```

Alternatively, the `ambiguous_guessing_game` can accept a `BellScenario.LocalSignaling(X, Y, d)` scenario.

```julia
ambiguous_guessing_game(scenario :: LocalSignaling, k :: Int64) :: BellGame
```
"""
function ambiguous_guessing_game(scenario :: LocalSignaling, k :: Int64) :: BellGame
    ambiguous_guessing_game(scenario.X,scenario.Y,scenario.d,k)
end
function ambiguous_guessing_game(X::Int64, Y::Int64, d::Int64, k::Int64) :: BellGame
    if !(Y ≥ k ≥ 0)
        throw(DomainError(k, "num guessing rows `k` should satisfy `Y ≥ k ≥ 0`."))
    elseif !(min(X,Y) ≥ d ≥ 1)
        throw(DomainError(d, "`scenario.d` should satisfy `min(X, Y) ≥ d ≥ 1`."))
    end

    ambiguous_scalar = (X - d + 1)

    γ = d * ambiguous_scalar
    G = zeros(Int64, Y, X)

    for y in 1:k
        if y ≤ X
            G[y,y] = ambiguous_scalar
        else
            G[y,X] = ambiguous_scalar
        end
    end

    ambiguous_row = ones(Int64, X)
    for y in (k+1):Y
        G[y,:] =  ambiguous_row
    end

    BellGame(G, γ)
end

"""
The maximum likelihood facet ``(\\mathbf{G}_{\\text{ML}},d)`` tightly bounds the
``\\mathcal{C}_d^{N \\to N}``  signaling polytope for ``N > d > 1``.
The matrix ``\\mathbf{G}_{\\text{ML}}`` is a ``(k=1)``-guessing game (see [`k_guessing_game`](@ref)),
hence, ``\\mathbf{G}_{\\text{ML}}=\\mathbb{I}_{N}`` the ``N\\times N`` identity matrix.
The upper bound is  ``d \\geq \\langle \\mathbf{G}_{\\text{ML}}, \\mathbf{P}\\rangle``
for any channel ``\\mathbf{P}\\in\\mathcal{C}_d^{N \\to N}``.

```julia
maximum_likelihood_facet( N :: Int64, d :: Int64 ) :: BellGame
```

Construct the maximum likelihood facet for the ``\\mathcal{C}_d^{N \\to N}``
signaling polytope. Note that `N` specifies the number of inputs and outputs.
For example,

```jldoctest maximum_likelihood_facet
using SignalingDimension

N = 4    # number of inputs and outputs
d = 2    # bit signaling

G_ML = maximum_likelihood_facet(N, d)

# output

4×4 BellScenario.BellGame:
 1  0  0  0
 0  1  0  0
 0  0  1  0
 0  0  0  1
```

```jldoctest maximum_likelihood_facet
G_ML.β   # the upper bound

# output

2
```

A `DomainError` is thrown if the following requirements aren't satisfied:
* `N > 2
* `N > d > 1`
"""
function maximum_likelihood_facet(N :: Int64, d :: Int64) :: BellGame
    if N ≤ 2
        throw(DomainError(N, "Input N must satisfy `N > 2`"))
    elseif !(N > d > 1)
        throw(DomainError(d, "Input d must satisfy `N > d > 1`"))
    end

    BellGame(Matrix{Int64}(I,N,N), d)
end

"""
    anti_guessing_facet( N :: Int64, d :: Int64, ε :: Int64 ) :: BellGame

Constructs the anti-guessing facet of the ``\\mathcal{C}_d^{N \\to N}`` signaling polytope.
Input `ε` sets the size of the ``(k=N-1)``-guessing game block while the remaining
unit elements are arranged along the diagonal.
The upper bound of the anti-guessing game Bell inequality is ``\\gamma = \\varepsilon + d - 2``.
For example,

```jldoctest anti_guessing_game
using SignalingDimension

N = 6    # number of inputs and outputs
d = 2    # dit signaling
ε = 4    # anti-guessing block size

G_A = anti_guessing_facet(N,d,ε)

# output

6×6 BellScenario.BellGame:
 0  1  1  1  0  0
 1  0  1  1  0  0
 1  1  0  1  0  0
 1  1  1  0  0  0
 0  0  0  0  1  0
 0  0  0  0  0  1
```
```jldoctest anti_guessing_game
G_A.β    # upper bound

# output

4
```

Note in the above example that

A `DomainError` is thrown if the following requirements aren't satisfied:
* `N ≥ 4`
* `(N - 2) ≥ d ≥ 2`
* `(N - d + 1) ≥ ε ≥ 3`
"""
function anti_guessing_facet(N :: Int64, d :: Int64, ε :: Int64) :: BellGame
    if !(N ≥ 4)
        throw(DomainError(N, "Input N must satisfy `N ≥ 4`"))
    elseif !(N-2 ≥ d ≥ 2)
        throw(DomainError(d, "Input d must satisfy `(N - 2) ≥ d ≥ 2`"))
    elseif !(N-d+1 ≥ ε ≥ 3)
        throw(DomainError(ε, "Input ε must satisfy `(N - d + 1) ≥ ε ≥ 3`"))
    end

    err_game = ones(Int64, ε, ε) - I
    succ_game = Matrix{Int64}(I, (N-ε),(N-ε))

    BellGame(cat(
        cat(err_game, zeros(Int64, ε, (N-ε)), dims=2),
        cat(zeros(Int64, (N-ε), ε), succ_game, dims=2),
        dims = 1
    ), ε + d - 2)
end

"""
    ambiguous_guessing_facet( Y :: Int64, d :: Int64 ) :: BellGame

Constructs the ambiguous guessing facet for the ``\\mathcal{C}_d^{(Y-1)\\to Y} polytope.
This is a special case of the [`ambiguous_guessing_game`](@ref) where `Y = X - 1`.
For example,

```jldoctest ambiguous_guessing_facet
using SignalingDimension

Y = 5
d = 3

G_Q = ambiguous_guessing_facet(Y, d)

# output

5×4 BellScenario.BellGame:
 2  0  0  0
 0  2  0  0
 0  0  2  0
 0  0  0  2
 1  1  1  1
```
```jldoctest ambiguous_guessing_facet
G_Q.β

# output

6
```

A `DomainError` is thrown if the inputs don't satisfy the following requirements:
* `Y ≥ 4`
* `(Y - 2) ≥ d ≥ 2`
"""
function ambiguous_guessing_facet(Y :: Int64, d :: Int64) :: BellGame
    if !(Y ≥ 4)
        throw(DomainError(Y, "Input Y must satisfy `Y ≥ 4`"))
    elseif !(Y-2 ≥ d ≥ 2)
        throw(DomainError(d, "Input d must satisfy `(Y - 2) ≥ d ≥ 2`"))
    end

    succ_game = (Y-d)*Matrix{Int64}(I, Y-1, Y-1)

    BellGame( cat(succ_game, ones(Int64, 1, Y-1), dims = 1), d*(Y-d))
end

"""
    k_guessing_facet( Y :: Int64, d :: Int64, k :: Int64 ) :: BellGame

Constructs the ``k``-guessing facet for the ``\\mathcal{C}_d^{\\binom{Y}{k}\\to Y}``
signaling polytope. A ``k``-guessing game is tight when ``Y = d + k``.
Note that `k` is the number of unit elements in each column.

A `DomainError` is satisfied if the following requirements aren't satisfied:
* `Y == k + d`
* `Y ≥ 3`
"""
function k_guessing_facet(Y :: Int64, d :: Int64, k :: Int64) :: BellGame
    if Y != k + d
        throw(DomainError(d, "Input `d` must satisfy `Y == k + d`."))
    elseif !(Y ≥ 3)
        throw(DomainError(Y, "Input N must satisfy `Y ≥ 3`"))
    end

    k_guessing_game(Y, d, k)
end

"""
A non-negativity facet reflects the fact that ``P(y|x) \\geq 0``. These facets
bound all signaling polytopes.

    non_negativity_facet( X :: Int64, Y :: Int64 ) :: BellGame

Constructs the non-negativity game for a channel with `X` inputs and `Y` outputs.
For example

```jldoctest non_negativity_facet
using SignalingDimension

G = non_negativity_facet(3, 4)

# output

4×3 BellScenario.BellGame:
 1  0  0
 1  0  0
 1  0  0
 0  0  0
```
```jldoctest non_negativity_facet
G.β

# output

1
```

A `DomainError` is thrown if `X` or `Y` is not greater than 1.
"""
function non_negativity_facet(X :: Int64, Y :: Int64) :: BellGame
    if !(Y > 1)
        throw(DomainError(Y, "Inputs must satisfy `Y > 1`"))
    elseif !(X > 1)
        throw(DomainError(X, "Inputs must satisfy `X > 1`"))
    end

    m = zeros(Int64, Y, X)
    m[1:end-1,1] .= 1

    BellGame(m, 1)
end

"""
    coarse_grained_input_ambiguous_guessing_facet(
        Y :: Int64,
        d :: Int64
    ) :: BellGame

Constructs a canonical form for a input coarse-grained ambiguous game.
For example

```jldoctest
using SignalingDimension

Y = 4
d = 2

G = coarse_grained_input_ambiguous_guessing_facet(Y, d)

# output

4×4 BellScenario.BellGame:
 2  0  0  0
 0  2  0  0
 0  0  1  1
 1  1  1  0
```

A `DomainError` is thrown if the inputs don't satisfy the following requirements:
* `Y ≥ 4`
* `(Y - 2) ≥ d ≥ 2`
"""
function coarse_grained_input_ambiguous_guessing_facet(Y :: Int64, d :: Int64) :: BellGame
    G_Q = ambiguous_guessing_facet(Y, d)

    game = zeros(Int64,Y,Y)
    game[1:Y,1:end-1] = G_Q
    game[Y-1,Y] = game[Y-1,Y-1] - 1
    game[Y-1,Y-1] = 1

    BellGame(game, G_Q.β)
end
