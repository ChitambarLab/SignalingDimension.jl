for script in readdir("./script/quick_adjacency_decomposition")
    # run only julia files in ./script/quick_adjacency_decomposition/ directory
    if occursin(r"^.*\.jl$", script) && !occursin(r"^run_all\.jl$", script)
        println("./quick_adjacency_decomposition/$script")
        @time include("./$script")
    end
end
