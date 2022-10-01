__precompile__()

module AbidesMarkets

    # Dependencies
    using DataFrames, DataFramesMeta, Dates, Logging, MessyTimeSeries, PyCall, Statistics;

    # Custom dependencies
    local_path = dirname(@__FILE__);
    include("$(local_path)/core.jl");

    # Export
    export build_config, run, get_L1_snapshots, parse_logs_df;
end