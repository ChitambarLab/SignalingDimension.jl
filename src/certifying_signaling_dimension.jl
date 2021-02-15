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
    ml_score = sum(map(row -> max(row...), eachrow(P)))

    isapprox(ml_score%1,0, atol=1e-7) ? round(Int64, ml_score) : ceil(Int64, ml_score)
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
    ambiguous_lower_bound(P, 1:size(P,1))
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

    ambiguous_lower_bound(P, k:k)
end

"""
    ambiguous_lower_bound(P :: BellScenario.Strategy, k_range :: UnitRange{Int64}) :: Int64

Returns the smallest integer `d` such that `P` is contained by all ambiguous polytopes
with `k in k_range`.

In this method, the rows of channel `P` is sorted to maximize the ambiguous guessing score,
then the first `k` rows are treated as guessing rows while the remaining are treated as ambiguous.


A `DomainError` is thrown if `k_range` is not contained by the range `[1:size(P,1)]`.
"""
function ambiguous_lower_bound(P :: BellScenario.AbstractStrategy, k_range :: UnitRange{Int64}) :: Int64
    (num_rows, num_cols) = size(P)

    k_min = k_range[1]
    k_max = k_range[end]

    if !(1 ≤ k_min ≤ k_max ≤ num_rows)
        throw(DomainError(k_range, "input `k_range = k_min:k_max`  must have `1 ≤ k_min ≤  k_max ≤ num_rows`."))
    end

    # computing a raw lower bound using maximum likelihood  estimation
    P_ml_sort = sortslices(P, dims=1, by=row -> max(row...), rev=true)
    ml_min = sum(y -> max(P_ml_sort[y,:]...), 1:k_min)
    d_min = isapprox(ml_min%1, 0, atol=1e-7) ? round(Int64, ml_min) : ceil(Int64, ml_min)

    lower_bound = 1
    d = d_min
    while d <= min(num_rows, num_cols)
        P_sorted = _ambiguous_lower_bound_sort(P,d)

        ambiguous_scores = map( k -> begin
            ml_sum = sum(y -> max(P_sorted[y,:]...), 1:k)
            ambiguous_sum = (k < num_rows) ? sum(y -> sum(P_sorted[y,:]), k+1:num_rows) : 0

            ambiguous_score = ml_sum + ambiguous_sum/(num_cols - d + 1)

            ambiguous_score
        end,  k_range)

        (max_ambiguous_score, max_id) = findmax(ambiguous_scores)

        max_k = k_range[max_id]
        max_ml_sum = sum(y -> max(P_sorted[y,:]...), 1:max_k)

        d_min = isapprox(max_ml_sum%1, 0, atol=1e-7) ? round(Int64, max_ml_sum) : ceil(Int64, max_ml_sum)

        if (max_ambiguous_score < d) || (max_ambiguous_score ≈ d)
            lower_bound = d
            break
        else
            d = (d_min > d) ? d_min : d + 1
        end
    end

    lower_bound
end

"""
    _ambiguous_lower_bound_sort(P :: AbstractMatrix;  d=1::Int64) :: AbstractMatrix

Sort rows matrix ``\\mathbf{P}`` by ``\\max_{x\\in[X]} P(y|x) - \\sum_{x\\in[X]}P(y|x)/(X-d+1)``.
"""
function _ambiguous_lower_bound_sort(P :: AbstractMatrix, d::Int64)
    num_cols = size(P,2)

    max_sum_diff(row) = max(row...)- sum(row)/(num_cols - d + 1)
    sorted_rows = sortslices(P, dims=1, by=max_sum_diff, rev=true)

    sorted_rows
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
    (num_rows, num_cols) = size(P)

    d = min(num_rows, num_cols) - 1

    κ_ML = maximum_likelihood_lower_bound(P)
    upper_bound_attained = (κ_ML > d)

    # if ML estimation doesn't attain the trivial upper bound ambiguous estimation is used
    if num_rows ≥ num_cols && !upper_bound_attained
        κ_ambiguous = ambiguous_lower_bound(P, num_cols:num_rows)
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
