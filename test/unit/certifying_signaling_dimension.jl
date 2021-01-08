using Test, BellScenario, LinearAlgebra

@testset "./src/certifying_signaling_dimension.jl" begin

using SignalingDimension

@testset "maximum_likelihood_lower_bound()" begin
    @test 3 == maximum_likelihood_lower_bound(Strategy([1 0 0;0 0.5 0;0 0 0.5;0 0.5 0.5]))
    @test 1 == maximum_likelihood_lower_bound(Strategy(1/5*ones(5,5)))
    @test 2 == maximum_likelihood_lower_bound(DeterministicStrategy([1 0 1 0;0 1 0 1;0 0 0 0;0 0 0 0]))
end

end
