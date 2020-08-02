using Test, LinearAlgebra

using BellScenario

@testset "N-(N-1)-N scenario" begin

for N in 3:6
    println("N : ", N)
    d = N-1

    # vertices too difficult to compute beyond 7
    vertices = LocalPolytope.vertices((N,1),(1,N),dits=d)
    PM = PrepareAndMeasure(N,N,d)

    println(PM)

    BG_seed = BellGame(Matrix{Int64}(I,(N,N)),d)

    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices = 100)

    println(canonical_facets)
end

end
