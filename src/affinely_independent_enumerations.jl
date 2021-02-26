export aff_ind_maximum_likelihood_vertices
export aff_ind_anti_guessing_vertices
export aff_ind_non_negativity_vertices
export aff_ind_ambiguous_guessing_vertices
export aff_ind_k_guessing_vertices
export aff_ind_coarse_grained_input_ambiguous_guessing_vertices

"""
    aff_ind_maximum_likelihood_vertices( N :: Int64, d :: Int64 ) :: Vector{Matrix{Int64}}

Enumerates an affinely independent set of vertices that maximize the [`maximum_likelihood_facet`](@ref).

A `DomainError` is thrown if `N > d > 1` is not satisfied.
"""
function aff_ind_maximum_likelihood_vertices(N :: Int64, d :: Int64) :: Vector{Matrix{Int64}}
    if !(N > d > 1)
        throw(DomainError(d, "input `d` does not satisfy `N > d > 1`."))
    end

    aff_ind_vecs = _aff_ind_vecs(d-1, N-d)

    matrices = Vector{Matrix{Int64}}(undef, N*(N-1))
    id = 1
    for row_id in 1:N
        for vec in aff_ind_vecs
            m = zeros(Int64,N,N)
            m[row_id,row_id] = 1

            for col in 1:N-1
                col_id = col < row_id ? col : col + 1

                if vec[col] == 0
                    m[col_id,col_id] = 1
                else
                    m[row_id,col_id] = 1
                end
            end

            matrices[id] = m

            id += 1
        end
    end

    return matrices
end

"""
    aff_ind_non_negativity_vertices(
        X :: Int64,
        Y :: Int64
    ) :: Vector{Matrix{Int64}}

Enumerates an affinely independent set of deterministic, vertices that maximize
the [`non_negativity_facet`](@ref)

A `DomainError` is thrown if the inputs do not satisfy `X > 1` and  `Y > 1`.
"""
function aff_ind_non_negativity_vertices(X :: Int64, Y :: Int64) :: Vector{Matrix{Int64}}
    if !(Y > 1)
        throw(DomainError(Y, "Inputs must satisfy `Y > 1`"))
    elseif !(X > 1)
        throw(DomainError(X, "Inputs must satisfy `X > 1`"))
    end

    matrices = Vector{Matrix{Int64}}(undef, (Y-1)*(X))

    matrix_id = 1
    for row_id in 1:(Y-1)
        m1 = zeros(Int64, Y, X)
        m1[row_id,:] .= 1

        matrices[matrix_id] = m1
        matrix_id += 1

        for col_id in 2:X
            m2 = zeros(Int64, Y, X)
            m2[row_id,:] .= 1
            m2[row_id,col_id] = 0
            m2[Y,col_id] = 1

            matrices[matrix_id] = m2
            matrix_id += 1
        end
    end

    matrices
end

"""
    aff_ind_ambiguous_guessing_vertices(
        Y :: Int64,
        d :: Int64
    ) :: Vector{Matrix{Int64}}

Enumerates an affinely independent set of vertices that maximize the [`ambiguous_guessing_facet`](@ref).

A `DomainError` is thrown if the inputs don't satisfy the following requirements:
* `Y ≥ 4`
* `(Y - 2) ≥ d ≥ 2`
"""
function aff_ind_ambiguous_guessing_vertices(Y :: Int64, d :: Int64) :: Vector{Matrix{Int64}}
    if !(Y ≥ 4)
        throw(DomainError(Y, "Y must satisfy `Y ≥ 4`"))
    elseif !(Y-2 ≥ d ≥ 2)
        throw(DomainError(d, "d must satisfy `Y-2 ≥ d ≥ 2`"))
    end

    matrices = Vector{Matrix{Int64}}(undef, (Y-1)*(Y-1))
    matrix_id = 1

    maximum_likelihood_facet_strats = aff_ind_maximum_likelihood_vertices(Y-1, d)

    for strat in maximum_likelihood_facet_strats
        m = cat(strat, zeros(Int64,(1,Y-1)), dims=1)

        matrices[matrix_id] = m
        matrix_id += 1
    end

    vecs = _aff_ind_vecs(d-1, Y-d)
    for vec in vecs
        m = zeros(Int64, (Y,Y-1))
        m[Y,:] = vec

        for id in 1:(Y-1)
            if vec[id] == 0
                m[id,id] = 1
            end
        end

        matrices[matrix_id] = m
        matrix_id += 1
    end

    matrices
end

