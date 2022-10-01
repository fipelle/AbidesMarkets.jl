# Dependencies
include("./AbidesMarkets.jl/src/AbidesMarkets.jl");
using Main.AbidesMarkets;
using DataFrames, DataFramesMeta, Dates, Plots, Statistics;

# Build runnable configuration
config = AbidesMarkets.build_config("rmsc04", (seed=0, ));
println(sort(collect(keys(config)))); # <- show keys in `config` in alphabetical order

# Run simulation
end_state = AbidesMarkets.run(config);

# Retrieving results from `end_state`
order_book = end_state["agents"][1].order_books["ABM"]; # Julia starts indexing from 1, not 0

# Get L1 and L2 snapshots
L1 = AbidesMarkets.get_L1_snapshots(order_book);
L2 = AbidesMarkets.get_L2_snapshots(order_book, 10);
