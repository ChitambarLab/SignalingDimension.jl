using Test, ArgParse
using SignalingDimension

try print_test_results catch err
    include("../utilities.jl")
    using .ScriptUtilities: print_test_results
end

# parsing command line arguments
arg_table = ArgParseSettings()
@add_arg_table! arg_table begin
    "-N"
        help = "max number of inputs/outputs to consider"
        arg_type = Int64
        default = 45
    "--dir"
        help = "directory to print results .txt to"
        arg_type = String
        default = "./script/facet_verifications/results/"
    "--stdout"
        help = "Print output to STDOUT. If not flagged, output is printed to `.txt` file."
        action = :store_true
end
args = parse_args(ARGS, arg_table)

# verification script: verifies all maximum likelihood facets with N ∈ [3, N_max]
function verify_maximum_likelihood_facet(N_max :: Int64)
    @testset "Testing all maximum likelihood facets of size `($N_max, $N_max)` or less." begin
        @testset "scanning over all `d ∈ [2, $N - 1]`" for N in 3:N_max
            @testset "Verifying N = $N and d = $d" for d in 2:N-1
                vertices = aff_ind_maximum_likelihood_vertices(N,d)
                facet = maximum_likelihood_facet(N,d)

                @test verify_facet(d, facet, vertices)
            end
        end
    end
end

# outputting result to file or stdout
print_test_results(
    verify_maximum_likelihood_facet,
    params=[args["N"]],
    stdout=args["stdout"],
    dir=args["dir"]
)
