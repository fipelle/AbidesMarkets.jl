"""
    SnapshotL1(...)

Structure containing the L1 snapshots.
"""
struct SnapshotL1
    best_bids::JMatrix{Float64}
    best_asks::JMatrix{Float64}
end

"""
    SnapshotL2(...)

Structure containing the L2 snapshots.
"""
struct SnapshotL2
    times::Vector{Time}
    bids::JArray{Float64, 3}
    asks::JArray{Float64, 3}
end
