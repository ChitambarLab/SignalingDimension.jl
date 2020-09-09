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
    error_vecs = sort(_aff_ind_vecs(d-1, N - (error_size + d - 2))) # sorting ensures the first element has a leading 0.
    success_vecs = _aff_ind_vecs(error_size + d - 3, N - error_size - d + 2)

    matrices = Vector{Matrix{Int64}}(undef, N*(N-1))

    id = 1
    for row_id in 1:N

        if row_id <= error_size

            for i in 1:error_size-1
                m = zeros(Int64, N,N)

                r_id = i < row_id ? i : i + 1
                m[r_id,row_id] = 1

                m[row_id, filter(j -> j != row_id, 1:error_size)] .= 1

                for col_id in (error_size+1):N
                    el = error_vecs[1][col_id - (error_size - 1)]

                    if el == 0
                        m[col_id,col_id] = 1
                    else
                        m[row_id,col_id] = 1
                    end
                end

                matrices[id] = m
                id += 1
            end

            for vec in error_vecs[2:end]
                m = zeros(Int64, N,N)

                m[row_id, filter(j -> j != row_id, 1:error_size)] .= 1

                if vec[1] == 0
                    r_id = row_id == 1 ? 2 : 1
                    m[r_id,row_id] = 1
                else
                    m[row_id,row_id] = 1
                end

                for col_id in (error_size+1):N
                    el = vec[col_id - (error_size - 1)]

                    if el == 0
                        m[col_id,col_id] = 1
                    else
                        m[row_id,col_id] = 1
                    end
                end

                matrices[id] = m
                id += 1
            end
        else
            for vec in success_vecs
                m = zeros(Int64, N,N)
                m[row_id,row_id] = 1

                c_id = findfirst(j -> j == 1, vec)

                if c_id <= error_size
                    println
                    m[row_id, c_id] = 1
                    m[c_id, filter(j -> j != c_id, 1:error_size)] .= 1
                else
                    c_id = 1
                    r_id = d > 2 ? 2 : 1

                    m[r_id, c_id] = 1
                    m[c_id, filter(j -> j != c_id, 1:error_size)] .= 1
                end

                for i in error_size+1:N-1
                    el = vec[i]

                    col_id = i < row_id ? i : i + 1
                    if el == 1
                        m[row_id,col_id] = 1
                    else
                        r_id = d > 2 ? col_id : c_id
                        m[r_id,col_id] = 1
                    end
                    # end
                end

                matrices[id] = m
                id += 1
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
    for i in 1:n
        row = zeros(Int64,n)
        if i <= num_zeros + 1
            row[i] = 1
            row[num_zeros+2:end] .= 1
        else
            row[i+1:end] .= 1
            row[num_zeros:i-1] .= 1
        end

        aff_ind_rows[i] = row
    end

    return aff_ind_rows
end
