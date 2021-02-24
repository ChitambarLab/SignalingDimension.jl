using Test, LinearAlgebra

using XPORTA: write_ieq, IEQ

using BellScenario

@testset "6-3-Y scenario" begin

@time for Y in 7:7
    filepath = "./data/quick_adjacency_decomposition/"
    filename = "6-3-$Y"

    println("$filename scenario")

    PM = LocalSignaling(6,Y,3)
    BG_seed = BellGame(cat(
        cat(
            ones(Int64,Y-6),
            zeros(Int64,Y-6,5),
            dims=2
        ),
        [1 0 0 0 0 0;1 0 0 0 0 0;1 0 0 0 0 0;0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0],
        dims=1
    ), 3)

    vertices = LocalPolytope.vertices(PM)
    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices = 50)
    games = collect(keys(canonical_facets))

    pretty_print_txt(games, filepath*filename)
    write_ieq(filepath*"ieq/"*filename, convert(IEQ, games))
end

end
