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

# verification script: verifies all ambiguous guessing facets with Y ∈ [4, Y_max]
function verify_ambiguous_guessing_facet(Y_max :: Int64)
    @testset "Testing all maximum likelihood facets with `Y ∈ [4, $Y_max]` or less." begin
        @testset "scanning over all `d ∈ [2, $Y - 2]`" for Y in 4:Y_max
            @testset "Verifying Y = $Y and d = $d" for d in 2:Y-2
                vertices = aff_ind_ambiguous_guessing_vertices(Y, d)
                facet = ambiguous_guessing_facet(Y, d)

                @test verify_facet(d, facet, vertices)
            end
        end
    end
end

# outputting result to file or stdout
print_test_results(
    verify_ambiguous_guessing_facet,
    params=[args["Y"]],
    stdout=args["stdout"],
    dir=args["dir"]
)
