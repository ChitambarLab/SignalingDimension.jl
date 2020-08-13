using Test, LinearAlgebra

using XPORTA: write_ieq, IEQ

using BellScenario

@testset "5-2-B scenario" begin

@time for B in 6:8
    filepath = "./data/quick_adjacency_decomposition/"
    filename = "5-2-$B"

    println("$filename scenario")

    PM = PrepareAndMeasure(5,B,2)
    BG_seed = BellGame(cat(
        cat(
            ones(Int64,B-5),
            zeros(Int64,B-5,4),
            dims=2
        ),
        [1 0 0 0 0;1 0 0 0 0;1 0 0 0 0;0 1 0 0 0;0 0 1 0 0],
        dims=1
    ),  2)

    vertices = LocalPolytope.vertices(PM)
    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices = 30)
    games = collect(keys(canonical_facets))

    pretty_print_txt(games, filepath*filename)
    write_ieq(filepath*"ieq/"*filename, convert(IEQ, games))
end

end
