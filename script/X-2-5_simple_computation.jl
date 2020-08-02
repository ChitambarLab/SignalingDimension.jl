using Test, LinearAlgebra

using BellScenario

@testset "X-2-5 scenario" begin

for X in 6:7
    println("x : ", X)
    vertices = LocalPolytope.vertices((X,1),(1,5),dits=2)
    PM = PrepareAndMeasure(X,5,2)

    println(PM)

    BG_seed = BellGame(cat([1 0 0 0 0;1 0 0 0 0;1 0 0 0 0;0 1 0 0 0;0 0 1 0 0],zeros(Int64,(5,X-5)), dims=2),2)

    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM)

    # something interesting happens where 7 has a lot fewer facets than 6, likely
    # didn't get all the facets
    println(canonical_facets)
end

end
