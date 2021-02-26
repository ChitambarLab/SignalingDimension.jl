using Test, BellScenario

@testset "./src/verifications.jl" begin

using SignalingDimension

@testset "verify_facet()" begin
    @testset "3-2-3 signaling polytope examples" begin
        facet = BellGame([1 0 0;0 1 0;0 0 1], 2)
        aff_ind_vertices = [
            [1 0 1;0 1 0;0 0 0], [1 1 0;0 0 0;0 0 1],
            [0 0 0;1 1 0;0 0 1], [1 0 0;0 1 1;0 0 0],
            [1 0 0;0 0 0;0 1 1], [0 0 0;0 1 0;1 0 1]
        ]

        @test verify_facet(2, facet, aff_ind_vertices)

        @test !verify_facet(1, facet, aff_ind_vertices)
        @test !verify_facet(3, facet, aff_ind_vertices)

        @test !verify_facet(2, facet, aff_ind_vertices[1:5])
        @test !verify_facet(2, facet, [aff_ind_vertices...,[0 0 0;0 1 0;1 0 1]])
    end

    @testset "invalid vertices examples" begin
        facet = BellGame([1 0 0;0 1 0;0 0 0], 2)
        aff_ind_vertices = [
            [1 0 1;0 1 0;0 0 0], [1 1 0;0 1 0;0 0 1],
            [1 0 0;1 1 0;0 0 1], [1 0 0;0 1 0;0 0 0],
            [1 0 0;0 1 0;0 1 1], [1 0 0;0 1 0;1 0 1]
        ]

        @test LocalPolytope.dimension(aff_ind_vertices) == 5
        @test !verify_facet(2, facet, aff_ind_vertices)
    end
end

end
