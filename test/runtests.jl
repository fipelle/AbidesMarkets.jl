# Dependencies
include("../src/AbidesMarkets.jl");
using Main.AbidesMarkets;
using CSV, DataFrames, Dates, Statistics, Test;

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
    L2_times_benchmark = CSV.read("./benchmarks/rmsc04/L2_times.csv", DataFrame)[:, 2:end] |> JArray{Float64};
    @test sum(L2.times .== L2_times_benchmark) == length(L2.times);

    # - L2 bids
    L2_bids_p_benchmark = CSV.read("./benchmarks/rmsc04/L2_bids_p.csv", DataFrame)[:, 2:end] |> JArray{Float64};
    L2_bids_q_benchmark = CSV.read("./benchmarks/rmsc04/L2_bids_q.csv", DataFrame)[:, 2:end] |> JArray{Float64};
    @test L2.bids[:,:,1] == L2_bids_p_benchmark;
    @test L2.bids[:,:,2] == L2_bids_q_benchmark;

    # - L2 asks
    L2_asks_p_benchmark = CSV.read("./benchmarks/rmsc04/L2_asks_p.csv", DataFrame)[:, 2:end] |> JArray{Float64};
    L2_asks_q_benchmark = CSV.read("./benchmarks/rmsc04/L2_asks_q.csv", DataFrame)[:, 2:end] |> JArray{Float64};
    @test L2.asks[:,:,1] == L2_asks_p_benchmark;
    @test L2.asks[:,:,2] == L2_asks_q_benchmark;
end