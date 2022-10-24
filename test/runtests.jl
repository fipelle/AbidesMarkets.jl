# Dependencies
include("../src/AbidesMarkets.jl");
using Main.AbidesMarkets;
using CSV, DataFrames, Dates, MessyTimeSeries, Statistics, Test;

@testset "rmsc04 core functions" begin

    # Build runnable configuration
    config = AbidesMarkets.build_config("rmsc04", (seed=0, ));

    # Run simulation
    end_state = AbidesMarkets.run(config);

    # Retrieving results from `end_state`
    order_book = end_state["agents"][1].order_books["ABM"]; # Julia starts indexing from 1, not 0

    # Get L1 snapshots and compare them with the relevant Python benchmarks
    L1 = AbidesMarkets.get_L1_snapshots(order_book);
    L1_best_bids_benchmark = CSV.read("./benchmarks/rmsc04/L1_best_bids.csv", DataFrame)[:, 2:end] |> JArray{Float64};
    L1_best_asks_benchmark = CSV.read("./benchmarks/rmsc04/L1_best_asks.csv", DataFrame)[:, 2:end] |> JArray{Float64};
    @test sum(L1.best_bids .=== L1_best_bids_benchmark) == prod(size(L1.best_bids));
    @test sum(L1.best_asks .=== L1_best_asks_benchmark) == prod(size(L1.best_asks));

    # Get L2 snapshots and compare them with the relevant Python benchmarks
    L2 = AbidesMarkets.get_L2_snapshots(order_book, 10);

    # - L2 times
    # Commented out since L2.times is now converted directly into a Vector{Time} 
    # L2_times_benchmark = CSV.read("./benchmarks/rmsc04/L2_times.csv", DataFrame)[:, 2:end] |> JArray{Float64};
    # @test sum(L2.times .== L2_times_benchmark) == length(L2.times);
    
    # - L2 bids
    L2_bids_p_benchmark = CSV.read("./benchmarks/rmsc04/L2_bids_p.csv", DataFrame)[:, 2:end] |> JArray{Float64};
    L2_bids_q_benchmark = CSV.read("./benchmarks/rmsc04/L2_bids_q.csv", DataFrame)[:, 2:end] |> JArray{Float64};
    ind_not_missing_L2_bids_p = .~ismissing.(L2.bids[:, :, 1]);
    ind_not_missing_L2_bids_q = .~ismissing.(L2.bids[:, :, 2]);
    @test ind_not_missing_L2_bids_p == ind_not_missing_L2_bids_q;
    @test L2.bids[ind_not_missing_L2_bids_p, 1] == L2_bids_p_benchmark[ind_not_missing_L2_bids_p];
    @test L2.bids[ind_not_missing_L2_bids_q, 2] == L2_bids_q_benchmark[ind_not_missing_L2_bids_q];
    @test sum((L2_bids_p_benchmark[.~ind_not_missing_L2_bids_p] .== 0) .| (L2_bids_q_benchmark[.~ind_not_missing_L2_bids_q] .== 0)) == sum(.~ind_not_missing_L2_bids_p);
    
    # - L2 asks
    L2_asks_p_benchmark = CSV.read("./benchmarks/rmsc04/L2_asks_p.csv", DataFrame)[:, 2:end] |> JArray{Float64};
    L2_asks_q_benchmark = CSV.read("./benchmarks/rmsc04/L2_asks_q.csv", DataFrame)[:, 2:end] |> JArray{Float64};
    ind_not_missing_L2_asks_p = .~ismissing.(L2.asks[:, :, 1]);
    ind_not_missing_L2_asks_q = .~ismissing.(L2.asks[:, :, 2]);
    @test ind_not_missing_L2_asks_p == ind_not_missing_L2_asks_q;
    @test L2.asks[ind_not_missing_L2_asks_p, 1] == L2_asks_p_benchmark[ind_not_missing_L2_asks_p];
    @test L2.asks[ind_not_missing_L2_asks_q, 2] == L2_asks_q_benchmark[ind_not_missing_L2_asks_q];
    @test sum((L2_asks_p_benchmark[.~ind_not_missing_L2_asks_p] .== 0) .| (L2_asks_q_benchmark[.~ind_not_missing_L2_asks_q] .== 0)) == sum(.~ind_not_missing_L2_asks_p);
end