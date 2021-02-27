export verify_facet

"""
    verify_facet(
        d :: Int64,
        facet :: BellScenario.BellGame,
        aff_ind_vertices :: Vector{Matrix{Int64}}
    ) :: Bool

Returns `true` if the affinely independent set of vertices
`aff_ind_vertices` verifies that the `facet` is indeed a tight Bell inequality
of the ``\\matcal{C}_d^{X \\to Y}`` signaling polytope.
Input `d` must align with the considered facet.
This method checks that all provided vertices are:
* extreme points of the ``\\mathcal{C}_d^{X \\to Y}`` signaling polytope
* satisfy the facet inequality with equality
* affinely independent

!!! note "Note"
    This method does not check that all signaling polytope vertices satisfy the
    facet inequality. For the cataloged Bell inequalities, this requirement can be
    analytically shown to hold in general. To verify the tightness of the
    Bell inequality, it therefore remains to find a sufficient number of affinely
    independent vertices that saturate the inequality.
"""
function verify_facet(d :: Int64, facet :: BellScenario.BellGame, aff_ind_vertices :: Vector{Matrix{Int64}}) :: Bool
    (Y, X) = size(facet)
    polytope_dim = X*(Y-1)

    _verify_vertex(v) = (
        rank(v) == d
        && facet[:]'*v[:] == facet.β
        && is_deterministic(v)
    )

    all_valid_vertices = all(_verify_vertex, aff_ind_vertices)

    affine_independence = (
        length(aff_ind_vertices) == polytope_dim
        && LocalPolytope.dimension(aff_ind_vertices) == polytope_dim - 1
    )

    (all_valid_vertices && affine_independence)
end
