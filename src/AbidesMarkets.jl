__precompile__()

module AbidesMarkets

    # Dependencies
    using DataFrames, DataFramesMeta, Dates, Logging, PyCall, Statistics;
    using MessyTimeSeries: JVector, JMatrix, JArray;

    # Custom dependencies
    local_path = dirname(@__FILE__);
    include("$(local_path)/types.jl");
    include("$(local_path)/core.jl");
    include("$(local_path)/utils.jl");
    
    # Export
    export SnapshotL1, SnapshotL2, build_config, run, get_L1_snapshots, get_L2_snapshots,
           parse_logs_df, aggregate_LOB_measurement, aggregate_LOB_measurement_eop, aggregate_LOB_measurement_avg,
           compare_aggregated_LOB_measurements, compare_aggregated_LOB_measurements_mse, aggregate_L2_snapshot_eop;
end
