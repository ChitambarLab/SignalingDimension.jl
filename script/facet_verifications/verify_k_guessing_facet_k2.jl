using Test, ArgParse
using SignalingDimension

try print_test_results catch err
    include("../utilities.jl")
    using .ScriptUtilities: print_test_results
end
# parsing command line arguments
arg_table = ArgParseSettings()
@add_arg_table! arg_table begin
    "-Y"
        help = "max number of outputs to consider"
        arg_type = Int64
        default = 24
    "--dir"
        help = "directory to print results .txt to"
        arg_type = String
        default = "./script/facet_verifications/results/"
    "--stdout"
        help = "Print output to STDOUT. If not flagged, output is printed to `.txt` file."
        action = :store_true
end
args = parse_args(ARGS, arg_table)

# verification script: verifies all k-guessing facets with Y ∈ [4, Y_max] and k = 2
function verify_k_guessing_facet_k2(Y_max :: Int64)
    @testset "Testing all k-guessing facets with `k = 2` and `Y ≤ $Y_max`." begin
        @testset "Verifying Y = $Y, d = $(Y - 2), and k = 2" for Y in 4:Y_max
            k = 2
            d = Y - k
            vertices = aff_ind_k_guessing_vertices(Y, d, k)
            facet = k_guessing_facet(Y, d, k)

            @test verify_facet(d, facet, vertices)
        end
    end
end

# outputting result to file or stdout
print_test_results(
    verify_k_guessing_facet_k2,
    params=[args["Y"]],
    stdout=args["stdout"],
    dir=args["dir"]
)
