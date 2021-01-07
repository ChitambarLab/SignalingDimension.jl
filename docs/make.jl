using SignalingDimension
using Documenter

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
        "Signaling Correlations" => "signaling_correlations.md",
        "Signaling Dimension" => "signaling_dimension.md",
        "Signaling Polytope" => [
            "Overview" => "SignalingPolytope/overview.md",
            "General Facets" => "SignalingPolytope/general_facets.md",
        ],
        "Certifying Signaling Dimension" => "certifying_signaling_dimension.md",
    ],
)

deploydocs(;
    repo="github.com/ChitambarLab/SignalingDimension.jl",
)
