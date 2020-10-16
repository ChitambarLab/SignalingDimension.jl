export aff_ind_success_game_strategies, aff_ind_error_game_strategies

export aff_ind_generalized_error_game_strategies_d2, aff_ind_generalized_error_game_strategies_k2
"""
    aff_ind_success_game_strategies( N :: Int64, d :: Int64 ) :: Vector{Matrix{Int64}}

Enumerates an affinely independent set of deterministic, stochastic, `N x N` rank-`d`
matrices with trace equal to `d`. These matrices are all vertices of the success
game facet found on the signaling polytope where `N` describes the number of inputs
and `d` describes the signaling dimension of the communication channel.

A valid input requires `N > 2` and `N > d > 1`.
"""
function aff_ind_success_game_strategies(N :: Int64, d :: Int64) :: Vector{Matrix{Int64}}
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
    aff_ind_error_game_strategies(N :: Int64, d :: Int64, error_size :: Int64) :: Vector{Matrix{Int64}}

Enumerates an affinely independent set of vertices for the error game. The vertices
are `N x N`, rank-`d`, column stochastic matrices.

Valid inputs are `N > 4`, `N-1 > d > 1`, and `N-d+1 ≥ error_size ≥ 3`.
"""
function aff_ind_error_game_strategies(N :: Int64, d :: Int64, error_size :: Int64) :: Vector{Matrix{Int64}}
    # affiely independent vectors used to enumerate error block strategies
    error_vecs = sort(_aff_ind_vecs(d-1, N - (error_size + d - 2))) # sorting ensures the first element has a leading 0.

    # affinely independent vectors used to enumerate success block strategies
    success_vecs = _aff_ind_vecs(error_size + d - 3, N - error_size - d + 2)

    # initializing vector to hold matrix data
    matrices = Vector{Matrix{Int64}}(undef, N*(N-1))
    matrix_id = 1
    for row_id in 1:N

        # rows containing the error block are treated separately
        if row_id <= error_size

            # creating a strategy for each column in the error block excludin
            # the zero column at col_id = row_id.
            for i in filter(j -> j != row_id, 1:error_size)
                m = zeros(Int64, N,N)

                # maximize error block
                m[row_id, i] = 1
                m[i, filter(j -> j != i, 1:error_size)] .= 1

                # filling success block to saturate inequality
                for col_id in (error_size+1):N
                    el = error_vecs[1][col_id - (error_size - 1)]

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
                m[row_id, filter(j -> j != row_id, 1:error_size)] .= 1
                if vec[1] == 0
                    r_id = row_id == 1 ? 2 : 1
                    m[r_id,row_id] = 1
                else
                    m[row_id,row_id] = 1
                end

                # setting success block columns
                for col_id in (error_size+1):N
                    el = vec[col_id - (error_size - 1)]

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
                if c_id <= error_size
                    m[row_id, c_id] = 1
                    m[c_id, filter(j -> j != c_id, 1:error_size)] .= 1
                else
                    c_id = 1
                    r_id = d > 2 ? 2 : 1

                    m[r_id, c_id] = 1
                    m[c_id, filter(j -> j != c_id, 1:error_size)] .= 1
                end

                # filling in success block columns
                for i in error_size+1:N-1
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
    aff_ind_generalized_error_game_strategies_k2(
        N :: Int64, d :: Int64, k :: Int64
    ) :: Vector{Matrix{Int64}}

Enumerates an affinely independent set of vertices for the generalized error game.
The vertices are `N x binomial(N,k)`, rank-`d`, column stochastic matrices.
This function is restricted to `k = 2` and `N = d + k`.

Valid inputs are `N > 4`, `k = 2`, and `d = N - k`.
"""
function aff_ind_generalized_error_game_strategies_k2(N :: Int64, d :: Int64, k :: Int64) :: Vector{Matrix{Int64}}
    if !(k == 2)
        throw(DomainError(k, "k > 2 not supported by this function"))
    elseif !(N == k+d)
        throw(DomainError(d, "N ≂̸ k+d not implemented yet"))
    end

    if N == 4 && d == 2
        return aff_ind_generalized_error_game_strategies_d2(N, d, k)
    else
        matrices = Vector{Matrix{Int64}}(undef, (N-1)*binomial(N,k))
        matrix_id = 1

        # expanding bottom right subblock strategies with constant top row
        br_subblock_matrices = aff_ind_generalized_error_game_strategies_k2(N-1, d-1, k)

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

        # enumerating all  d-success game strategies
        subblock_game = generalized_error_game(N-1,d-1,k)

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
    aff_ind_generalized_error_game_strategies_d2(
        N :: Int64, d :: Int64, k :: Int64
    ) :: Vector{Matrix{Int64}}

Enumerates an affinely independent set of vertices for the generalized error game.
The vertices are `N x binomial(N,k)`, rank-`d`, column stochastic matrices.
This function is restricted to games where `d = 2` and `N = d + k`.

Valid inputs are `N > 4`, `d = 2`, and `k = N - d`.
"""
function aff_ind_generalized_error_game_strategies_d2(N :: Int64, d :: Int64, k :: Int64) :: Vector{Matrix{Int64}}
    if !(d==2)
        throw(DomainError(d, "d > 2 not implemented yet"))
    elseif !(N == k+d)
        throw(DomainError(k, "k + d ≠ N not implemented yet"))
    end

    matrices = Vector{Matrix{Int64}}(undef, (N-1)*binomial(N,k))
    matrix_id = 1

    game = generalized_error_game(N,d,k)

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
Helper function for `aff_ind_success_game_strategies()`. Generates a set of binary
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
