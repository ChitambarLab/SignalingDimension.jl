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
        default = 12
    "--dir"
        help = "directory to print results .txt to"
        arg_type = String
        default = "./script/facet_verifications/results/"
    "--stdout"
        help = "Print output to STDOUT. If not flagged, output is printed to `.txt` file."
        action = :store_true
end
args = parse_args(ARGS, arg_table)

# verification script: verifies all k-guessing facets with Y ∈ [6, Y_max], d > 2, and k > 2
function verify_k_guessing_facet(Y_max :: Int64)
    @testset "Testing all k-guessing facets with `k > 2`, `d > 2`, and `Y ≤ $Y_max`." begin
        @testset "Scanning over all `d ∈ [3, $Y - 3]`" for Y in 6:Y_max
            @testset "Scanning over all `ε ∈ [3, $Y - $d + 1]`" for d in 3:Y-3
                @testset "Verifying N =  $Y, d = $d, k = $Y - $d" begin
                    k = Y - d
                    vertices = aff_ind_k_guessing_vertices(Y, d, k)
                    facet = k_guessing_facet(Y, d, k)

                    @test verify_facet(d, facet, vertices)
                end
            end
        end
    end
end

# outputting result to file or stdout
print_test_results(
    verify_k_guessing_facet,
    params=[args["Y"]],
    stdout=args["stdout"],
    dir=args["dir"]
)
