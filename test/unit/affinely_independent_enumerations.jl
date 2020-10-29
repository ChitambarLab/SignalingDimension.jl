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
                succ_game = success_game(N,d)

                @test all(s ->
                    rank(s) == d
                    && succ_game[:]'*s[:] == succ_game.β
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
                for ε in 3:N-d+1
                    strats = aff_ind_error_game_strategies(N, d, ε)
                    err_game = error_game(N,d,ε)

                    @test all(s ->
                        rank(s) == d
                        && err_game[:]' * s[:] == err_game.β
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
        @test PrepareAndMeasureAnalysis._aff_ind_vecs(1,5) == [
            [1,0,1,1,1,1],[0,1,1,1,1,1],[1,1,0,1,1,1],
            [1,1,1,0,1,1],[1,1,1,1,0,1],[1,1,1,1,1,0]
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

@testset "aff_ind_generalized_error_game_strategies()" begin
    @testset "N = k + d: scanning over cases" begin
        for N in 6:10
            for d in 3:N-3
                k = N - d

                strats = aff_ind_generalized_error_game_strategies(N,d,k)
                game = generalized_error_game(N,d,k)

                strats = strats[filter(i -> isassigned(strats,i), 1:length(strats))]

                @test all(s -> sum(sum(game.*s)) == game.β, strats)
                @test all(s -> rank(s) == d, strats)
                @test all(s -> is_deterministic(s), strats)

                @test length(strats) == (N-1)*binomial(N,k)
                @test LocalPolytope.dimension(strats) == (N-1)*binomial(N,k) - 1
            end
        end
    end

    @testset "N = k + d: spot check" begin
        N = 11
        k = 7
        d = 4

        strats = aff_ind_generalized_error_game_strategies(N,d,k)
        game = generalized_error_game(N,d,k)

        strats = strats[filter(i -> isassigned(strats,i), 1:length(strats))]

        @test all(s -> sum(sum(game.*s)) == game.β, strats)
        @test all(s -> rank(s) == d, strats)
        @test all(s -> is_deterministic(s), strats)

        @test length(strats) == (N-1)*binomial(N,k)
        @test LocalPolytope.dimension(strats) == (N-1)*binomial(N,k) - 1
    end

    @testset "k = 2, d = N-k" begin
        for N in 4:15
            k = 2
            d = N-k

            game = generalized_error_game(N,d,k)
            strats = PrepareAndMeasureAnalysis._aff_ind_generalized_error_game_strategies_k2(N,d,k)

            @test all(s -> sum(sum(game.*s)) == game.β, strats)
            @test all(s -> rank(s) == d, strats)
            @test all(s -> is_deterministic(s), strats)

            @test length(strats) == (N-1)*binomial(N,k)
            @test LocalPolytope.dimension(strats) == (N-1)*binomial(N,k) - 1
        end
    end

    @testset "d = 2, k = N-d" begin
        for N in 4:15
            d = 2
            k = N-d

            game = generalized_error_game(N,d,k)
            strats = PrepareAndMeasureAnalysis._aff_ind_generalized_error_game_strategies_d2(N,d,k)

            @test all(s -> sum(sum(game.*s)) == game.β, strats)
            @test all(s -> rank(s) == d, strats)
            @test all(s -> is_deterministic(s), strats)

            @test length(strats) == (N-1)*binomial(N,k)
            @test LocalPolytope.dimension(strats) == (N-1)*binomial(N,k) - 1
        end
    end
end

@testset "aff_ind_ambiguous_game()" begin
    @testset "simplest example" begin
        strats = aff_ind_ambiguous_game_strategies(4,2)

        @test strats[1] == [1 1 0;0 0 0;0 0 1;0 0 0]
        @test strats[2] == [1 0 1;0 1 0;0 0 0;0 0 0]
        @test strats[3] == [0 0 0;1 1 0;0 0 1;0 0 0]
        @test strats[4] == [1 0 0;0 1 1;0 0 0;0 0 0]
        @test strats[5] == [0 0 0;0 1 0;1 0 1;0 0 0]
        @test strats[6] == [1 0 0;0 0 0;0 1 1;0 0 0]
        @test strats[7] == [0 0 0;0 1 0;0 0 0;1 0 1]
        @test strats[8] == [1 0 0;0 0 0;0 0 0;0 1 1]
        @test strats[9] == [0 0 0;0 0 0;0 0 1;1 1 0]
    end

    @testset "scanning through cases" begin
        for N in 4:30
            for d in 2:N-2
                strats = aff_ind_ambiguous_game_strategies(N,d)
                game = ambiguous_game(N,d)

                @test all(s -> sum(game[:].*s[:]) == game.β, strats)
                @test all(s -> rank(s) == d, strats)
                @test all(s -> is_deterministic(s), strats)

                @test length(strats) == (N-1)*(N-1)
                @test LocalPolytope.dimension(strats) == (N-1)*(N-1) - 1
            end
        end
    end

    @testset "spot checks" begin
        @testset "N = 100, d = 77" begin
            N = 50
            d = 27

            strats = aff_ind_ambiguous_game_strategies(N,d)
            game = ambiguous_game(N,d)

            @test all(s -> sum(game[:].*s[:]) == game.β, strats)
            @test all(s -> rank(s) == d, strats)
            @test all(s -> is_deterministic(s), strats)

            @test length(strats) == (N-1)*(N-1)
            @test LocalPolytope.dimension(strats) == (N-1)*(N-1) - 1
        end
    end

    @testset "domain errors" begin
        @test_throws DomainError aff_ind_ambiguous_game_strategies(3,2)
        @test_throws DomainError aff_ind_ambiguous_game_strategies(4,3)
    end
end

end
