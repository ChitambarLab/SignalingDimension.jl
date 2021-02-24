using Test, LinearAlgebra

using XPORTA: write_ieq, IEQ

using BellScenario

@testset "3-2-Y scenario" begin

@time for Y in 4:12
    filepath = "./data/quick_adjacency_decomposition/"
    filename = "3-2-$Y"

    println("$filename scenario")

    PM = LocalSignaling(3,Y,2)
    BG_seed = BellGame(cat(cat(ones(Int64,Y-3), zeros(Int64,Y-3,2) ,dims=2), [1 0 0;0 1 0;0 0 1], dims=1),2)

    vertices = LocalPolytope.vertices(PM)
    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices = 100)
    games = collect(keys(canonical_facets))

    pretty_print_txt(games, filepath*filename)
    write_ieq(filepath*"ieq/"*filename, convert(IEQ, games))
end

end
