export maximum_likelihood_lower_bound, ambiguous_lower_bound

export upper_bound, trivial_upper_bound, attains_trivial_upper_bound

"""
    maximum_likelihood_lower_bound( P :: BellScenario.AbstractStrategy ) :: Int64

Uses maximum likelihood estimation to efficiently compute the lower bound of the signaling dimension.
For a channel ``\\mathbf{P}\\in\\mathcal{P}^{n \\to n'}``, the maximum likelihood
lower bound on the signaling dimension ``\\kappa(\\mathbf{P})`` is expressed,

```math
\\kappa(\\mathbf{P}) \\geq \\sum_{y\\in[n']} \\max_{x\\in[n]} P(y|x).
```

Since the maximum likelihood facet is present on all signaling polytopes, a lower
bound can always be found with efficiency.
"""
function maximum_likelihood_lower_bound(P :: BellScenario.AbstractStrategy) :: Int64
    ceil(sum(map(row -> max(row...), eachrow(P))))
end

"""
    ambiguous_lower_bound(P :: BellScenario.AbstractStrategy) :: Int64

Returns the lower bound on the signaling dimension ``\\kappa(\\mathbf{P})`` as
witnessed by facets of the ambiguous polytope ``\\mathcal{A}_{k,d}^{X \\to Y}``
with ``k`` guessing rows and ``d`` messages of classical communication.
That is, this method  computes the smallest ``d`` such that
``\\mathbf{P}\\in\\mathcal{A}_{k,d}^{X\\to Y}`` for all ``k``.

Formally, the  lower bound is expressed as the RHS of the following inequality

```math
\\kappa(\\mathbf{P}) \\geq \\max_{k\\in[Y]}\\max_{\\sigma\\in \\Omega_{Y}} \\sum_{y=1}^{(Y-k)} \\max_{x\\in[X]} P(\\sigma(y)|x) + \\frac{1}{X - d + 1}\\sum_{y=Y-k+1}^{Y}\\sum_{x\\in [n]} P(\\sigma(y)|x)
```

where ``\\Omega_{Y}`` is the set of all permutations of ``[Y]``.
Note that considering all permutations of ``k`` guessing rows can be costly, however,
the performance is improved by sorting the rows of ``\\mathbf{P}`` by increasing
row sum and max-min difference.
A priori, it is not clear whether the row sum or max-min difference is the primary
ordering, therefore, this method checks both.
"""
function ambiguous_lower_bound(P :: BellScenario.AbstractStrategy) :: Int64
    (num_rows, num_cols) = size(P)

    sorted_P_by_row_sum = _ambiguous_lower_bound_pre_sort_primary_row_sum(P)
    sorted_P_by_max_min_diff = _ambiguous_lower_bound_pre_sort_primary_max_min_diff(P)

    ordering_max(k) = max(
        _ambiguous_lower_bound(sorted_P_by_row_sum, k),
        _ambiguous_lower_bound(sorted_P_by_max_min_diff, k)
    )

    lower_bounds = map(ordering_max, 1:num_rows)

    # the largest lower bound is the lower bound of signaling dimension
    max(lower_bounds...)
end

"""
    ambiguous_lower_bound(
        P :: BellScenario.AbstractStrategy,
        k :: Int64
    ) :: Int64

Finds the ambiguous lower bound on ``\\kappa(\\mathbf{P})`` for fixed ``k``.
That is, returns the smallest ``d`` such that ``\\mathbf{P}\\in\\mathcal{A}_{k,d}^{X\\to Y}``,
where ``\\mathcal{A}_{k,d}^{X\\to Y}`` is the ambiguous polytope with for ``k`` guessing rows.

* `P` - Channel ``\\mathbf{P}\\in\\mathcal{P}^{X\\to Y}``, a column stochastic matrix.
* `k` - The number of guessing rows.

A `DomainError` is thrown if `k < 1` or `k > size(P)[1]` (number of rows in `P`).
"""
function ambiguous_lower_bound(P :: BellScenario.AbstractStrategy, k :: Int64) :: Int64
    (num_rows, num_cols) = size(P)

    if !(1 ≤ k ≤ num_rows)
        throw(DomainError(k, "input `k` must be in range [1, $num_rows]."))
    end

    sorted_P_by_row_sum = _ambiguous_lower_bound_pre_sort_primary_row_sum(P)
    sorted_P_by_max_min_diff = _ambiguous_lower_bound_pre_sort_primary_max_min_diff(P)

    max(
        _ambiguous_lower_bound(sorted_P_by_row_sum, k),
        _ambiguous_lower_bound(sorted_P_by_max_min_diff,k)
    )
end

