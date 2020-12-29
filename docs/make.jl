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
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Signaling Correlations" => [
            "Classical Channels" => "SignalingCorrelations/classical_channels.md",
            "Quantum Channels" => "SignalingCorrelations/quantum_channels.md",
            "Signaling Dimension" => "SignalingCorrelations/signaling_dimension.md",
        ],
        "Signaling Polytope" => [
            "Overview" => "SignalingPolytope/overview.md",
            "Vertices" => "SignalingPolytope/vertices.md",
            "Computing Facets" => "SignalingPolytope/facets.md",
            "General Facets" => "SignalingPolytope/general_facets.md",
            "Facet Proofs" => "SignalingPolyope/affinely_independent_enumerations.md",
        ],
        "Certifying Signaling Dimension" => [
            "Device-Independent Test for Signaling Dimension"  => "CertifyingSignalingDimension/device-independent_test.md",
        ],
    ],
)

deploydocs(;
    repo="github.com/ChitambarLab/SignalingDimension.jl",
)
