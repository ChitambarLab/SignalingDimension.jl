module ScriptUtilities

using Test, Pkg, Suppressor, Dates

export print_test_results, capture_test

"""
    print_test_results( test_func;
        params=[] :: Vector{Any},
        stdout=true :: Bool,
        dir="./" :: String
    ) :: Bool

Prints the results the test results and meta data to `.txt.` file or `STDOUT`.
If results are printed to `.txt` file, then the file name is `"test_func_datetime.txt"`
where `"datetime"` is a stringified datetime.
This method returns a Boolean value which is `true` if the test passes and `false`
otherwise.

Arguments:
* `test_func` - a generic method that runs a `@testset`.
* `params` - optional keyword argument, which contains the parameters to run `test_func`.
* `stdout` - optional keyword argument, if `true` print results to `STDOUT` instead of `.txt` file.
* `dir` - optional keyword argument, directory to which `.txt` file is saved.

Results are printed in the form:

```
Version :    # SignalingDimension.jl version used

Status `~/.julia/dev/SignalingDimension.jl/script/Project.toml`
  [96aab1c2] SignalingDimension v0.1.1 [`..`]

Test Completed : 2021-02-26T10:17:26.049        # Datetime of test completion
Elapsed Time : 16.799114946                     # Time elapsed during test
Test Method : verify_maximumlikelihood_facet    # Test method used
Test Args : (30)                                # Arguments used for test method
Test Pass : true                                # All tests pass

Test Summary:                                                     | Pass  Total
Testing all maximum likelihood facets of size `(30, 30)` or less. |  406    406
```

!!! warning "Do not run within @testset"
    Running within a @testset prevents the test results from being properly captured.
    If this method must be run in a testset, then `test_func` not contain a testset
    and instead print results to STDOUT and throw an exception on failure.
"""
function print_test_results(test_func; params=[] :: Vector{Any}, stdout=true :: Bool, dir="./" :: String) :: Bool
    name = string(test_func)
    datetime = string(now())

    filename = join([dir, "/", name, "_", datetime, ".txt"])

    elapsed_time = @elapsed (pass, results) = capture_test(test_func, params=params)

    version = @capture_out Pkg.status("SignalingDimension")

    results_string = join([
        "Version :\n\n", version,
        "\nTest Completed : ", datetime,
        "\nElapsed Time : ", elapsed_time,
        "\nTest Method : ", name,
        "\nTest Args : ", "(" * join(params, ", ") * ")",
        "\nTest Pass : ", string(pass),
        "\n\n", results
    ])

    if !stdout
        open(filename, "w") do io
            println(io, results_string)
        end
    else
        println(results_string)
    end

    return pass
end

"""
    capture_test(test_func; params=[] :: Vector{Any}) :: Tuple{Bool, String}

Captures the `STDOUT` and pass staus of the provided `test_func`.
A tuple is returned as `(pass, results)` where `pass` is a boolean indicating if
the test passedand `results` is a string containing the `STDOUT` from `test_func`.

Arguments:
* `test_func` - a generic method that runs a `@testset`.
* `params` - optional keyword argument, which contains the parameters to run `test_func`.

!!! warning "Do not run within @testset"
    Running within a @testset prevents the test results from being properly captured.
    If this method must be run in a testset, then `test_func` not contain a testset
    and instead print results to STDOUT and throw an exception on failure.
"""
function capture_test(test_func; params=[] :: Vector{Any}) :: Tuple{Bool, String}
    pass = nothing
    results = @capture_out try
        test_func(params...); pass = true
    catch err
        println(err); pass = false
    end

    (pass, results)
end

end  # module ScriptUtilities