"""
    aff_ind_coarse_grained_input_ambiguous_guessing_vertices(
        Y :: Int64,
        d :: Int64
    ) :: Vector{Matrix{Int64}}

Enumerates an affinely independent set of vertices for the
[`coarse_grained_input_ambiguous_guessing_facet`](@ref).

A `DomainError` is thrown if the inputs don't satisfy the following requirements:
* `Y ≥ 4`
* `(Y - 2) ≥ d ≥ 2`
"""
function aff_ind_coarse_grained_input_ambiguous_guessing_vertices(Y :: Int64, d :: Int64) :: Vector{Matrix{Int64}}
    if !(Y ≥ 4)
        throw(DomainError(Y, "Y must satisfy `Y ≥ 4`"))
    elseif !(Y-2 ≥ d ≥ 2)
        throw(DomainError(d, "d must satisfy `Y-2 ≥ d ≥ 2`"))
    end

    matrices = Vector{Matrix{Int64}}(undef, (Y*(Y-1)))
    matrix_id = 1

    for strat in aff_ind_ambiguous_guessing_vertices(Y,d)
        target_rows = findall(i -> i ≠ 0, sum.(eachrow(strat)))

        target_row = (Y-1) in target_rows ? (Y-1) : min(target_rows...)

        m = zeros(Int64, Y,Y)
        m[1:Y,1:Y-1] = strat
        m[target_row,Y] = 1

        matrices[matrix_id] = m
        matrix_id += 1
    end

    for target_row in filter(i -> i ≠ Y-1, 2:Y)
        m = zeros(Int64, Y,Y)

        max_d = target_row in 1:d-1 ? d : d-1
        for id in 1:max_d
            m[id,id] = 1
        end

        m[target_row,max_d+1:end] .= 1

        matrices[matrix_id] = m
        matrix_id += 1
    end

    m = zeros(Int64 ,Y,Y)

    for id in 1:d-2
        m[id,id] = 1
    end

    m[Y,d-1:Y-1] .= 1
    m[Y-1,Y] = 1


    matrices[matrix_id] = m

    matrices
end

"""
    aff_ind_anti_guessing_vertices(N :: Int64, d :: Int64, ε :: Int64) :: Vector{Matrix{Int64}}

Enumerates an affinely independent set of vertices for the [`anti_guessing_facet`](@ref).

Valid inputs are `N ≥ 4`, `(N - 1) > d > 1`, and `(N - d + 1) ≥ ε ≥ 3`.
"""
function aff_ind_anti_guessing_vertices(N :: Int64, d :: Int64, ε :: Int64) :: Vector{Matrix{Int64}}
    if !(N ≥ 4)
        throw(DomainError(N, "N must satisfy `N ≥ 4`."))
    elseif !(N - 1 > d > 1)
        throw(DomainError(d, "d must satisfy `(N - 1) > d > 1`."))
    elseif !((N - d + 1) ≥ ε ≥ 3)
        throw(DomainError(ε, "ε must satisfy `(N - d + 1) ≥ ε ≥ 3`"))
    end

    # affiely independent vectors used to enumerate error block strategies
    error_vecs = sort(_aff_ind_vecs(d-1, N - (ε + d - 2))) # sorting ensures the first element has a leading 0.

    # affinely independent vectors used to enumerate success block strategies
    success_vecs = _aff_ind_vecs(ε + d - 3, N - ε - d + 2)

    # initializing vector to hold matrix data
    matrices = Vector{Matrix{Int64}}(undef, N*(N-1))
    matrix_id = 1
    for row_id in 1:N

        # rows containing the error block are treated separately
        if row_id <= ε

            # creating a strategy for each column in the error block excludin
            # the zero column at col_id = row_id.
            for i in filter(j -> j != row_id, 1:ε)
                m = zeros(Int64, N,N)

                # maximize error block
                m[row_id, i] = 1
                m[i, filter(j -> j != i, 1:ε)] .= 1

                # filling success block to saturate inequality
                for col_id in (ε+1):N
                    el = error_vecs[1][col_id - (ε - 1)]

                    if el == 0
                        m[col_id,col_id] = 1
                    else
                        m[row_id,col_id] = 1
                    end
                end

                # add matrix m to matrices
                matrices[matrix_id] = m
                matrix_id += 1
            end

            # enumerating the affinely ind. strategies for columns greater than
            # error block
            for vec in error_vecs[2:end]
                m = zeros(Int64, N,N)

                # setting error block columns
                m[row_id, filter(j -> j != row_id, 1:ε)] .= 1
                if vec[1] == 0
                    r_id = row_id == 1 ? 2 : 1
                    m[r_id,row_id] = 1
                else
                    m[row_id,row_id] = 1
                end

                # setting success block columns
                for col_id in (ε+1):N
                    el = vec[col_id - (ε - 1)]

                    if el == 0
                        m[col_id,col_id] = 1
                    else
                        m[row_id,col_id] = 1
                    end
                end

                # add matrix m to matrices
                matrices[matrix_id] = m
                matrix_id += 1
            end
        else
            # enumerating strategies for success block rows
            for vec in success_vecs
                m = zeros(Int64, N,N)
                m[row_id,row_id] = 1

                c_id = findfirst(j -> j == 1, vec)

                # filling in error block columns
                if c_id <= ε
                    m[row_id, c_id] = 1
                    m[c_id, filter(j -> j != c_id, 1:ε)] .= 1
                else
                    c_id = 1
                    r_id = d > 2 ? 2 : 1

                    m[r_id, c_id] = 1
                    m[c_id, filter(j -> j != c_id, 1:ε)] .= 1
                end

                # filling in success block columns
                for i in ε+1:N-1
                    el = vec[i]

                    col_id = i < row_id ? i : i + 1
                    if el == 1
                        m[row_id,col_id] = 1
                    else
                        # if d == 2, we need to place all 0 elements are mapped
                        # to first row
                        r_id = d > 2 ? col_id : c_id

                        m[r_id,col_id] = 1
                    end
                end

                # add matrix m to marices
                matrices[matrix_id] = m
                matrix_id += 1
            end
        end
    end

    return matrices
