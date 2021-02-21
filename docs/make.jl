using SignalingDimension
using Documenter

using BellScenario
using QBase

makedocs(;
    modules=[SignalingDimension],
    authors="Brian Doolittle <brian.d.doolittle@gmail.com> and contributors",
    repo="https://github.com/ChitambarLab/SignalingDimension.jl/blob/{commit}{path}#L{line}",
    sitename="SignalingDimension.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://ChitambarLab.github.io/SignalingDimension.jl",
        assets=String["assets/custom.css"],
    ),
    pages=[
        "Home" => "index.md",
        "Background" => [
            "Signaling Correlations" => "background/signaling_correlations.md",
            "Signaling Polytopes" => "background/signaling_polytopes.md",
            "Signaling Dimension" => "background/signaling_dimension.md",
        ],
        "Bell Inequalities" => "bell_inequalities.md",
        "Certifying Signaling Dimension" => "certifying_signaling_dimension.md",
    ],
)

deploydocs(;
    repo="github.com/ChitambarLab/SignalingDimension.jl",
)
