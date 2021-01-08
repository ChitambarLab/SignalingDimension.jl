export maximum_likelihood_lower_bound

"""
    maximum_likelihood_lower_bound( P :: BellScenario.AbstractStrategy ) :: Int64

Uses maximum likelihood estimation to compute the lower bound of the signaling dimension.
For a channel ``\\mathbf{P}\\in\\mathcal{P}^{n \\to n'}``, the maximum likelihood
lower bound on the signaling dimension ``\\kappa(\\mathbf{P})`` is expressed,

```math
\\kappa(\\mathbf{P}) \\geq \\sum_{y\\in[n']} \\max_{x\\in[n]} P(y|x).
```
"""
function maximum_likelihood_lower_bound(P :: BellScenario.AbstractStrategy) :: Int64
    ceil(sum(map(row -> max(row...), eachrow(P))))
end