end

"""
    aff_ind_k_guessing_vertices(
        Y :: Int64, d :: Int64, k :: Int64
    ) :: Vector{Matrix{Int64}}

Enumerates an affinely independent set of vertices for the [`k_guessing_facet`](@ref).

A `DomainError` is thrown if the inputs do not satisfy `Y ≥ 4`, `d ≥ 2` and `k ≥ 2`.
"""
function aff_ind_k_guessing_vertices(Y :: Int64, d :: Int64, k :: Int64) :: Vector{Matrix{Int64}}
    if !(Y == k + d)
        throw(DomainError(Y, "`Y = k + d` must be satisfied"))
    elseif !( Y ≥ 4 && d ≥ 2 && k ≥ 2 )
        throw(DomainError((Y, k, d), "`Y ≥ 4`, `d ≥ 2`, and `k ≥ 2` must be satisfied"))
    end

    if d == 2
        return _aff_ind_k_guessing_vertices_d2(Y, d, k)
    elseif k == 2
        return _aff_ind_k_guessing_vertices_k2(Y, d, k)
    else
        matrices = Vector{Matrix{Int64}}(undef, (Y-1)*binomial(Y,k))
        matrix_id = 1

        # getting affinely independent matrices in the bottom right subblock
        br_subblock_matrices = aff_ind_k_guessing_vertices(Y-1, d-1, k)

        # expanding bottom right subblock strategies with constant top row
        for br_subblock in br_subblock_matrices
            m = zeros(Int64, Y, binomial(Y,k))
            m[2:end, (binomial(Y-1,k-1)+1):end] = br_subblock
            m[1, 1:(binomial(Y-1,k-1))] .= 1

            matrices[matrix_id] = m
            matrix_id += 1
        end

        br_subblock_game = k_guessing_facet(Y-1,d-1,k)

        # placing a 1 in each 0 element of top row
        for combo in combinations(1:Y-1, d-1)
            m = zeros(Int64, Y, binomial(Y,k))
            m[1, 1:(binomial(Y-1,k-1))] .= 1

            for combo_id in combo
                m[1+combo_id, (binomial(Y-1,k-1)+1):end] = br_subblock_game[combo_id,:]

                for col_id in (binomial(Y-1,k-1)+1):binomial(Y,k)
                    if sum(m[:,col_id]) > 1
                        m[1+combo_id, col_id] = 0
                    end
                end
            end

            for col_id in (binomial(Y-1,k-1)+1):binomial(Y,k)
                if sum(m[:,col_id]) == 0
                    m[1,col_id] = 1
                end
            end

            matrices[matrix_id] = m
            matrix_id += 1
        end

        bl_subblock_game = k_guessing_facet(Y-1,d,k-1)

        # placing a 0 in each 1 element of the top row
        for col_id in 1:binomial(Y-1,k-1)
            m = zeros(Int64, Y, binomial(Y,k))
            m[1,filter(i -> i != col_id, 1:binomial(Y-1,k-1))] .= 1

            target_row_id = findfirst(i -> i == 1, bl_subblock_game[:,col_id]) + 1

            m[target_row_id, col_id] = 1

            max_row_id = (target_row_id <= d) ? d : target_row_id

            for row_id in [2:d-1..., max_row_id]
                m[row_id, (binomial(Y-1,k-1)+1):end] = br_subblock_game[row_id-1,:]

                for col_id in (binomial(Y-1,k-1)+1):binomial(Y,k)
                    if sum(m[:,col_id]) > 1
                        m[row_id, col_id] = 0
                    end
                end
            end

            for col_id in (binomial(Y-1,k-1)+1):binomial(Y,k)
                if sum(m[:,col_id]) == 0
                    m[max_row_id, col_id] = 1
                end
            end

            matrices[matrix_id] = m
            matrix_id += 1
        end

        # affinely independent matrices for bottom left subblock
        bl_subblock_matrices = aff_ind_k_guessing_vertices(Y-1,d,k-1)

        # enumerating strategies in bottom left subblock not using top row
        for bl_subblock in bl_subblock_matrices
            m = zeros(Int64, Y, binomial(Y,k))

            m[2:end, 1:binomial(Y-1,k-1)] = bl_subblock

            non_zero_row_ids = filter(i -> sum(bl_subblock[i,1:end]) > 0, 1:Y-1)

            for row_id in non_zero_row_ids
                m[1+row_id, (binomial(Y-1,k-1)+1):end] = br_subblock_game[row_id,:]

                for col_id in (binomial(Y-1,k-1)+1):binomial(Y,k)
                    if sum(m[:,col_id]) > 1
                        m[1+row_id, col_id] = 0
                    end
                end
            end

            for col_id in (binomial(Y-1,k-1)+1):binomial(Y,k)
                if sum(m[:,col_id]) == 0
                    m[non_zero_row_ids[end], col_id] = 1
                end
            end

            matrices[matrix_id] = m
            matrix_id += 1
        end

        return matrices
    end
