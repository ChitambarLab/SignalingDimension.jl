# runs all scripts in the facet_verifications directory
script_dir = "./script/facet_verifications/"
println("running all facet verification scripts")

expected_num_scripts = 6

pass_list = []
for file in readdir(script_dir)
    if occursin(r"run_all\.jl$", file)
        continue
    elseif occursin(r"\.jl$", file)
        println("running $file")
        @time test_pass = include(file)
        push!(pass_list, test_pass)
        println("test pass? : ", test_pass)
    end
end

if expected_num_scripts == length(pass_list)
    println("Ran all expected scripts")
else
    throw(ErrorException("Not all scripts ran"))
end

if all(pass_list)
    println("All facets verified.")
else
    throw(ErrorException("An failure occurred while running facet verifications"))
end
