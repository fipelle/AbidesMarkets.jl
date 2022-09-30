__precompile__()

module AbidesMarkets

    # Dependencies
    using DataFrames, DataFramesMeta, DataStructures, Dates, Logging, PyCall, Statistics;

    # Custom dependencies
    local_path = dirname(@__FILE__);
    include("$(local_path)/core.jl");

    # Export
    export build_config, run;
end