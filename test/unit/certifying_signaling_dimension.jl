using Test, BellScenario, LinearAlgebra

@testset "./src/certifying_signaling_dimension.jl" begin

using SignalingDimension

@testset "maximum_likelihood_lower_bound()" begin
    @test 3 == maximum_likelihood_lower_bound(Strategy([1 0 0;0 0.5 0;0 0 0.5;0 0.5 0.5]))
    @test 1 == maximum_likelihood_lower_bound(Strategy(1/5*ones(5,5)))
    @test 2 == maximum_likelihood_lower_bound(DeterministicStrategy([1 0 1 0;0 1 0 1;0 0 0 0;0 0 0 0]))
end

@testset "ambiguous_lower_bound()" begin
    @testset "the number of ambiguous rows affects the lower bound" begin
        P = Strategy([
            0.35 0    0;
            0    0.35 0;
            0    0    0.35;
            0.3  0.3  0.3;
            0.35 0.35 0.35
        ])

        @test 2 == ambiguous_lower_bound(P, 1)
        @test 3 == ambiguous_lower_bound(P, 2)

        # test over all numbers of ambiguous rows
        @test 3 == ambiguous_lower_bound(P)
    end

    @testset "witnesses d=2 signaling dimension" begin
        P = DeterministicStrategy([1 0 0 1;0 1 1 0;0 0 0 0;0 0 0 0])

        @test 2 == ambiguous_lower_bound(P)
    end

    @testset "errors" begin
        P = Strategy([1 0 0;0 1 0;0 0 1])

        @test_throws DomainError ambiguous_lower_bound(P, 4)
        @test_throws DomainError ambiguous_lower_bound(P, 0)
    end
end

@testset "trivial_upper_bound()" begin
    @test 3 == trivial_upper_bound(Strategy([1 0 1;0 1 0;0 0 0;0 0 0]))
    @test 4 == trivial_upper_bound(Strategy([1 0 0 0 0 0;0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 1 1]))
end

@testset "attains_trivial_upper_bound()"  begin
    @test attains_trivial_upper_bound(Strategy([1 0 0;0 1 0;0 0 1]))
    @test !attains_trivial_upper_bound(Strategy([1 0 1;0 1 0;0 0 0]))

    @testset "strategy where ambiguous game must be tested" begin
        P = Strategy(1/2*[1 0 0;0 1 0;0 0 1;1 1 1])
        @test 2 == maximum_likelihood_lower_bound(P)
        @test 3 == ambiguous_lower_bound(P,1)
        @test attains_trivial_upper_bound(P)
    end
end

@testset "upper_bound()" begin
    @test 4 == upper_bound(Strategy([1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1]))
    @test 3 == upper_bound(Strategy([1 0 1 0;0 1 0 1;0 0 0 0;0 0 0 0;0 0 0 0]))
end

end
