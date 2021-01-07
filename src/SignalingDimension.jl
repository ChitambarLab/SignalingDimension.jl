"""
## Overview

With the advent of quantum technology, new figures of merit are needed
to compare the performance of quantum and classical systems.

The signaling dimension quantifies the performance of a communication channel by the
minimal amount of classical communication needed to simulate the channel.

The signaling dimension of a channel makes no assumptions of the underlying physics
and is therefore, a device-independent measure applicable to quantum and classical
systems alike.

This software provides tests that certify the signaling dimension of a channel.

## Features
* Methods to test the signaling dimension of a communication system.
* A catalog of Bell inequalities for witnessing signaling dimension.
* Verification of Bell inequalities.
"""
module SignalingDimension

using LinearAlgebra
using Combinatorics
using BellScenario

include("./facets.jl")
include("./affinely_independent_enumerations.jl")

end
