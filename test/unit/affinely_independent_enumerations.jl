using Test, LinearAlgebra

using BellScenario

@testset "./src/affinely_independent_enumerations.jl" begin

using SignalingDimension

@testset "aff_inf_maximum_likelihood_vertices()" begin
    @testset "simple examples" begin
        @test aff_ind_maximum_likelihood_vertices(3,2) == [
            [1 1 0;0 0 0;0 0 1],[1 0 1;0 1 0;0 0 0],[0 0 0;1 1 0;0 0 1],
            [1 0 0;0 1 1;0 0 0],[0 0 0;0 1 0;1 0 1],[1 0 0;0 0 0;0 1 1]
        ]
    end

    @testset "spot checks" begin
        N = 7
        d = 3
        @test verify_facet(d, maximum_likelihood_facet(N, d), aff_ind_maximum_likelihood_vertices(N, d))
    end

    @testset "errors" begin
        @test_throws DomainError aff_ind_maximum_likelihood_vertices(3, 1)
        @test_throws DomainError aff_ind_maximum_likelihood_vertices(3, 3)
    end
end

@testset "aff_ind_anti_guessing_vertices()" begin
    @testset "simple examples" begin
        @test aff_ind_anti_guessing_vertices(4,2,3) == [
            [0 1 0 1; 1 0 1 0; 0 0 0 0; 0 0 0 0],[0 0 1 1; 0 0 0 0; 1 1 0 0; 0 0 0 0],
            [1 1 1 0; 0 0 0 0; 0 0 0 0; 0 0 0 1],[0 1 1 0; 1 0 0 1; 0 0 0 0; 0 0 0 0],
            [0 0 0 0; 0 0 1 1; 1 1 0 0; 0 0 0 0],[0 0 0 0; 1 1 1 0; 0 0 0 0; 0 0 0 1],
            [0 1 1 0; 0 0 0 0; 1 0 0 1; 0 0 0 0],[0 0 0 0; 1 0 1 0; 0 1 0 1; 0 0 0 0],
            [0 0 0 0; 0 0 0 0; 1 1 1 0; 0 0 0 1],[0 1 1 0; 0 0 0 0; 0 0 0 0; 1 0 0 1],
            [0 0 0 0; 1 0 1 0; 0 0 0 0; 0 1 0 1],[0 0 0 0; 0 0 0 0; 1 1 0 0; 0 0 1 1],
        ]
    end

    @testset "spot checks" begin
        N = 7
        d = 3
        ε = 4

        vertices = aff_ind_anti_guessing_vertices(N, d, ε)
        facet = anti_guessing_facet(N, d, ε)

        @test verify_facet(d, facet, vertices)
    end

    @testset "errors" begin
        @test_throws DomainError aff_ind_anti_guessing_vertices(3,2,3)
        @test_throws DomainError aff_ind_anti_guessing_vertices(4,2,2)
        @test_throws DomainError aff_ind_anti_guessing_vertices(4,3,3)
    end
end

@testset "_aff_ind_vecs()" begin

    @testset "edge cases" begin
        @test SignalingDimension._aff_ind_vecs(0,1) == [[1]]
        @test SignalingDimension._aff_ind_vecs(1,0) == [[0]]
        @test SignalingDimension._aff_ind_vecs(3,0) == [[0,0,0]]
        @test SignalingDimension._aff_ind_vecs(0,3) == [[1,1,1]]
    end

    @testset "simple examples" begin
        @test SignalingDimension._aff_ind_vecs(3,4) == [
            [1,0,0,0,1,1,1],[0,1,0,0,1,1,1],[0,0,1,0,1,1,1],[0,0,0,1,1,1,1],
            [0,0,1,1,0,1,1],[0,0,1,1,1,0,1],[0,0,1,1,1,1,0]
        ]
        @test SignalingDimension._aff_ind_vecs(1,5) == [
            [1,0,1,1,1,1],[0,1,1,1,1,1],[1,1,0,1,1,1],
            [1,1,1,0,1,1],[1,1,1,1,0,1],[1,1,1,1,1,0]
        ]
    end

    @testset "spot checks" begin
        num_zeros = 25
        num_ones = 13

        vecs = SignalingDimension._aff_ind_vecs(num_zeros, num_ones)

        @test all( v ->
            length(filter(isequal(0), v)) == num_zeros
            && length(filter(isequal(1), v)) == num_ones,
        vecs)

        @test length(vecs) == num_zeros + num_ones
        @test LocalPolytope.dimension(vecs) == num_zeros + num_ones - 1
    end