end

"""
    _aff_ind_k_guessing_vertices_k2(
        N :: Int64, d :: Int64, k :: Int64
    ) :: Vector{Matrix{Int64}}

Helper method for aff_ind_k_guessing_vertices.
Enumerates an affinely independent set of vertices for the generalized error game.
The vertices are `N x binomial(N,k)`, rank-`d`, column stochastic matrices.
This function is restricted to `k = 2` and `N = d + k`.

Valid inputs are `N > 4`, `k = 2`, and `d = N - k`.
"""
function _aff_ind_k_guessing_vertices_k2(N :: Int64, d :: Int64, k :: Int64) :: Vector{Matrix{Int64}}
    if !(k == 2)
        throw(DomainError(k, "k > 2 not supported by this function"))
    end

    if N == 4 && d == 2
        return _aff_ind_k_guessing_vertices_d2(N, d, k)
    else
        matrices = Vector{Matrix{Int64}}(undef, (N-1)*binomial(N,k))
        matrix_id = 1

        # expanding bottom right subblock strategies with constant top row
        br_subblock_matrices = _aff_ind_k_guessing_vertices_k2(N-1, d-1, k)

        for br_subblock in br_subblock_matrices
            m = zeros(Int64, N, binomial(N,k))
            m[1,1:d+1] .= 1
            m[2:end, d+2:end] = br_subblock

            matrices[matrix_id] = m
            matrix_id += 1
        end

        # placing a zero in each non-zero top row index
        for col_id in 1:N-1
            m = zeros(Int64, N, binomial(N,k))
            m[1+col_id,col_id] = 1
            m[1, filter(i -> i != col_id, 1:N-1)] .= 1

            col_marker = N
            for row_id in 2:d
                if row_id != d
                    m[row_id, col_marker:col_marker+N-row_id-1] .= 1
                    col_marker += N - row_id
                else
                    if col_id <= d-1
                        m[row_id, col_marker:end] .= 1
                    else
                        m[1+col_id, col_marker:end] .= 1
                    end
                end
            end

            matrices[matrix_id] = m
            matrix_id += 1
        end

        # enumerating all d-success game strategies
        subblock_game = k_guessing_facet(N-1,d-1,k)

        for combo in combinations(1:N-1, d)
            m = zeros(Int64, N, binomial(N,k))

            for combo_id in combo
                m[1+combo_id, N:end] = subblock_game[combo_id,:]

                for col_id in N:binomial(N,k)
                    if sum(m[:,col_id]) > 1
                        m[1+combo_id, col_id] = 0
                    end
                end

                m[1+combo_id, combo_id] = 1
            end

            target_col_id = filter(i -> !(i in combo), 1:N-1)[1]
            for combo_id in combo
                m_copy = copy(m)

                m_copy[1 + combo_id, target_col_id] = 1

                matrices[matrix_id] = m_copy
                matrix_id += 1
            end
        end

        # placing a 1 in each 0 element of top row
        for combo in combinations(1:N-1, d-1)
            m = zeros(Int64, N, binomial(N,k))
            m[1,1:N-1] .= 1

            for combo_id in combo
                m[1+combo_id, N:end] = subblock_game[combo_id,:]

                for col_id in N:binomial(N,k)
                    if sum(m[:,col_id]) > 1
                        m[1+combo_id, col_id] = 0
                    end
                end
            end

            for col_id in N:binomial(N,k)
                if sum(m[:,col_id]) == 0
                    m[1,col_id] = 1
                end
            end

            matrices[matrix_id] = m
            matrix_id += 1
        end

        return matrices
    end
