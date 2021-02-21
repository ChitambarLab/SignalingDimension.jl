using Test, BellScenario

@testset "./src/bell_inequalities.jl" begin

using SignalingDimension

@testset "ambiguous_guessing_game()" begin
    @testset "varying k" begin
        scenario = LocalSignaling(3,4,2)

        @test ambiguous_guessing_game(scenario, 0) == [1 1 1;1 1 1;1 1 1;1 1 1]
        @test ambiguous_guessing_game(scenario, 1) == [2 0 0;1 1 1;1 1 1;1 1 1]
        @test ambiguous_guessing_game(scenario, 2) == [2 0 0;0 2 0;1 1 1;1 1 1]
        @test ambiguous_guessing_game(scenario, 3) == [2 0 0;0 2 0;0 0 2;1 1 1]
        @test ambiguous_guessing_game(scenario, 4) == [2 0 0;0 2 0;0 0 2;0 0 2]
    end

    @testset "d edge cases" begin
        BG = ambiguous_guessing_game(LocalSignaling(4,6,4), 4)
        @test BG == [
            1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1;1 1 1 1;1 1 1 1
        ]
        @test BG.β == 4

        BG = ambiguous_guessing_game(LocalSignaling(6,4,4), 3)
        @test BG == [
            3 0 0 0 0 0;0 3 0 0 0 0;0 0 3 0 0 0;1 1 1 1 1 1
        ]
        @test BG.β == 12
    end

    @testset "errors" begin
        @test_throws DomainError ambiguous_guessing_game(LocalSignaling(3,3,4),2)
        @test_throws DomainError ambiguous_guessing_game(LocalSignaling(4,5,2),7)
end

@testset "maximum_likelihood_facet()" begin
    @testset "trivial case" begin
        game = maximum_likelihood_facet(3,2)

        @test game isa BellGame
        @test game == [1 0 0;0 1 0;0 0 1]
        @test game.β == 2
    end

    @testset "example case" begin
        game = maximum_likelihood_facet(6,4)

        @test game isa BellGame
        @test game == [
            1 0 0 0 0 0;
            0 1 0 0 0 0;
            0 0 1 0 0 0;
            0 0 0 1 0 0;
            0 0 0 0 1 0;
            0 0 0 0 0 1
        ]
        @test game.β == 4
    end

    @testset "errors" begin
        @test_throws DomainError maximum_likelihood_facet(2,2)
        @test_throws DomainError maximum_likelihood_facet(4,5)
        @test_throws DomainError maximum_likelihood_facet(4,1)
    end
end

@testset "anti_guessing_facet()" begin
    @testset "trivial case" begin
        game = anti_guessing_facet(4,2,3)

        @test game isa BellGame
        @test game == [0 1 1 0;1 0 1 0;1 1 0 0;0 0 0 1]
        @test game.β == 3
    end

    @testset "example case" begin
        game = anti_guessing_facet(6,3,4)

        @test game isa BellGame
        @test game == [
            0 1 1 1 0 0;
            1 0 1 1 0 0;
            1 1 0 1 0 0;
            1 1 1 0 0 0;
            0 0 0 0 1 0;
            0 0 0 0 0 1
        ]
        @test game.β == 5
    end

    @testset "errors" begin
        @test_throws DomainError anti_guessing_facet(3,2,3)
        @test_throws DomainError anti_guessing_facet(4,3,3)
        @test_throws DomainError anti_guessing_facet(4,1,3)
        @test_throws DomainError anti_guessing_facet(7,4,2)
        @test_throws DomainError anti_guessing_facet(7,4,2)
        @test_throws DomainError anti_guessing_facet(7,4,5)
    end
end

@testset "ambiguous_guessing_facet()" begin
    @testset "trivial case" begin
        game = ambiguous_guessing_facet(4,2)

        @test game isa BellGame
        @test game == [2 0 0;0 2 0;0 0 2;1 1 1]
        @test game.β == 4
    end

    @testset "example cases" begin
        game1 = ambiguous_guessing_facet(6,2)

        @test game1 isa BellGame
        @test game1 == [
            4 0 0 0 0;
            0 4 0 0 0;
            0 0 4 0 0;
            0 0 0 4 0;
            0 0 0 0 4;
            1 1 1 1 1
        ]
        @test game1.β == 8

        game2 = ambiguous_guessing_facet(6,4)
        @test game2 isa BellGame
        @test game2 == [
            2 0 0 0 0;
            0 2 0 0 0;
            0 0 2 0 0;
            0 0 0 2 0;
            0 0 0 0 2;
            1 1 1 1 1
        ]
        @test game2.β == 8
    end

    @testset "errors" begin
        @test_throws DomainError ambiguous_guessing_facet(3,2)
        @test_throws DomainError ambiguous_guessing_facet(5,1)
        @test_throws DomainError ambiguous_guessing_facet(5,4)
    end
