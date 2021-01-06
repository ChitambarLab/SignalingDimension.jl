```@meta
CurrentModule = SignalingDimension
```

# SignalingDimension.jl

*Evaluate the classical simulation cost of signaling systems.*

This julia software package supports [Testing the Classical Simulation Cost of a Quantum Channel](link to paper).

## Features
* Methods to test the signaling dimension of a communication system.
* A catalog of Bell inequalities for witnessing signaling dimension.
* Verification of Bell inequalities.

## Overview

With the advent of quantum communication technologies, new figures of merit are needed
to compare the performance of quantum and classical technologies.
One way to quantify the value of a quantum system is by the cost to simulate the
quantum system using classical resources.

The signaling dimension quantifies the performance of a communication channel by the
smallest number of dits need to simulate the channel.
It is assumed that Alice and Bob can have shared randomness.

This software tests the signaling dimension of classical and quantum channels and,
hence, evaluates the classical simulation cost of the channel.

## Testing Signaling Dimension

This software package provides tools for estimating the signaling dimension of
quantum and classical channels.

### Exports
* estimators for classical strategy signaling dimension
* optimizers for quantum channels
* general methods classical strategies
* Complete test for qutrit signaling
* methods to expose polytope data


## Signaling Polytope Data


Computed facets of the signaling polytope are found in the [`data/`](https://github.com/ChitambarLab/SignalingDimension.jl/tree/master/data)
directory.

### Quick Adjacency Decompositions

[`data/quick_adjacency_decomposition/`](https://github.com/ChitambarLab/SignalingDimension.jl/tree/master/data/quick_adjacency_decomposition)

In this directory, the adjacency decomposition algorithm is used to find the generating facets of the signaling polytope.
The polytope computation script is restricted to run quickly on a laptop computer.

Data is provided in two formats:
* `.txt` files are human readable
* `.ieq` file format readable by BellScenario.jl.


* data for polytopes, human readable and computer readable
* scripts to collect data for polytopes like database, but filesystem should be okay
* TODO: edit these
* TODO: data printed/committed for regression in addition to viewing

## Signaling Polytope Verification:
* Polytope completeness TODO: script for proposed polytopes
* existence of facets TODO script to do this at scale
* TODO: make scripts documented or accessible to onlooker
* TODO: make a `/verification` directory that contains these scripts
* TODO: run verify scripts for >15 min with output printed/committed for regression

## User Guide/Examples
* demonstration/illustration of evaluation of signaling dimension
* use examples from paper where possible
* julia docs is ideal then notebooks





Included methods:
* compute the quantum signaling dimension of d=2 polytopes
* ML estimate of signaling dimension for any polytope
* method that accepts a set of games and checks if one is violated to find signaling dimension
* methods to construct general facets




```@index
```

```@autodocs
Modules = [SignalingDimension]
```
