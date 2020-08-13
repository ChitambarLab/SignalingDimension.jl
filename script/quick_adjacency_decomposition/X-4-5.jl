using Test, LinearAlgebra

using XPORTA: write_ieq, IEQ

using BellScenario

@testset "X-4-5 scenario" begin

@time for X in 6:8
    filepath = "./data/quick_adjacency_decomposition/"
    filename = "$X-4-5"

    println("$filename scenario")

    PM = PrepareAndMeasure(X,5,4)
    BG_seed = BellGame(cat(
        [1 0 0 0 0;0 1 0 0 0;0 0 1 0 0;0 0 0 1 0;0 0 0 0 1],
        zeros(Int64,(5,X-5)),
        dims=2
    ), 4)

    vertices = LocalPolytope.vertices(PM)
    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices=100)
    games = collect(keys(canonical_facets))

    pretty_print_txt(games, filepath*filename)
    write_ieq(filepath*"ieq/"*filename, convert(IEQ, games))
end

end
