using Test, LinearAlgebra

using BellScenario

@testset "5-2-B scenario" begin

for B in 6:8
    println("B : ", B)
    vertices = LocalPolytope.vertices((5,1),(1,B),dits=2)
    PM = PrepareAndMeasure(5,B,2)

    println(PM)

    BG_seed = BellGame(cat(cat(ones(Int64,B-5), zeros(Int64,B-5,4) ,dims=2), [1 0 0 0 0;1 0 0 0 0;1 0 0 0 0;0 1 0 0 0;0 0 1 0 0], dims=1),2)

    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices = 100)

    println(canonical_facets)
end

end
