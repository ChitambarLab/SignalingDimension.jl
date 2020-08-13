using Test, LinearAlgebra

using XPORTA: write_ieq, IEQ

using BellScenario

@testset "4-3-B scenario" begin

@time for B in 5:12
    filepath = "./data/quick_adjacency_decomposition/"
    filename = "4-3-$B"

    println("$filename scenario")

    PM = PrepareAndMeasure(4,B,3)
    BG_seed = BellGame(cat(
        cat(
            ones(Int64,B-4),
            zeros(Int64,B-4,3),
            dims=2
        ),
        [1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1],
        dims=1
    ), 3)

    vertices = LocalPolytope.vertices(PM)
    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices = 200)
    games = collect(keys(canonical_facets))

    pretty_print_txt(games, filepath*filename)
    write_ieq(filepath*"ieq/"*filename, convert(IEQ, games))
end

end
