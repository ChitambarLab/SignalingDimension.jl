export success_game, error_game, ambiguous_game, generalized_error_game, non_negativity_game
export coarse_grained_input_ambiguous_game

"""
    success_game( N :: Int64, d :: Int64 ) :: BellGame

Constructs the success game bound for the N-d-N polytope.

A `DomainError` is thrown if the following requirements aren't satisfied:
* `N > 2
* `N > d > 1`
"""
function success_game(N :: Int64, d :: Int64) :: BellGame
    if N ≤ 2
        throw(DomainError(N, "Input N must satisfy `N > 2`"))
    elseif d ≥ N || d < 2
        throw(DomainError(d, "Input d must satisfy `N > d > 1`"))
    end

    BellGame(Matrix{Int64}(I,N,N), d)
end

"""
    error_game( N :: Int64, d :: Int64, ε :: Int64 ) :: BellGame

Constructs the error game bound for the N-d-N polytope. Input `ε` sets the size
of the anti-distinguishability matrix block.

A `DomainError` is thrown if the following requirements aren't satisfied:
* `N ≥ 4`
* `(N - 2) ≥ d ≥ 2`
* `(N - d + 1) ≥ ε ≥ 3`
"""
function error_game(N :: Int64, d :: Int64, ε :: Int64) :: BellGame
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
    ambiguous_game( N :: Int64, d :: Int64 ) :: BellGame

Constructs the ambiguous game for the (N-1)-d-N polytope.

A `DomainError` is thrown if the inputs don't satisfy the following requirements:
* `N ≥ 4`
* `(N - 2) ≥ d ≥ 2`
"""
function ambiguous_game(N :: Int64, d :: Int64) :: BellGame
    if !(N ≥ 4)
        throw(DomainError(N, "Input N must satisfy `N ≥ 4`"))
    elseif !(N-2 ≥ d ≥ 2)
        throw(DomainError(d, "Input d must satisfy `(N - 2) ≥ d ≥ 2`"))
    end

    succ_game = (N-d)*Matrix{Int64}(I, N-1, N-1)

    BellGame( cat(succ_game, ones(Int64, 1, N-1), dims = 1), d*(N-d))
end

"""
    generalized_error_game( N :: Int64, d :: Int64, k :: Int64 ) :: BellGame

Constructs the generalized error game for the specified parameters:
* `N` is the number of outputs
* `d` is the signaling dimension
* `k` is the number of non-zero terms in each column

A `DomainError` is satisfied if the following requirements aren't satisfied:
* `(N - k) ≥ d ≥ 2`
* `(N - 1) ≥ k ≥ 1`
* `N ≥ 3`
"""
function generalized_error_game(N :: Int64, d :: Int64, k :: Int64) :: BellGame
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
    non_negativity_game( num_outputs :: Int64, num_inputs :: Int64 ) :: BellGame

Constructs the non-negativity game for a channel with `num_outputs` and `num_inputs`.

A `DomainError` is thrown if `num_outputs` or `num_inputs` is not greater than 1.
"""
function non_negativity_game(num_outputs :: Int64, num_inputs :: Int64) :: BellGame
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
    coarse_grained_input_ambiguous_game(
        num_outputs :: Int64,
        d :: Int64
    ) :: BellGame

Constructs a canonical form for a input coarse-grained ambiguous game.

A `DomainError` is thrown if the inputs don't satisfy the following requirements:
* `num_outputs ≥ 4`
* `(num_outputs - 2) ≥ d ≥ 2`
"""
function coarse_grained_input_ambiguous_game(num_outputs :: Int64, d :: Int64) :: BellGame
    G_Q = ambiguous_game(num_outputs, d)

    game = zeros(Int64,num_outputs,num_outputs)
    game[1:num_outputs,1:end-1] = G_Q
    game[num_outputs-1,num_outputs] = game[num_outputs-1,num_outputs-1] - 1
    game[num_outputs-1,num_outputs-1] = 1


    BellGame(game, G_Q.β)
end