using Test

using BellScenario

using LinearAlgebra


game = [
    1 1 0 0 0 0 0 0;
    1 0 1 0 0 0 0 0;
    0 1 1 0 0 0 0 0;
    0 0 0 1 0 0 0 0;
]

facet = game'[:]


vertices = BellScenario.LocalPolytope.vertices((8,1),(1,4),dits=2,rep="generalized")
det_strats = BellScenario.LocalPolytope.behavior_to_strategy.(8,4,vertices)


@time for i in 1:100000
    (facet' * vertices[1])[1] == 3
end

@time for i in 1:100000
    game[:]' * det_strats[1][:] == 3
end

facet_vs = filter(v -> (facet' * v[:])[1] == 3 , vertices)

lin_dep_vecs = map( i -> facet_vs[i] .- facet_vs[1], 2:length(facet_vs) )

hcat(lin_dep_vecs...)


rank(hcat(lin_dep_vecs...))
