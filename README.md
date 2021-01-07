# SignalingDimension.jl

*Certify the classical simulation cost of signaling systems.*

This Julia package is the software companion piece to [Testing the Classical Simulation Cost of a Quantum Channel](link to paper).

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ChitambarLab.github.io/SignalingDimension.jl/dev/)

## Features
* Methods to test the signaling dimension of a communication system.
* A catalog of Bell inequalities for witnessing signaling dimension.
* Verification of Bell inequalities.

## Overview

With the advent of quantum technology, new figures of merit are needed
to compare the performance of quantum and classical systems.

The signaling dimension quantifies the performance of a communication channel by the
minimal amount of classical communication needed to simulate the channel.

The signaling dimension of a channel makes no assumptions of the underlying physics
and is therefore, a device-independent measure applicable to quantum and classical
systems alike.

This software provides tests that certify the signaling dimension of a channel.

## Quick Start

* Install Julia: [https://julialang.org/downloads/](https://julialang.org/downloads/)
* Add the SignalingDimension.jl package (run from julia prompt):

```
julia> using Pkg; Pkg.add("SignalingDimension")
```

* Add BellScenario.jl and QBase.jl dependencies:

```
julia> using Pkg; Pkg.add("BellScenario")
julia> using Pkg; Pkg.add("QBase")
```

## Project Structure

`data/` - Computated bounds of the signaling polytope.
`docs/` - [Documentation](https://chitambarlab.github.io/SignalingDimension.jl/dev/) source code.
`src/` - Software for certifying signaling dimension.
`test/` - Unit tests for code in `src/`.
`script/` - Code for data computation and verification.

## Acknowledgements

Development of SignalingDimension.jl was made possible by the advisory of Dr. Eric Chitambar and general support from the Physics Department at the University of Illinois Urbana-Champaign. Funding was provided by NSF Award 1914440.

## Citing

To reference this work, see [`CITATION.bib`](https://github.com/ChitambarLab/SignalingDimension.jl/blob/master/CITATION.bib).

## Licensing

SignalingDimension.jl is released under the MIT License.
