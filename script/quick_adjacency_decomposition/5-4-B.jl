using Test, LinearAlgebra

using XPORTA: write_ieq, IEQ

using BellScenario

@testset "5-4-B scenario" begin

@time for B in 6:10
    filepath = "./data/quick_adjacency_decomposition/"
    filename = "5-4-$B"

    println("$filename scenario")

    PM = PrepareAndMeasure(5,B,4)
    BG_seed = BellGame(cat(
        cat(
            ones(Int64,B-5),
            zeros(Int64,B-5,4),
            dims=2
        ),
        [1 0 0 0 0;0 1 0 0 0;0 0 1 0 0;0 0 0 1 0;0 0 0 0 1],
        dims=1
    ), 4)

    vertices = LocalPolytope.vertices(PM)
    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices = 100)
    games = collect(keys(canonical_facets))

    pretty_print_txt(games, filepath*filename)
    write_ieq(filepath*"ieq/"*filename, convert(IEQ, games))
end

end