end

@testset "aff_ind_k_guessing_vertices()" begin
    @testset "6-2-4 base case" begin
        Y = 4
        k = 2
        d = 2

        vertices = aff_ind_k_guessing_vertices(Y,d,k)
        facet = k_guessing_facet(Y,d,k)

        @test vertices == [
            [0 1 1 0 0 1; 1 0 0 1 1 0; 0 0 0 0 0 0; 0 0 0 0 0 0],
            [1 1 1 0 0 1; 0 0 0 1 1 0; 0 0 0 0 0 0; 0 0 0 0 0 0],
            [1 1 1 0 0 0; 0 0 0 1 1 1; 0 0 0 0 0 0; 0 0 0 0 0 0],
            [1 0 1 0 1 0; 0 0 0 0 0 0; 0 1 0 1 0 1; 0 0 0 0 0 0],
            [1 1 1 0 1 0; 0 0 0 0 0 0; 0 0 0 1 0 1; 0 0 0 0 0 0],
            [1 1 1 0 0 0; 0 0 0 0 0 0; 0 0 0 1 1 1; 0 0 0 0 0 0],
            [1 1 0 1 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 1 0 1 1],
            [1 1 1 1 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 1 1],
            [1 1 1 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 1 1 1],
            [0 0 0 0 0 0; 1 0 1 1 1 0; 0 1 0 0 0 1; 0 0 0 0 0 0],
            [0 0 0 0 0 0; 1 0 0 1 1 0; 0 1 1 0 0 1; 0 0 0 0 0 0],
            [0 0 0 0 0 0; 1 0 1 0 1 0; 0 1 0 1 0 1; 0 0 0 0 0 0],
            [0 0 0 0 0 0; 1 1 0 1 1 0; 0 0 0 0 0 0; 0 0 1 0 0 1],
            [0 0 0 0 0 0; 1 0 0 1 1 0; 0 0 0 0 0 0; 0 1 1 0 0 1],
            [0 0 0 0 0 0; 1 1 0 1 0 0; 0 0 0 0 0 0; 0 0 1 0 1 1],
            [0 0 0 0 0 0; 0 0 0 0 0 0; 1 1 0 1 0 1; 0 0 1 0 1 0],
            [0 0 0 0 0 0; 0 0 0 0 0 0; 0 1 0 1 0 1; 1 0 1 0 1 0],
            [0 0 0 0 0 0; 0 0 0 0 0 0; 1 1 0 1 0 0; 0 0 1 0 1 1]
        ]

        @test verify_facet(d, facet, vertices)
    end

    @testset "Y = k + d: spot check" begin
        Y = 7
        k = 4
        d = 3

        vertices = aff_ind_k_guessing_vertices(Y,d,k)
        facet = k_guessing_facet(Y,d,k)

        @test verify_facet(d, facet, vertices)
    end

    @testset "spot check: k = 2" begin
        Y = 8
        k = 2
        d = 6

        facet = k_guessing_facet(Y,d,k)
        vertices = aff_ind_k_guessing_vertices(Y,d,k)

        @test verify_facet(d, facet, vertices)
    end

    @testset "spot check: d = 2" begin
        Y = 8
        d = 2
        k = 6

        facet = k_guessing_facet(Y,d,k)
        vertices = aff_ind_k_guessing_vertices(Y,d,k)

        @test verify_facet(d, facet, vertices)
    end

    @testset "errors" begin
        @test_throws DomainError aff_ind_k_guessing_vertices(7,3,3)
        @test_throws DomainError aff_ind_k_guessing_vertices(6,2,1)
        @test_throws DomainError aff_ind_k_guessing_vertices(7,1,3)
    end
end

