using Test, LinearAlgebra

using XPORTA: write_ieq, IEQ

using BellScenario

@testset "N-(N-3)-N scenario" begin

@time for N in 5:6
    d = N-3

    filepath = "./data/quick_adjacency_decomposition/"
    filename = "$N-$d-$N"

    println("$filename scenario")

    PM = PrepareAndMeasure(N,N,d)

    M = zeros(Int64,N,N)
    M[[1,2],1] .= 1

    for i in 1:(N-2)
        M[i+2,i] = 1
    end

    BG_seed = BellGame(M,d)

    vertices = LocalPolytope.vertices(PM)
    canonical_facets = LocalPolytope.adjacency_decomposition(vertices, BG_seed, PM, max_vertices = 100)
    games = collect(keys(canonical_facets))

    pretty_print_txt(games, filepath*filename)
    write_ieq(filepath*"ieq/"*filename, convert(IEQ, games))
end

end
