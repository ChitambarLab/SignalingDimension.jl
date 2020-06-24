using PrepareAndMeasureAnalysis
using Documenter

makedocs(;
    modules=[PrepareAndMeasureAnalysis],
    authors="Brian Doolittle <brian.d.doolittle@gmail.com> and contributors",
    repo="https://github.com/ChitambarLab/PrepareAndMeasureAnalysis.jl/blob/{commit}{path}#L{line}",
    sitename="PrepareAndMeasureAnalysis.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://ChitambarLab.github.io/PrepareAndMeasureAnalysis.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ChitambarLab/PrepareAndMeasureAnalysis.jl",
)