@testset "aff_ind_ambiguous_guessing_facet()" begin
    @testset "simplest example" begin
        vertices = aff_ind_ambiguous_guessing_vertices(4,2)

        @test vertices[1] == [1 1 0;0 0 0;0 0 1;0 0 0]
        @test vertices[2] == [1 0 1;0 1 0;0 0 0;0 0 0]
        @test vertices[3] == [0 0 0;1 1 0;0 0 1;0 0 0]
        @test vertices[4] == [1 0 0;0 1 1;0 0 0;0 0 0]
        @test vertices[5] == [0 0 0;0 1 0;1 0 1;0 0 0]
        @test vertices[6] == [1 0 0;0 0 0;0 1 1;0 0 0]
        @test vertices[7] == [0 0 0;0 1 0;0 0 0;1 0 1]
        @test vertices[8] == [1 0 0;0 0 0;0 0 0;0 1 1]
        @test vertices[9] == [0 0 0;0 0 0;0 0 1;1 1 0]
    end

    @testset "spot checks" begin
        @testset "Y = 10, d = 4" begin
            Y = 10
            d = 4

            vertices = aff_ind_ambiguous_guessing_vertices(Y,d)
            facet = ambiguous_guessing_facet(Y,d)

            @test verify_facet(d, facet, vertices)
        end
    end

    @testset "domain errors" begin
        @test_throws DomainError aff_ind_ambiguous_guessing_vertices(3,2)
        @test_throws DomainError aff_ind_ambiguous_guessing_vertices(4,3)
    end
end

@testset "aff_ind_negativity_game_strategies()" begin
    @testset "simple 3x3 cases" begin
        strategies = aff_ind_non_negativity_vertices(3,3)

        @test strategies == [
            [1 1 1;0 0 0;0 0 0],
            [1 0 1;0 0 0;0 1 0],
            [1 1 0;0 0 0;0 0 1],
            [0 0 0;1 1 1;0 0 0],
            [0 0 0;1 0 1;0 1 0],
            [0 0 0;1 1 0;0 0 1],
        ]
    end

    @testset "spot checks" begin
        X = 5
        Y = 7

        facet = non_negativity_facet(X, Y)
        vertices = aff_ind_non_negativity_vertices(X, Y)

        @test all(v ->
            facet[:]' * v[:] == facet.β && rank(v) ≤ 2 && is_deterministic(v),
        vertices)

        @test length(vertices) == X*(Y-1)
        @test LocalPolytope.dimension(vertices) == X*(Y-1) - 1
    end

    @testset "DomainErrors" begin
        @test_throws DomainError non_negativity_facet(1, 5)
        @test_throws DomainError non_negativity_facet(5, 1)
    end
end

@testset "aff_ind_coarse_grained_input_ambiguous_guessing_vertices()" begin
    @testset "simple example" begin
        Y = 4
        d = 2

        vertices = aff_ind_coarse_grained_input_ambiguous_guessing_vertices(Y,d)
        facet = coarse_grained_input_ambiguous_guessing_facet(Y,d)

        @test vertices == [
            [1 1 0 0; 0 0 0 0; 0 0 1 1; 0 0 0 0], [1 0 1 1; 0 1 0 0; 0 0 0 0; 0 0 0 0],
            [0 0 0 0; 1 1 0 0; 0 0 1 1; 0 0 0 0], [1 0 0 1; 0 1 1 0; 0 0 0 0; 0 0 0 0],
            [0 0 0 0; 0 1 0 0; 1 0 1 1; 0 0 0 0], [1 0 0 0; 0 0 0 0; 0 1 1 1; 0 0 0 0],
            [0 0 0 0; 0 1 0 1; 0 0 0 0; 1 0 1 0], [1 0 0 1; 0 0 0 0; 0 0 0 0; 0 1 1 0],
            [0 0 0 0; 0 0 0 0; 0 0 1 1; 1 1 0 0], [1 0 0 0; 0 1 1 1; 0 0 0 0; 0 0 0 0],
            [1 0 0 0; 0 0 0 0; 0 0 0 0; 0 1 1 1], [0 0 0 0; 0 0 0 0; 0 0 0 1; 1 1 1 0]
        ]

        @test verify_facet(d, facet, vertices)
    end

    @testset "spot checks" begin
        Y = 8
        d = 4

        facet = coarse_grained_input_ambiguous_guessing_facet(Y, d)
        vertices = aff_ind_coarse_grained_input_ambiguous_guessing_vertices(Y, d)

        @test verify_facet(d, facet, vertices)
    end

    @testset "errors" begin
        @test_throws DomainError aff_ind_coarse_grained_input_ambiguous_guessing_vertices(3, 2)
        @test_throws DomainError aff_ind_coarse_grained_input_ambiguous_guessing_vertices(5, 4)
    end
end

end
