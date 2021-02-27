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
        default = 35
    "--dir"
        help = "directory to print results .txt to"
        arg_type = String
        default = "./script/facet_verifications/results/"
    "--stdout"
        help = "Print output to STDOUT. If not flagged, output is printed to `.txt` file."
        action = :store_true
end
args = parse_args(ARGS, arg_table)

# verification script: verifies all anti-guessing facets with N ∈ [4, N_max]
function verify_anti_guessing_facet(N_max :: Int64)
    @testset "Testing all anti-guessing facets of size `($N_max, $N_max)` or less." begin
        @testset "Scanning over all `d ∈ [2, $N - 2]`" for N in 4:N_max
            @testset "Scanning over all `ε ∈ [3, $N - $d + 1]`" for d in 2:N-2
                @testset "Verifying N =  $N, d = $d, ε = $ε" for ε in 3:N-d+1
                    vertices = aff_ind_anti_guessing_vertices(N, d, ε)
                    facet = anti_guessing_facet(N, d, ε)

                    @test verify_facet(d, facet, vertices)
                end
            end
        end
    end
end

# outputting result to file or stdout
print_test_results(
    verify_anti_guessing_facet,
    params=[args["N"]],
    stdout=args["stdout"],
    dir=args["dir"]
)
