export aff_ind_success_game_strategies

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
                if vec[col] == 0
                    if col < row_id
                        m[col,col] = 1
                    else
                        m[col+1,col+1] = 1
                    end
                else
                    if col < row_id
                        m[row_id,col] = 1
                    else
                        m[row_id,col+1] = 1
                    end
                end
            end

            matrices[id] = m

            id += 1
        end
    end

    return matrices
end

function _aff_ind_vecs(num_zeros :: Int64, num_ones :: Int64) :: Vector{Vector{Int64}}
    len = num_ones + num_zeros

    aff_ind_rows = Vector{Vector{Int64}}(undef, len)
    for i in 1:len
        row = zeros(Int64,len)
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
