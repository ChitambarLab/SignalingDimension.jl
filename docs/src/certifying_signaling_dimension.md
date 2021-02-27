# Certifying Signaling Dimension

Formally, certifying the signaling dimension requires that a channel ``\mathbf{P}\in\mathcal{P}^{X \to Y}``
is checked against all tight Bell inequalities bounding the signaling polytopes.
In general cases, it is difficult derive these Bell inequalities and test them all.
Despite this challenge, the signaling dimension can be bounded.
We now provide methods that efficiently compute upper and lower bounds on the signaling
dimension.
For more details please refer to our work [Certifying the Classical Simulation Cost of a Quantum Channel](https://arxiv.org/abs/2102.12543).

## Bounds

In most cases, it is not feasible to compute the exact signaling of a channel, however,
loose lower and upper bounds can be determined with efficiency.

### Lower Bounds

```@docs
maximum_likelihood_lower_bound
ambiguous_lower_bound
```

### Upper Bounds

```@docs
trivial_upper_bound
attains_trivial_upper_bound
upper_bound
```

## Quantum Channel Certification

The signaling dimension is a device-independent metric which can be applied to
quantum and classical channels alike.
To certify a quantum channel, the signaling correlations must first be obtained.
This can be done by selecting a set of input states ``\Psi := \{\rho_x\}_{x\in\mathcal{X}}`` and
using semi-definite programming to optimize the POVM.
The objective function of the optimization is expressed as a `BellScenario.BellGame`.

The [`BellScenario.Nonlocality`](https://chitambarlab.github.io/BellScenario.jl/dev/Nonlocality/overview/#BellScenario.Nonlocality) module
performs the POVM optimization.

### Code Example: Optimizing Quantum Measurements Against Maximum Likelihood Game

```@example trine_measurement_optimization
using BellScenario
using QBase

X = 3    # num inputs
Y = 3    # num outputs
d = 2    # qudit

scenario = LocalSignaling(X, Y, d)

# maximum likelihood game for the scenario
facet = BellGame([1 0 0;0 1 0;0 0 1], 2)

Ψ = States.trine_qubits

# performing semi-definite programming to find optimal POVM
optimization_dict = Nonlocality.optimize_measurement(scenario, facet, Ψ)
```

The output dictionary contains useful information regarding the optimization.
The POVM can then be used to construct the quantum signaling correlations.

```@example trine_measurement_optimization
Π = Observables.POVM(optimization_dict["povm"])

quantum_strategy(Π, Ψ)
```
