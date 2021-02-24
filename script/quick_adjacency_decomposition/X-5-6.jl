using Test, LinearAlgebra

using XPORTA: write_ieq, IEQ

using BellScenario

@testset "X-5-6 scenario" begin

@time for X in 7:8
    filepath = "./data/quick_adjacency_decomposition/"
    filename = "$X-5-6"

    println("$filename scenario")

    PM = LocalSignaling(X,6,5)
    BG_seed = BellGame(cat(
        [1 0 0 0 0 0;0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1],
        zeros(Int64,(6,X-6)),
        dims=2
    ), 5)

    vertices = LocalPolytope.vertices(PM)
    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices=100)
    games = collect(keys(canonical_facets))

    pretty_print_txt(games, filepath*filename)
    write_ieq(filepath*"ieq/"*filename, convert(IEQ, games))
end

end
