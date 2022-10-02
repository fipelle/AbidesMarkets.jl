# Dependencies
include("../src/AbidesMarkets.jl");
using Main.AbidesMarkets;
using Dates, Statistics, Test;

@testset "rmsc04 core functions" begin

    # Build runnable configuration
    config = AbidesMarkets.build_config("rmsc04", (seed=0, ));
    config_keys = sort(collect(keys(config))); # <- show keys in `config` in alphabetical order
    @test config_keys == some benchmark

    # Run simulation
    end_state = AbidesMarkets.run(config);

    # Retrieving results from `end_state`
    order_book = end_state["agents"][1].order_books["ABM"]; # Julia starts indexing from 1, not 0

    # Get L1 snapshots
    L1 = AbidesMarkets.get_L1_snapshots(order_book);
    @test L1.best_bids == some benchmark
    @test L1.best_asks == some other benchmark

    # Get L2 snapshots
    L2 = AbidesMarkets.get_L2_snapshots(order_book, 10);
    @test L2.times == some benchmark
    @test L2.bids == some other benchmark
    @test L2.asks == some other other benchmark
end