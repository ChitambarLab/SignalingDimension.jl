using Test, BellScenario

@testset "./src/facets.jl" begin

using PrepareAndMeasureAnalysis

@testset "success_game()" begin
    @testset "trivial case" begin
        game = success_game(3,2)

        @test game isa BellGame
        @test game == [1 0 0;0 1 0;0 0 1]
        @test game.β == 2
    end

    @testset "example case" begin
        game = success_game(6,4)

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
        @test_throws DomainError success_game(2,2)
        @test_throws DomainError success_game(4,5)
        @test_throws DomainError success_game(4,1)
    end
end

@testset "error_game()" begin
    @testset "trivial case" begin
        game = error_game(4,2,3)

        @test game isa BellGame
        @test game == [0 1 1 0;1 0 1 0;1 1 0 0;0 0 0 1]
        @test game.β == 3
    end

    @testset "example case" begin
        game = error_game(6,3,4)

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
        @test_throws DomainError error_game(3,2,3)
        @test_throws DomainError error_game(4,3,3)
        @test_throws DomainError error_game(4,1,3)
        @test_throws DomainError error_game(7,4,2)
        @test_throws DomainError error_game(7,4,2)
        @test_throws DomainError error_game(7,4,5)
    end
end

@testset "ambiguous_game()" begin
    @testset "trivial case" begin
        game = ambiguous_game(4,2)

        @test game isa BellGame
        @test game == [2 0 0;0 2 0;0 0 2;1 1 1]
        @test game.β == 4
    end

    @testset "example cases" begin
        game1 = ambiguous_game(6,2)

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

        game2 = ambiguous_game(6,4)
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
        @test_throws DomainError ambiguous_game(3,2)
        @test_throws DomainError ambiguous_game(5,1)
        @test_throws DomainError ambiguous_game(5,4)
    end
end

end
