export success_game, error_game, ambiguous_game

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
