using Test, LinearAlgebra

using XPORTA: write_ieq, IEQ

using BellScenario

@testset "N-(N-2)-N scenario" begin

@time for N in 4:7
    d = N-2

    filepath = "./data/quick_adjacency_decomposition/"
    filename = "$N-$d-$N"

    println("$filename scenario")

    PM = PrepareAndMeasure(N,N,d)

    BG_seed = BellGame(cat(
        cat(ones(Int64,(1,1)), zeros(Int64, (1,N-1)), dims=2),
        cat(Matrix{Int64}(I,(N-1,N-1)), zeros(Int64,(N-1,1)), dims=2),
        dims =  1
    ), d)


    vertices = LocalPolytope.vertices(PM)
    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices = 100)
    games = collect(keys(canonical_facets))

    pretty_print_txt(games, filepath*filename)
    write_ieq(filepath*"ieq/"*filename, convert(IEQ, games))
end

end