end

"""
    _aff_ind_k_guessing_vertices_d2(
        N :: Int64, d :: Int64, k :: Int64
    ) :: Vector{Matrix{Int64}}

Helper method for aff_ind_k_guessing_vertices.
Enumerates an affinely independent set of vertices for the generalized error game.
The vertices are `N x binomial(N,k)`, rank-`d`, column stochastic matrices.
This function is restricted to games where `d = 2` and `N = d + k`.

Valid inputs are `N > 4`, `d = 2`, and `k = N - d`.
"""
function _aff_ind_k_guessing_vertices_d2(N :: Int64, d :: Int64, k :: Int64) :: Vector{Matrix{Int64}}
    if !(d==2)
        throw(DomainError(d, "d > 2 not implemented yet"))
    end

    matrices = Vector{Matrix{Int64}}(undef, (N-1)*binomial(N,k))
    matrix_id = 1

    game = k_guessing_facet(N,d,k)

    considered_cols = []
    prev_target_row = 1
    for target_rows in combinations(1:N, d)
        target_row = target_rows[1]
        considered_cols = (prev_target_row == target_row) ? considered_cols : []

        for target_col_id in 1:binomial(N,k)
            if target_col_id in considered_cols
                continue
            end

            m = zeros(Int64, N, binomial(N,k))

            m[target_rows[1],:] = game[target_rows[1],:]
            m[target_rows[2],:] = game[target_rows[2],:]

            if m[target_rows[1], target_col_id] == 0 && m[target_rows[2], target_col_id] == 0
                for col_id in filter(i -> i != target_col_id, 1:binomial(N,k))
                    if m[target_rows[1], col_id] == m[target_rows[2], col_id]
                        m[target_rows[1], col_id] = 1
                        m[target_rows[2], col_id] = 0
                    end
                end

                m1 = copy(m)
                m1[target_rows[1], target_col_id] = 1

                matrices[matrix_id] = m1
                matrix_id += 1

                m[target_rows[2], target_col_id] = 1

                matrices[matrix_id] = m
                matrix_id += 1

                push!(considered_cols, target_col_id)
            elseif m[target_rows[1], target_col_id] == m[target_rows[2], target_col_id]
                m[target_rows[1], target_col_id] = 0

                for col_id in filter(i -> i != target_col_id, 1:binomial(N,k))
                    if m[target_rows[1], col_id] == m[target_rows[2], col_id]
                        m[target_rows[1], col_id] = 1
                        m[target_rows[2], col_id] = 0
                    end
                end

                matrices[matrix_id] = m
                matrix_id += 1

                push!(considered_cols, target_col_id)
            end
        end

        prev_target_row = target_row
    end

    return matrices
end

"""
Helper function for `aff_ind_maximum_likelihood_vertices()`. Generates a set of binary
vectors with `num_zeros` and `num_ones`. The set contains `n` affinely independent
vectors where `n` is the length of the binary vectors.
"""
function _aff_ind_vecs(num_zeros :: Int64, num_ones :: Int64) :: Vector{Vector{Int64}}
    n = num_ones + num_zeros

    aff_ind_rows = Vector{Vector{Int64}}(undef, n)
    if num_zeros == 0 || num_ones == 0
        val = (num_zeros == 0) ? 1 : 0
        aff_ind_rows = [fill(val, n)]
    else
        for i in 1:n
            row = zeros(Int64, n)
            if i <= num_zeros + 1
                row[i] = 1
                row[num_zeros+2:end] .= 1
            else
                row[i+1:end] .= 1
                row[num_zeros:i-1] .= 1
            end

            aff_ind_rows[i] = row
        end

    end

    return aff_ind_rows
end
