"""
The advent of quantum technology requires new figures of merit to compare the performance
of quantum and classical systems.
The signaling dimension quantifies the classical
simulation cost of black-box devices.
That is, it specifies the minimum amount of noiseless, classical communication
needed to exactly simulate the input-output statistics of the device in question.
The signaling dimension is discussed in greater detail in the Background section
of this documentation.

## Features:
* Tools to compute signaling correlations and polytopes (see [Signaling Correlations](@ref) and [Signaling Polytopes](@ref)).
* A catalog of Bell inequalities for witnessing signaling dimension (see [Bell Inequalities](@ref)).
* Methods to certify the signaling dimension of signaling systems (see [Certifying Signaling Dimension](@ref)).
"""
module SignalingDimension

using LinearAlgebra
using Combinatorics
using BellScenario

include("./bell_inequalities.jl")
include("./affinely_independent_enumerations.jl")
include("./certifying_signaling_dimension.jl")

end
