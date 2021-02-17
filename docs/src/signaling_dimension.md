# Signaling Dimension

The signaling dimension specifies the amount of classical communication needed
to exactly simulate a channel provided an unlimited amount of shared randomness.  
The signaling dimension was originally introduced for generalized probability theories [^DallArno2017],
while a similar quantity has also been discussed without the use of shared randomness [^Heinosaari2020].
As it turns out, shared randomness is an important resource for simulating quantum
systems as there exist qubit system that cannot be simulated by a single bit of
classical communication, but require shared randomness to perform the simulation [^deVicente2017].

!!! note "Note:"
    SignalingDimension.jl considers the signaling dimension of signaling
    devices that have classical inputs and outputs (see [Signaling Correlations](@ref)).
    The signaling dimension can be certified for quantum and
    classical signaling systems alike.

## Definition

The signaling dimension is denoted by ``\kappa(\cdot)`` and can be defined for
a fixed signaling device and general channels alike.

1. Given the signaling correlations ``\mathbf{P}\in\mathcal{P}^{X \to Y}`` the signaling dimension ``\kappa(\mathbf{P})`` is defined as the smallest integer ``d`` such that ``\mathbf{P} \in \mathcal{C}_d^{X \to Y}``.
2. Given a quantum channel ``\mathcal{N}`` the signaling dimension ``\kappa(\mathcal{N})`` is the smallest integer ``d`` such that ``\mathcal{Q}_{\mathcal{N}}^{X\to Y}\subset\mathcal{C}_d^{X\to Y}`` for any choice of numbers of classical inputs ``X`` and outputs ``Y``.

Since the  signaling dimension is defined with respect to the observed signaling
correlations, it requires no assumptions to be made about the communication process.
Hence the signaling dimension is a device-independent metric.
The signaling dimension of quantum channels is elaborated upon in the work [ref to paper](broken link).

## Classical Simulation Cost

The signaling dimension specifies the minimum amount of classical communication ``d``
needed to simulate a quantum channel ``\mathcal{N}`` as simply ``d=\kappa(\mathcal{N})``.
*A priori*, there is little indication of whether classical dit communication with shared randomness
is capable of simulating qudit communication. However, this is the case indeed.
A fundamental limit of quantum information is described by Holevo's Theorem [^Holevo1973]
which states that the classical capacity of a quantum channel cannot exceed that
of a noiseless classical channel of the same dimension ``d``.
While Holevo's bound only holds when considering many uses  of the channel,
it was recently shown that this limit holds in the one-shot communication setting
as well.
That is, the set of noiseless quantum channels ``\mathcal{Q}_d^{X \to Y}`` with
Hilbert space dimension ``d`` is contained by the set of noiseless classical channels
``\mathcal{C}_d^{X \to  Y}`` and ``\text{Conv}(\mathcal{Q}_d^{X \to Y}) = \mathcal{C}_d^{X \to  Y}``[^Frenkel2015]
where ``\text{Conv}(\cdot)}`` is the convex hull.
This result is remarkable because  it implies that ``\kappa(\text{id}_d) = d``;
that is, classical dit and shared randomness can exactly simulate any quantum channel of
``d`` dimensions.

## Significance

As a device-independent metric of the minimum amount of
classical commmunication needed to simulate a signaling device, the signaling dimension
has broad applications in quantum  technology.
Nammely, the signaling dimension can be certified for any quantum computing,
memory, and communication device that process classical information.
Hence a direct comparison between quantum and classical resources can be established.
That is,

```math
    \text{qudit}\subset \text{dit} + \text{shared randomness}
```

and

```math
    \text{qudit} + \text{shared randomness} = \text{dit} + \text{shared randomness}.
```

Since the statistics of a quantum system and its classical simulation are indistinguishable
such signaling devices can be considered as operationally equivalent.
Therefore, the classical simulation cost can help justify (or reject) the use of quantum technology
for a particular task.
Although, it should be noted that certain fundamental quantum properties such as no-cloning
or non-locality are not captured by the signaling correlations of local signaling devices.
Hence the discussed classical simulations cannot faithfully simulate these phenomena.

## Certification

A goal of SignalingDimension.jl is to provide computational tools that assist the
certification of signaling  dimension.
The  certification process requires a test to  verify the  inclusion (or exclusion)
of a channel ``\mathbf{P}`` in ``\mathcal{C}_d^{X \to Y}``.
Since shared randomness is permitted in the classical simulation, ``\mathcal{C}_d^{X \to Y}``
is tightly bound by a set of linear Bell inequalities.
Therefore, the exclusion ``\mathbf{P}\notin\mathcal{C}_d^{X \to Y}`` is witnessed
by a violation of one of these Bell inequalities.

To compute the Bell inequalities for ``\mathcal{C}_d^{X \to Y}``, SignalingDimension.jl uses the
 [`BellScenario.LocalPolytope`](https://chitambarlab.github.io/BellScenario.jl/stable/LocalPolytope/overview/#BellScenario.LocalPolytope)
module.
These computations are discussed in detail in the [Signaling Polytope: Overview](@ref) section.
Note however that Bell inequality computations rapidly become intractable.
To bypass these challenges, lower and upper bounds can efficiently be
placed on the signaling dimension.
The device-independent tests that certify the signaling dimension of channel are
discussed in greater detail in the [Certifying Signaling Dimension](@ref) section.

### References

[^DallArno2017]:
    Dall’Arno, Michele, et al. "No-hypersignaling principle." Physical review letters 119.2 (2017): 020401.

[^Heinosaari2020]:
    Heinosaari, Teiko, Oskari Kerppo, and Leevi Leppäjärvi. "Communication tasks in operational theories." Journal of Physics A: Mathematical and Theoretical 53.43 (2020): 435302.

[^deVicente2017]:
    de Vicente, Julio I. "Shared randomness and device-independent dimension witnessing." Physical Review A 95.1 (2017): 012340.

[^Holevo1973]:
    Holevo, Alexander Semenovich. "Bounds for the quantity of information transmitted by a quantum communication channel." Problemy Peredachi Informatsii 9.3 (1973): 3-11.

[^Frenkel2015]:
    Frenkel, Péter E., and Mihály Weiner. "Classical information storage in an n-level quantum system." Communications in Mathematical Physics 340.2 (2015): 563-574.
