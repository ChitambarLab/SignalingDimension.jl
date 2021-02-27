using Test, Suppressor

# note, capturing test results does not work in a testset, this functionality is not tested
@testset "./script/utilities.jl" begin

include("../../script/utilities.jl")
using .ScriptUtilities: print_test_results, capture_test

test_pass() = @testset "test_method_pass()" begin @test true end
test_fail() = @testset "test_method_fail()" begin @test false end
test_args(x) = @testset "test_method_args()" begin @test x == 1 end
not_test_pass() = println("Hello World!")
not_test_fail() = throw(ErrorException("Hello World Failure!"))
not_test_args(x) = println(x)

@testset "print_test_results()" begin
    @testset "Boolean pass return values" begin
        pass = @suppress print_test_results(not_test_pass)
        @test pass

        pass = @suppress print_test_results(not_test_fail)
        @test !pass
    end

    @testset "test_pass() results print to STDOUT" begin
        output = @capture_out print_test_results(test_pass)

        @test occursin(r"Version :", output)
        @test occursin(r"(\[96aab1c2\])? SignalingDimension", output)
        @test occursin(r"Test Completed : \d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d\.\d+\n", output)
        @test occursin(r"Elapsed Time : \d+\.\d+\n", output)
        @test occursin(r"Test Method : test_pass\n", output)
        @test occursin(r"Test Args : \(\)\n", output)
        @test occursin(r"Test Pass : true\n", output)
    end

    @testset "test_args(1) results print to STDOUT" begin
        output = @capture_out print_test_results(test_args, params=[1])

        @test occursin(r"Version :", output)
        @test occursin(r"(\[96aab1c2\])? SignalingDimension", output)
        @test occursin(r"Test Completed : \d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d\.\d+\n", output)
        @test occursin(r"Elapsed Time : \d+\.\d+\n", output)
        @test occursin(r"Test Method : test_args\n", output)
        @test occursin(r"Test Args : \(1\)\n", output)
        @test occursin(r"Test Pass : true\n", output)
    end

    @testset "not_test_fail() results print to STDOUT" begin
        output = @capture_out print_test_results(not_test_fail)

        @test occursin(r"Version :", output)
        @test occursin(r"(\[96aab1c2\])? SignalingDimension", output)
        @test occursin(r"Test Completed : \d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d\.\d+\n", output)
        @test occursin(r"Elapsed Time : \d+\.\d+\n", output)
        @test occursin(r"Test Method : not_test_fail\n", output)
        @test occursin(r"Test Args : \(\)\n", output)
        @test occursin(r"Test Pass : false\n", output)
        @test occursin(r"Hello World Failure!", output)
    end

    @testset "prints to file" begin
        test_dir = mkdir("./test/unit/script_utilities_temp")

        print_test_results(test_pass, stdout=false, dir=test_dir)

        files = readdir(test_dir)

        @test length(files) == 1
        @test occursin(r"^test_pass_\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d\.\d+\.txt$", files[1])

        output = read(test_dir * "/" * files[1], String)

        @test occursin(r"Version :", output)
        @test occursin(r"(\[96aab1c2\])? SignalingDimension", output)
        @test occursin(r"Test Completed : \d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d\.\d+\n", output)
        @test occursin(r"Elapsed Time : \d+\.\d+\n", output)
        @test occursin(r"Test Method : test_pass\n", output)
        @test occursin(r"Test Args : \(\)\n", output)
        @test occursin(r"Test Pass : true\n", output)

        rm(test_dir, recursive = true)
    end
end

@testset "capture_test()" begin
    @testset "capture stdout from pass" begin
        output = capture_test(not_test_pass)
        @test output == (true, "Hello World!\n")
    end

    @testset "args passed to test method" begin
        output = capture_test(not_test_args, params=[57])
        @test output == (true, "57\n")
    end

    @testset "capture exception from fail" begin
        output = capture_test(not_test_fail)
        @test output == (false, "ErrorException(\"Hello World Failure!\")\n")
    end
end

end
