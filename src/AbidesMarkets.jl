__precompile__()

module AbidesMarkets

    # Dependencies
    using DataFrames, DataFramesMeta, Dates, Logging, MessyTimeSeries, PyCall, Statistics;
    using Infiltrator;

    # Custom dependencies
    local_path = dirname(@__FILE__);
    include("$(local_path)/types.jl");
    include("$(local_path)/core.jl");
    include("$(local_path)/utils.jl");
    
    # Export
    export build_config, run, get_L1_snapshots, parse_logs_df, aggregate_LOB_measurement, eop_LOB_measurement, avg_LOB_measurement;
end