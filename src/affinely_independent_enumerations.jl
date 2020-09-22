export aff_ind_success_game_strategies, aff_ind_error_game_strategies

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
