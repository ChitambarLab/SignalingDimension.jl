using Test, LinearAlgebra

using BellScenario

@testset "X-3-4 scenario" begin

for X in 5:8
    println("x : ", X)
    vertices = LocalPolytope.vertices((X,1),(1,4),dits=3)
    PM = PrepareAndMeasure(X,4,3)

    println(PM)

    BG_seed = BellGame(cat([1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1],zeros(Int64,(4,X-4)), dims=2),3)

    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM)

    println(canonical_facets)
end

end