"""
    _ambiguous_lower_bound_pre_sort_primary_row_sum(P :: AbstractMatrix) :: AbstractMatrix

Sort matrix `P` by
1. (Primary): The sum of the row.
2. (Secondary): The difference between the row maximum and minimum.
"""
function _ambiguous_lower_bound_pre_sort_primary_row_sum(P :: AbstractMatrix)
    # pre-sort rows by (max - min)
    max_min_diff(row) = max(row...)-min(row...)
    rows_sorted_by_diff = sortslices(P, dims=1, by=max_min_diff, rev=true)

    # sort channel by the row sum so that the largest row sum is last.
    rows_sorted_by_sum = sortslices(rows_sorted_by_diff, dims=1, by=sum)

    rows_sorted_by_sum
end

"""
    _ambiguous_lower_bound_pre_sort_primary_max_min_diff(P :: AbstractMatrix) :: AbstractMatrix

Sort matrix `P` by
1. (Primary): The difference between the row maximum and minimum.
2. (Secondary): The sum of the row.
"""
function _ambiguous_lower_bound_pre_sort_primary_max_min_diff(P :: AbstractMatrix)
    # pre-sort channel by the row sum so that the largest row sum is last.
    rows_sorted_by_sum = sortslices(P, dims=1, by=sum)

    # sort rows by (max - min)
    max_min_diff(row) = max(row...)-min(row...)
    rows_sorted_by_diff = sortslices(rows_sorted_by_sum, dims=1, by=max_min_diff, rev=true)

    rows_sorted_by_diff
end

"""
    _ambiguous_lower_bound(P :: AbstractMatrix, k :: Int64) :: Int64

Returns the smallest integer `d` such that `P` is contained by the ambiguous guessing
game with the first `k` rows as guessing rows and the remaining as ambiguous.

* `P` - column stochastic matrix.
* `k` - number of guessing rows to consider.
"""
function _ambiguous_lower_bound(P :: AbstractMatrix, k :: Int64) :: Int64
    (num_rows,num_cols) = size(P)

    # take k guessing guessing rows with largest max-min
    ml_sum = (k > 0) ? sum(y -> max(P[y,:]...), 1:k) : 0
    ambiguous_sum = (k < num_rows) ? sum(y -> sum(P[y,:]), k+1:num_rows) : 0

    # d > ml_sum
    d_min = ceil(ml_sum)

    # Increment d until no violation occurs.
    # if violation occurs then signaling dimension is greater than d
    lower_bound = 1
    for d in d_min:min(size(P)...)
        score = ml_sum + ambiguous_sum/(num_cols - d + 1)

        if (score < d) || (score ≈ d)
            lower_bound = d
            break
        end
    end

    lower_bound
end

"""
    trivial_upper_bound(P :: BellScenario.AbstractStrategy) :: Int64

The signaling dimension of channel cannot exceed the number of inputs or outputs.
Therefore, the trivial upper bound for the signaling dimension of a channel
``\\mathbf{P}\\in\\mathcal{P}^{n \\to n'}`` is simply,

```
\\kappa(\\mathbf{P}) \\leq \\min\\{n,n'\\}.
```
"""
function trivial_upper_bound(P :: BellScenario.AbstractStrategy) :: Int64
    min(size(P)...)
end

"""
    attains_trivial_upper_bound(P :: BellScenario.Strategy) :: Bool

Returns `true` if the channel `P` attains the [`trivial_upper_bound`](@ref).
This method relies on the fact:
* When ``d = n - 1``, the signaling polytope ``\\mathcal{C}_d^{n  \\to n'}`` is only
    bound by maximum likelihood facets.
* When ``d = n' - 1``, the  signaling polytope ``\\mathcal{C}_d^{n \\to n'}`` is only
    bound by maximum likelihood and ambiguous facets.
"""
function attains_trivial_upper_bound(P :: BellScenario.AbstractStrategy) :: Bool
    (num_out, num_in) = size(P)

    d = min(num_out, num_in) - 1

    κ_ML = maximum_likelihood_lower_bound(P)
    upper_bound_attained = (κ_ML > d)

    # if ML estimation doesn't attain the trivial upper bound ambiguous estimation is used
    if num_out ≥ num_in && !upper_bound_attained
        κ_ambiguous = ambiguous_lower_bound(P)
        upper_bound_attained = (κ_ambiguous > d)
    end

    upper_bound_attained
end

"""
    upper_bound(P :: BellScenario.AbstractStrategy) :: Int64

Returns an upper bound for the signaling dimension of a channel `P`.
If [`attains_trivial_upper_bound`](@ref) returns `true`, then this upper bound
is tight and designates the signaling dimension.
Otherwise, a loose upper bound is provided.
A lower bound can be found with the [`maximum_likelihood_lower_bound`](@ref) and
[`ambiguous_lower_bound`](@ref) methods.
"""
function upper_bound(P :: BellScenario.AbstractStrategy) :: Int64
    trivial_bound = trivial_upper_bound(P)
    attains_trivial_upper_bound(P) ? trivial_bound : trivial_bound - 1
end
