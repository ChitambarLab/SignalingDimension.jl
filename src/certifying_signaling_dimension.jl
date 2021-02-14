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

Uses maximum likelihood estimation where ``k`` rows are  treated as ambiguous.
For a channel ``\\mathbf{P}\\in\\mathcal{P}^{n \\to n'}``, the ambiguous
lower bound on the signaling dimension ``\\kappa(\\mathbf{P})`` is expressed,

```math
\\kappa(\\mathbf{P}) \\geq \\max_{k\\in[n']}\\max_{\\sigma\\in \\Omega_{n'}} \\sum_{y=1}^{(n'-k)} \\max_{x\\in[n]} P(\\sigma(y)|x) + \\frac{1}{n - d + 1}\\sum_{y=n'-k}^{n'}\\sum_{x\\in [n]} P(\\sigma(y)|x)
```

where ``\\Omega_{n'}`` is the set of all permutations of ``[n']``.
Note that considering all permutations of ``k`` ambiguous can be costly.
"""
function ambiguous_lower_bound(P :: BellScenario.AbstractStrategy) :: Int64
    (num_rows, num_cols) = size(P)

    lower_bounds = map(k -> ambiguous_lower_bound(P, k), 1:num_rows)

    # the largest lower bound is the lower bound of signaling dimension
    max(lower_bounds...)
end

"""
Efficiency can be improved somewhat by just running the method for a fixed number
of ambiguous rows.

    ambiguous_lower_bound(
        P :: BellScenario.AbstractStrategy,
        num_ambiguous_rows :: Int64
    ) :: Int64

A `DomainError` is thrown if `num_ambiguous_row < 1` or `num_ambiguous_rows > size(P)[1]`.
"""
function ambiguous_lower_bound(P :: BellScenario.AbstractStrategy, num_ambiguous_rows :: Int64) :: Int64
    (num_rows, num_cols) = size(P)

    if !(1 ≤ num_ambiguous_rows ≤ num_rows)
        throw(DomainError(num_ambiguous_rows, "input `num_ambiguous_rows` must be in range [1, $num_rows]."))
    end

    num_guessing_rows = num_rows - num_ambiguous_rows

    # pre-sort channel by the row sum so that the largest row sum is last.
    rows_sorted_by_sum = sortslices(P, dims=1, by=sum)

    # sort rows by max-min
    max_min_diff(row) = max(row...)-min(row...)
    rows_sorted_by_dif = sortslices(rows_sorted_by_sum, dims=1, by=max_min_diff, rev=true)

    # take k guessing guessing rows with largest max-min
    ml_sum = (num_guessing_rows > 0) ? sum(y -> max(rows_sorted_by_dif[y,:]...), 1:num_guessing_rows) : 0
    ambiguous_sum = sum(y -> sum(rows_sorted_by_dif[y,:]), num_guessing_rows+1:num_rows)

    # d > ml_sum
    d_min = ceil(ml_sum)

    lower_bound = 1
    for d in d_min:min(size(P)...)
        # violation occurs, signaling dimension is greater than d
        score = ml_sum + ambiguous_sum/(num_cols - d + 1)

        if (score < d) || (score ≈ d)
            println(score)
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
