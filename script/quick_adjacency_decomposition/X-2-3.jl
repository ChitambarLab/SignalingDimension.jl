using Test, LinearAlgebra

using XPORTA: write_ieq, IEQ

using BellScenario

@testset "X-2-3 scenario" begin

@time for X in 4:12
    filepath = "./data/quick_adjacency_decomposition/"
    filename = "$X-2-3"

    println("$filename scenario")

    PM = PrepareAndMeasure(X,3,2)
    BG_seed = BellGame(cat([1 0 0;0 1 0;0 0 1],zeros(Int64,(3,X-3)), dims=2),2)

    vertices = LocalPolytope.vertices(PM)
    canonical_facet_dict = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices=100)
    games = collect(keys(canonical_facet_dict))

    pretty_print_txt(games, filepath*filename)
    write_ieq(filepath*"ieq/"*filename, convert(IEQ, games))
end

end
