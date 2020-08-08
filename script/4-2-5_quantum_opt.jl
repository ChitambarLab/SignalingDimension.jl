using Test, LinearAlgebra

using BellScenario, QBase

@testset "4-2-5 quantum optimization" begin

    gen_to_norm_proj = Behavior.norm_to_gen_proj((4,1),(1,5))
    BG = BellGame([3 1 0 0;2 0 2 1;1 2 1 1;0 1 3 0;0 0 0 3], 7)

    gen_facet = cat([-1*BG.β],BG'[:], dims=1)
    norm_facet = gen_facet'*gen_to_norm_proj

    povm_opt = BellScenario.QuantumOpt.cvx_prepare_and_measure_max_facet_violation_states(
        4,5, norm_facet, States.Qubit.([[1 0;0 0],[1 0;0 0],[0 0;0 1],[0 0;0 1]])
    )


end
