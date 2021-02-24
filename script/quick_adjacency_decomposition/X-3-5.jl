using Test, LinearAlgebra

using XPORTA: write_ieq, IEQ

using BellScenario

@testset "X-3-5 scenario" begin

@time for X in 6:7
    filepath = "./data/quick_adjacency_decomposition/"
    filename = "$X-3-5"

    println("$filename scenario")

    PM = LocalSignaling(X,5,3)
    BG_seed = BellGame(cat(
        [1 0 0 0 0;1 0 0 0 0;0 1 0 0 0;0 0 1 0 0;0 0 0 1 0],
        zeros(Int64,(5,X-5)),
        dims=2
    ), 3)

    vertices = LocalPolytope.vertices(PM)
    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices=200)
    games = collect(keys(canonical_facets))

    pretty_print_txt(games, filepath*filename)
    write_ieq(filepath*"ieq/"*filename, convert(IEQ, games))
end

end