end

@testset "k_guessing_facet()" begin
    @testset "maximum_likelihood_facet generalization" begin
        k = 1

        for N in 3:6
            for d in 2:N-1
                gen_err_game = k_guessing_facet(N, d, k)

                succ_game = maximum_likelihood_facet(N, d)

                @test gen_err_game isa BellGame
                @test gen_err_game == succ_game
                @test gen_err_game.β == succ_game.β
            end
        end
    end

    @testset "errors" begin
        @test_throws DomainError k_guessing_facet(2,2,1)
        @test_throws DomainError k_guessing_facet(5,2,5)
        @test_throws DomainError k_guessing_facet(5,2,0)
        @test_throws DomainError k_guessing_facet(5,4,2)
        @test_throws DomainError k_guessing_facet(5,1,2)
    end

    @testset "simple non-trivial cases" begin
        @testset "6-2-4 polytope" begin
            gen_err_game = k_guessing_facet(4, 2, 2)

            @test gen_err_game isa BellGame
            @test gen_err_game == [
                1 1 1 0 0 0;
                1 0 0 1 1 0;
                0 1 0 1 0 1;
                0 0 1 0 1 1
            ]
            @test gen_err_game.β == 5
        end

        @testset "10-2-5 polytope" begin
            gen_err_game1 = k_guessing_facet(5, 2, 2)

            @test gen_err_game1 isa BellGame
            @test gen_err_game1 == [
                1 1 1 1 0 0 0 0 0 0;
                1 0 0 0 1 1 1 0 0 0;
                0 1 0 0 1 0 0 1 1 0;
                0 0 1 0 0 1 0 1 0 1;
                0 0 0 1 0 0 1 0 1 1;
            ]
            @test gen_err_game1.β == 7

            gen_err_game2 = k_guessing_facet(5,2,3)

            @test gen_err_game2 isa BellGame
            @test gen_err_game2 == [
                1 1 1 1 1 1 0 0 0 0;
                1 1 1 0 0 0 1 1 1 0;
                1 0 0 1 1 0 1 1 0 1;
                0 1 0 1 0 1 1 0 1 1;
                0 0 1 0 1 1 0 1 1 1;
            ]
            @test gen_err_game2.β == 9
        end

        @testset "10-3-5 polytope" begin
            gen_err_game = k_guessing_facet(5,3,2)

            @test gen_err_game isa BellGame
            @test gen_err_game == [
                1 1 1 1 0 0 0 0 0 0;
                1 0 0 0 1 1 1 0 0 0;
                0 1 0 0 1 0 0 1 1 0;
                0 0 1 0 0 1 0 1 0 1;
                0 0 0 1 0 0 1 0 1 1;
            ]

            @test gen_err_game.β == 9
        end
    end
end

@testset "non_negativity_facet()" begin
    @testset "simple 3x3 case" begin
        game = non_negativity_facet(3,3)

        @test game isa BellGame
        @test game == [1 0 0;1 0 0;0 0 0]
        @test game.β == 1
    end

    @testset "simple 5x5 case" begin
        game = non_negativity_facet(5,5)

        @test game isa BellGame
        @test game == [1 0 0 0 0;1 0 0 0 0;1 0 0 0 0;1 0 0 0 0;0 0 0 0 0]
        @test game.β == 1
    end

    @testset "DomainErrors" begin
        @test_throws DomainError non_negativity_facet(1, 5)
        @test_throws DomainError non_negativity_facet(5, 1)
    end
end

@testset "coarse_grained_input_ambiguous_guessing_facet()" begin
    @testset "simple 4x4 case" begin
        game = coarse_grained_input_ambiguous_guessing_facet(4,2)

        @test game isa BellGame
        @test game == [2 0 0 0;0 2 0 0;0 0 1 1;1 1 1 0]
        @test game.β == 4
    end

    @testset "simple 6x6 case" begin
        game = coarse_grained_input_ambiguous_guessing_facet(6,2)

        @test game isa BellGame
        @test game == [4 0 0 0 0 0;0 4 0 0 0 0;0 0 4 0 0 0;0 0 0 4 0 0;0 0 0 0 1 3;1 1 1 1 1 0]
        @test game.β == 8
    end

    @testset "errors" begin
        @test_throws DomainError coarse_grained_input_ambiguous_guessing_facet(6,5)
        @test_throws DomainError coarse_grained_input_ambiguous_guessing_facet(3,1)
    end
end

end
