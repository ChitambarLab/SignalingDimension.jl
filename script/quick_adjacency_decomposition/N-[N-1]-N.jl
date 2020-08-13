using Test, LinearAlgebra

using XPORTA: write_ieq, IEQ

using BellScenario

@testset "N-(N-1)-N scenario" begin

@time for N in 3:7
    d = N-1

    filepath = "./data/quick_adjacency_decomposition/"
    filename = "$N-$d-$N"

    println("$filename scenario")

    PM = PrepareAndMeasure(N,N,d)
    BG_seed = BellGame(Matrix{Int64}(I,(N,N)), d)

    vertices = LocalPolytope.vertices(PM)
    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices = 100)
    games = collect(keys(canonical_facets))

    pretty_print_txt(games, filepath*filename)
    write_ieq(filepath*"ieq/"*filename, convert(IEQ, games))
end

end
