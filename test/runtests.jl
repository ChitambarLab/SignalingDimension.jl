using Test, BellScenario, LinearAlgebra, Suppressor

println("importing SignalingDimension.jl")
@time using SignalingDimension

function _test_runner()
    @testset "SignalingDimension.jl" begin
        @testset "unit tests:" begin
            println("running unit tests.")
            for test in readdir("./test/unit/")
                # run only julia files in test directory
                if occursin(r"^.*\.jl$", test)
                    println("./unit/$test")
                    @time include("./unit/$test")
                end
            end
        end
    end
end

# Pkg.test("SignalingDimension") runs from ./test directory. Development tests from root.
dir = pwd()
if occursin(r".*test$", dir)
    cd(_test_runner, "../")
elseif occursin(r".*SignalingDimension", dir)
    _test_runner()
else
    error("runtests.jl is currently running from the $(pwd()) directory with contents $(readdir()). runtests.jl must be run from the ./SignalingDimension.jl or ./SignalingDimension.jl/test directories.")
end
