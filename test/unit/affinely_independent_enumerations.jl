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
        for N in 3:12
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

@testset "aff_ind_error_game_strategies()" begin

    @testset "simple examples" begin
        @test aff_ind_error_game_strategies(4,2,3) == [
            [0 1 0 1; 1 0 1 0; 0 0 0 0; 0 0 0 0],[0 0 1 1; 0 0 0 0; 1 1 0 0; 0 0 0 0],
            [1 1 1 0; 0 0 0 0; 0 0 0 0; 0 0 0 1],[0 1 1 0; 1 0 0 1; 0 0 0 0; 0 0 0 0],
            [0 0 0 0; 0 0 1 1; 1 1 0 0; 0 0 0 0],[0 0 0 0; 1 1 1 0; 0 0 0 0; 0 0 0 1],
            [0 1 1 0; 0 0 0 0; 1 0 0 1; 0 0 0 0],[0 0 0 0; 1 0 1 0; 0 1 0 1; 0 0 0 0],
            [0 0 0 0; 0 0 0 0; 1 1 1 0; 0 0 0 1],[0 1 1 0; 0 0 0 0; 0 0 0 0; 1 0 0 1],
            [0 0 0 0; 1 0 1 0; 0 0 0 0; 0 1 0 1],[0 0 0 0; 0 0 0 0; 1 1 0 0; 0 0 1 1],
        ]
    end

    @testset "scanning over simple cases" begin
        for N in 4:20
            for d in 2:N-2
                for error_size in 3:N-d+1
                    strats = aff_ind_error_game_strategies(N,d,error_size)
                    error_game = ones(Int64, error_size, error_size) .- Matrix{Int64}(I, error_size, error_size)

                    @test all(s ->
                        rank(s) == d
                        && error_size + d - 2 == sum(error_game[:] .* s[1:error_size,1:error_size][:]) + tr(s[error_size+1:end,error_size+1:end])
                        && DeterministicStrategy(s) isa BellScenario.DeterministicStrategy,
                    strats)

                    @test length(strats) == N*(N-1)
                    @test LocalPolytope.dimension(strats) == N*(N-1) - 1
                end
            end
        end
    end
end


@testset "_aff_ind_vecs()" begin

    @testset "base cases" begin
        @test PrepareAndMeasureAnalysis._aff_ind_vecs(0,1) == [[1]]
        @test PrepareAndMeasureAnalysis._aff_ind_vecs(1,0) == [[0]]
        @test PrepareAndMeasureAnalysis._aff_ind_vecs(3,0) == [[0,0,0]]
        @test PrepareAndMeasureAnalysis._aff_ind_vecs(0,3) == [[1,1,1]]
    end

    @testset "simple examples" begin
        @test PrepareAndMeasureAnalysis._aff_ind_vecs(3,4) == [
            [1,0,0,0,1,1,1],[0,1,0,0,1,1,1],[0,0,1,0,1,1,1],[0,0,0,1,1,1,1],
            [0,0,1,1,0,1,1],[0,0,1,1,1,0,1],[0,0,1,1,1,1,0]
        ]
    end

    @time @testset "scanning over simple cases" begin
        for num_zeros in 1:20
            for num_ones in 1:20
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
