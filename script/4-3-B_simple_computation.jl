using Test, LinearAlgebra

using BellScenario

@testset "4-3-B scenario" begin

for B in 5:9
    println("B : ", B)
    vertices = LocalPolytope.vertices((4,1),(1,B),dits=3)
    PM = PrepareAndMeasure(4,B,3)

    println(PM)

    BG_seed = BellGame(cat(cat(ones(Int64,B-4), zeros(Int64,B-4,3) ,dims=2), [1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1], dims=1),3)

    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices = 100)

    println(canonical_facets)
end

end
