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

G_K = k_guessing_game(6,3,3)

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

19
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
Ambiguous guessing games are a family of Bell inequalities for signaling polytopes [paper link](broken link).
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
    maximum_likelihood_facet( N :: Int64, d :: Int64 ) :: BellGame

Constructs the success game bound for the N-d-N polytope.

A `DomainError` is thrown if the following requirements aren't satisfied:
* `N > 2
* `N > d > 1`
"""
function maximum_likelihood_facet(N :: Int64, d :: Int64) :: BellGame
    if N ≤ 2
        throw(DomainError(N, "Input N must satisfy `N > 2`"))
    elseif d ≥ N || d < 2
        throw(DomainError(d, "Input d must satisfy `N > d > 1`"))
    end

    BellGame(Matrix{Int64}(I,N,N), d)
end

"""
    anti_guessing_facet( N :: Int64, d :: Int64, ε :: Int64 ) :: BellGame

Constructs the error game bound for the N-d-N polytope. Input `ε` sets the size
of the anti-distinguishability matrix block.

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
    ambiguous_guessing_facet( N :: Int64, d :: Int64 ) :: BellGame

Constructs the ambiguous game for the (N-1)-d-N polytope.

A `DomainError` is thrown if the inputs don't satisfy the following requirements:
* `N ≥ 4`
* `(N - 2) ≥ d ≥ 2`
"""
function ambiguous_guessing_facet(N :: Int64, d :: Int64) :: BellGame
    if !(N ≥ 4)
        throw(DomainError(N, "Input N must satisfy `N ≥ 4`"))
    elseif !(N-2 ≥ d ≥ 2)
        throw(DomainError(d, "Input d must satisfy `(N - 2) ≥ d ≥ 2`"))
    end

    succ_game = (N-d)*Matrix{Int64}(I, N-1, N-1)

    BellGame( cat(succ_game, ones(Int64, 1, N-1), dims = 1), d*(N-d))
end

"""
    k_guessing_facet( N :: Int64, d :: Int64, k :: Int64 ) :: BellGame

Constructs the generalized error game for the specified parameters:
* `N` is the number of outputs
* `d` is the signaling dimension
* `k` is the number of non-zero terms in each column

A `DomainError` is satisfied if the following requirements aren't satisfied:
* `(N - k) ≥ d ≥ 2`
* `(N - 1) ≥ k ≥ 1`
* `N ≥ 3`
"""
function k_guessing_facet(N :: Int64, d :: Int64, k :: Int64) :: BellGame
    if !(N - k ≥ d ≥ 2)
        throw(DomainError(d, "Input d must satisfy `(N - k) ≥ d ≥ 2`"))
    elseif !(N - 1 ≥ k ≥ 1)
        throw(DomainError(k, "Input k must satisfy `(N - 1) ≥ k ≥ 1`"))
    elseif !(N ≥ 3)
        throw(DomainError(N, "Input N must satisfy `N ≥ 3`"))
    end

    err_game = hcat(map( combo -> begin
        a = zeros(Int64, N)
        a[combo] .= 1
        return a
    end, combinations(1:N, k))...)

    max_score = sum(map(i -> binomial(N-i, k-1), 1:d))

    BellGame(err_game, max_score)
end

"""
    non_negativity_facet( num_outputs :: Int64, num_inputs :: Int64 ) :: BellGame

Constructs the non-negativity game for a channel with `num_outputs` and `num_inputs`.

A `DomainError` is thrown if `num_outputs` or `num_inputs` is not greater than 1.
"""
function non_negativity_facet(num_outputs :: Int64, num_inputs :: Int64) :: BellGame
    if !(num_outputs > 1)
        throw(DomainError(num_outputs, "Inputs must satisfy `num_outputs > 1`"))
    elseif !(num_inputs > 1)
        throw(DomainError(num_inputs, "Inputs must satisfy `num_inputs > 1`"))
    end

    m = zeros(Int64, num_outputs, num_inputs)
    m[1:end-1,1] .= 1

    BellGame(m, 1)
end

"""
    coarse_grained_input_ambiguous_guessing_facet(
        num_outputs :: Int64,
        d :: Int64
    ) :: BellGame

Constructs a canonical form for a input coarse-grained ambiguous game.

A `DomainError` is thrown if the inputs don't satisfy the following requirements:
* `num_outputs ≥ 4`
* `(num_outputs - 2) ≥ d ≥ 2`
"""
function coarse_grained_input_ambiguous_guessing_facet(num_outputs :: Int64, d :: Int64) :: BellGame
    G_Q = ambiguous_guessing_facet(num_outputs, d)

    game = zeros(Int64,num_outputs,num_outputs)
    game[1:num_outputs,1:end-1] = G_Q
    game[num_outputs-1,num_outputs] = game[num_outputs-1,num_outputs-1] - 1
    game[num_outputs-1,num_outputs-1] = 1


    BellGame(game, G_Q.β)
end
