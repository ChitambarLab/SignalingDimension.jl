using Test, LinearAlgebra

using XPORTA: write_ieq, IEQ

using BellScenario

@testset "N-(N-4)-N scenario" begin

    @time for N = 6:6
        d = N - 4

        filepath = "./data/quick_adjacency_decomposition/"
        filename = "$N-$d-$N"

        println("$filename scenario")

        PM = PrepareAndMeasure(N, N, d)

        M = zeros(Int64, N, N)
        M[[1, 2, 3], 1] .= 1

        for i = 1:(N-3)
            M[i+3, i] = 1
        end

        BG_seed = BellGame(M, d)

        vertices = LocalPolytope.vertices(PM)
        canonical_facets = LocalPolytope.adjacency_decomposition(
            vertices,
            BG_seed,
            PM,
            max_vertices = 36,
        )
        games = collect(keys(canonical_facets))

        pretty_print_txt(games, filepath * filename)
        write_ieq(filepath * "ieq/" * filename, convert(IEQ, games))
    end

end
