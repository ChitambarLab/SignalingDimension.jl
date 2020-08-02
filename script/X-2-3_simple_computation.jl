using Test, LinearAlgebra

using BellScenario

@testset "X-2-3 scenario" begin

for X in 4:8
    println("x : ", X)
    vertices = LocalPolytope.vertices((X,1),(1,3),dits=2)
    PM = PrepareAndMeasure(X,3,2)

    println(PM)

    BG_seed = BellGame(cat([1 0 0;0 1 0;0 0 1],zeros(Int64,(3,X-3)), dims=2),2)

    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM)

    println(canonical_facets)
end

end
