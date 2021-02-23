"""
The advent of quantum technology requires new figures of merit to compare the performance
of quantum and classical systems.
Such metrics should be device-independent meaning that they only depend on the statistics
of a system while making no assumptions about the physics applied within the system.
Device-independent metrics are important because they allow an observer to learn
about the inner-workings of uncharacterized or untrusted devices without having
to investigate the hardware or software used within the device.

The signaling dimension is a device-independent metric that quantifies the classical
simulation cost of a device.
That is, it specifies the minimum amount of noiseless, classical communication
needed to exactly simulate the input-output statistics of the device in question
when an unlimited amount of randomness is shared between the transmitter and receiver.
The signaling dimension is discussed in greater detail in the [Signaling Dimension](@ref)
section while the supporting definitions and notation are outlined in  the [Signaling Correlations](@ref)
section.

The signaling dimension is significant because it applies to computation,
communication, and memory task.
In fact, the signaling dimension describes the classical simulation cost of any
physical system with a classical input and a classical output.
Hence, it is a versatile metric that can be used to compare quantum and classical
resources.


## Features:
* Tools to compute signaling correlations (see [Signaling Correlations](@ref)).
* Tools to assist signaling polytope computations (see [Signaling Polytopes](@ref)).
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
