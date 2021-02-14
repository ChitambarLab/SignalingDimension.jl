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
            0.35 0.35 0.35;
            0.3  0.3  0.3;
        ])

        @test 2 == ambiguous_lower_bound(P, 4)
        @test 3 == ambiguous_lower_bound(P, 3)

        # test over all numbers of ambiguous rows
        @test 3 == ambiguous_lower_bound(P)
    end

    @testset "witnesses d=2 signaling dimension" begin
        P = DeterministicStrategy([1 0 0 1;0 1 1 0;0 0 0 0;0 0 0 0])

        @test 2 == ambiguous_lower_bound(P)
    end

    @testset "pre-sorting edge cases" begin
        @testset "edge case: primary sort by row sum, secondary by max-min diff is not optimal" begin
            P1 = Strategy([
                0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1;
                0.9 0   0   0   0   0   0   0  ;
                0   0.9 0   0   0   0   0   0  ;
                0   0   0.9 0   0   0   0   0  ;
                0   0   0   0.9 0   0   0   0  ;
                0   0   0   0   0.9 0   0   0  ;
                0   0   0   0   0   0.9 0   0  ;
                0   0   0   0   0   0   0.9 0  ;
                0   0   0   0   0   0   0   0.9;
            ])

            P2 = Strategy([
                0.9 0   0   0   0   0   0   0  ;
                0   0.9 0   0   0   0   0   0  ;
                0   0   0.9 0   0   0   0   0  ;
                0   0   0   0.9 0   0   0   0  ;
                0   0   0   0   0.9 0   0   0  ;
                0   0   0   0   0   0.9 0   0  ;
                0   0   0   0   0   0   0.9 0  ;
                0   0   0   0   0   0   0   0.9;
                0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1;
            ])


            @test 7 == SignalingDimension._ambiguous_lower_bound(P1,8)
            @test 8 == SignalingDimension._ambiguous_lower_bound(P2,8)

            @test 8 == ambiguous_lower_bound(P1,8)
            @test 8 == ambiguous_lower_bound(P2,8)
        end

        @testset "edge case: primary sort by row sum, secondary by max-min diff is optimal" begin
            # primary sort by max - min diff, secondary by row sum
            P1a  = Strategy([
                0 0.1 0.5 0;
                0.6 0.6 0.5 1;
                0 0.3 0 0;
                0.4 0 0 0;
            ])
            P1b = Strategy([
                0.4 0.4 1 1 1 1 1 1 1 1;
                0.3 0 0 0 0 0 0 0 0 0;
                0.3 0 0 0 0 0 0 0 0 0;
                0 0.3 0 0 0 0 0 0 0 0;
                0 0.3 0 0 0 0 0 0 0 0;
            ])

            #  primary sort by row sum, secondary by max-min diff
            P2a = Strategy([
                0 0.3 0 0;
                0.4 0 0 0;
                0 0.1 0.5 0;
                0.6 0.6 0.5 1;
            ])
            P2b = Strategy([
                0.3 0 0 0 0 0 0 0 0 0;
                0.3 0 0 0 0 0 0 0 0 0;
                0 0.3 0 0 0 0 0 0 0 0;
                0 0.3 0 0 0 0 0 0 0 0;
                0.4 0.4 1 1 1 1 1 1 1 1;
            ])

            @test 2 == SignalingDimension._ambiguous_lower_bound(P1a,3)
            @test 3 == SignalingDimension._ambiguous_lower_bound(P2a,3)

            @test 2 == SignalingDimension._ambiguous_lower_bound(P1b,4)
            @test 3 == SignalingDimension._ambiguous_lower_bound(P2b,4)

            @test 3 == ambiguous_lower_bound(P1a,3)
            @test 3 == ambiguous_lower_bound(P2a,3)

            @test 3 == ambiguous_lower_bound(P1b,4)
            @test 3 == ambiguous_lower_bound(P2b,4)
        end
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
        @test 3 == ambiguous_lower_bound(P,3)
        @test attains_trivial_upper_bound(P)
    end
end

@testset "upper_bound()" begin
    @test 4 == upper_bound(Strategy([1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1]))
    @test 3 == upper_bound(Strategy([1 0 1 0;0 1 0 1;0 0 0 0;0 0 0 0;0 0 0 0]))
end

end
