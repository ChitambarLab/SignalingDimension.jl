using Test, LinearAlgebra

using XPORTA: write_ieq, IEQ

using BellScenario

@testset "X-2-4 scenario" begin

@time for X in 5:9
    filepath = "./data/quick_adjacency_decomposition/"
    filename = "$X-2-4"

    println("$filename scenario")

    PM = PrepareAndMeasure(X,4,2)
    BG_seed = BellGame(cat([1 0 0 0;1 0 0 0;0 1 0 0;0 0 1 0],zeros(Int64,(4,X-4)), dims=2),2)

    vertices = LocalPolytope.vertices(PM)
    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices=200)
    games = collect(keys(canonical_facets))

    pretty_print_txt(games, filepath*filename)
    write_ieq(filepath*"ieq/"*filename, convert(IEQ, games))
end

end
