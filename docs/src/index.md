```@meta
CurrentModule = SignalingDimension
```

# SignalingDimension.jl

*Certify the classical simulation cost of black-box systems.*

This Julia software package is the companion piece to [Certifying the Classical Simulation Cost of a Quantum Channel](https://arxiv.org/abs/2102.12543).

## Package Overview

```@docs
SignalingDimension
```

## Signaling Polytope Data

Our computed facets of the signaling polytope are found in the [`data/`](https://github.com/ChitambarLab/SignalingDimension.jl/tree/master/data)
directory. Please review the [Computed Facets](@ref) section for details regarding
individual data sets.

## Facet Verifications

This work provides scripts that verifies the tightness of the Bell inequalities
described in the [Bell Inequalities](@ref) section.
These scripts and their results are found in the [`script/facet_verifications/`](https://github.com/ChitambarLab/SignalingDimension.jl/tree/master/script/facet_verifications)
directory.
Please refer to the [Verification of Theoretical Facets](@ref) section for more details.

## Quick Start

* Install Julia: [https://julialang.org/downloads/](https://julialang.org/downloads/)
* Add the SignalingDimension.jl package (run from julia prompt):

```julia
julia> using Pkg; Pkg.add("SignalingDimension")
```

* To run the examples, add the [BellScenario.jl](https://github.com/ChitambarLab/BellScenario.jl) and [QBase.jl](https://github.com/ChitambarLab/QBase.jl) dependencies:

```julia
julia> using Pkg; Pkg.add("BellScenario")
julia> using Pkg; Pkg.add("QBase")
```

## Contents

```@contents
Pages = [
    "background/signaling_correlations.md",
    "background/signaling_polytopes.md",
    "background/signaling_dimension.md",
    "bell_inequalities.md",
    "certifying_signaling_dimension.md",
    "script_utilities.md",
]
Depth = 2
```

## Citing

To reference this work, see [`CITATION.bib`](https://github.com/ChitambarLab/SignalingDimension.jl/blob/master/CITATION.bib).

## Licensing

SignalingDimension.jl is released under the MIT License.

## Acknowledgements

Development of SignalingDimension.jl was made possible by the advisory of Dr. Eric Chitambar and general support from the Physics Department at the University of Illinois Urbana-Champaign. Funding was provided by NSF Award 1914440.
