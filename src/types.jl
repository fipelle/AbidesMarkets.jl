"""
    SnapshotL1(...)

Structure containing the L1 snapshots.
"""
struct SnapshotL1
    best_bids::Matrix{Union{Missing, Float64}}
    best_asks::Matrix{Union{Missing, Float64}}
end

"""
    SnapshotL2(...)

Structure containing the L2 snapshots.
"""
struct SnapshotL2
    times::Vector{Int64}
    bids::Array{Float64, 3}
    asks::Array{Float64, 3}
end
