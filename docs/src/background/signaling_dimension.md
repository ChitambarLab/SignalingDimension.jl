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

The  signaling dimension is defined with respect to the observed signaling
correlations and requires no assumptions to be made about the communication process.
Hence the signaling dimension is a device-independent metric.
The signaling dimension of quantum channels is elaborated upon in
[Certifying the Classical Simulation Cost of a Quantum Channel](broken link).

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
that is, one dit of classical communication and shared randomness can exactly
simulate any quantum channel of ``d`` dimensions.

## Significance

As a device-independent metric of the classical simulation cost, the signaling dimension
has broad applications in quantum  technology.
Namely, the signaling dimension can be certified for any quantum computing,
memory, or communication device that process classical information.
Hence a direct comparison between quantum and classical resources is established.
That is,

```math
    \text{qudit}\subset \text{dit} + \text{shared randomness}
```

Since the statistics of a quantum system and its classical simulation are indistinguishable
such signaling devices are considered to be operationally equivalent.
Therefore, the classical simulation cost can help justify (or reject) the use of quantum technology
for a particular task.

!!! note "Note:"    
    Certain fundamental quantum properties such as no-cloning or non-locality
    cannot be simulated classically. These properties are not reflected in the
    signaling correlations. To observe these phenomena additional assumptions
    must be made.

## Certification

Certifying the signaling dimension of classical and quantum channels requires
one to verify whether or not ``\mathbf{P}\in\mathcal{C}_d^{X \to Y}``.
In general, this is a challenging task and can only be done with certainty in special
cases.
The SignalingDimension.jl package provides tools that assist the certification
of signaling dimension.
We elaborate on these certification procedures in the [Certifying Signaling Dimension](@ref) section.

In principle, the signaling dimension can be witnessed by the Bell inequalities that
tightly bound the set ``\mathcal{C}_d^{X\to Y}``.
These Bell inequalities are discussed further in the [Bell Inequalities](@ref) section.
Note however that Bell inequality computations rapidly become infeasible.
As a result, one should only expect to find lower and upper bounds for the signaling
dimension of a particular system.

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
