using Test, LinearAlgebra

using BellScenario

@testset "./src/affinely_independent_enumerations.jl" begin

using PrepareAndMeasureAnalysis

@testset "aff_inf_success_game_strategies()" begin
    @testset "simple examples" begin
        @test aff_ind_success_game_strategies(3,2) == [
            [1 1 0;0 0 0;0 0 1],[1 0 1;0 1 0;0 0 0],[0 0 0;1 1 0;0 0 1],
            [1 0 0;0 1 1;0 0 0],[0 0 0;0 1 0;1 0 1],[1 0 0;0 0 0;0 1 1]
        ]
    end

    @testset "scanning over simple examples" begin
        for N in 3:15
            for d in 2:N-1
                strats = aff_ind_success_game_strategies(N,d)

                @test all(s ->
                    rank(s) == d
                    && tr(s) == d
                    && DeterministicStrategy(s) isa BellScenario.DeterministicStrategy,
                strats)

                @test length(strats) == N*(N-1)
                @test LocalPolytope.dimension(strats) == N*(N-1) - 1
            end
        end
    end
end


@testset "_aff_ind_vecs()" begin

    @testset "simple examples" begin
        @test PrepareAndMeasureAnalysis._aff_ind_vecs(3,4) == [
            [1,0,0,0,1,1,1],[0,1,0,0,1,1,1],[0,0,1,0,1,1,1],[0,0,0,1,1,1,1],
            [0,0,1,1,0,1,1],[0,0,1,1,1,0,1],[0,0,1,1,1,1,0]
        ]
    end

    @time @testset "scanning over simple cases" begin
        for num_zeros in 1:25
            for num_ones in 1:25
                vecs = PrepareAndMeasureAnalysis._aff_ind_vecs(num_zeros,num_ones)

                @test all( v ->
                    length(filter(isequal(0), v)) == num_zeros
                    && length(filter(isequal(1), v)) == num_ones,
                vecs)

                @test length(vecs) == num_zeros + num_ones
                @test LocalPolytope.dimension(vecs) == num_zeros + num_ones - 1
            end
        end
    end

end


end
