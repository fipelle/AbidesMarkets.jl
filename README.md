# AbidesMarkets.jl
Julia wrapper for [ABIDES-Markets](https://github.com/jpmorganchase/abides-jpmc-public): a J.P. Morgan Chase's multi-agent discrete event simulator specialised for financial markets.

## Installation

### Preliminary setup 
This package uses [PyCall](https://github.com/JuliaPy/PyCall.jl) to load [ABIDES](https://github.com/jpmorganchase/abides-jpmc-public) within Julia. Therefore, the [ABIDES](https://github.com/jpmorganchase/abides-jpmc-public) should be installed in the Python version being used by [PyCall](https://github.com/JuliaPy/PyCall.jl). On Mac and Windows systems, [PyCall](https://github.com/JuliaPy/PyCall.jl) will use [Conda](https://github.com/JuliaPy/Conda.jl) to install a separate version of Python that is private to Julia by default. This version of Python has minor incompatibilities with the dependencies and it is therefore easier to switch to a different one in which [ABIDES](https://github.com/jpmorganchase/abides-jpmc-public) is correctly installed. This can be done by running:
```julia
ENV["PYTHON"] = "... path of the python executable ..."
import Pkg; Pkg.build("PyCall");
```

On GNU/Linux systems, [PyCall](https://github.com/JuliaPy/PyCall.jl) will default to using the python3 program (if any, otherwise python) in your PATH. Thus, as long as this version of Python has [ABIDES](https://github.com/jpmorganchase/abides-jpmc-public) installed, the previous lines of code should not be necessary.

### Package installation
Having setup [PyCall](https://github.com/JuliaPy/PyCall.jl), AbidesMarkets can then be installed with the Julia package manager.
From the Julia REPL, type `]` to enter the Pkg REPL mode and run:

```
pkg> add AbidesMarkets
```

Or, equivalently, via the `Pkg` API:

```julia
julia> import Pkg; Pkg.add("AbidesMarkets")
```

# Example

The following example shows how to replicate in Julia the [official demo](https://github.com/jpmorganchase/abides-jpmc-public/blob/main/notebooks/demo_ABIDES-Markets.ipynb) for ABIDES-Markets: 
```julia
# Dependencies
using AbidesMarkets;
using DataFrames, DataFramesMeta, Dates, Plots, Statistics;

# Build runnable configuration
config = AbidesMarkets.build_config("rmsc04", (seed=0, ));
println(sort(collect(keys(config)))); # <- show keys in `config` in alphabetical order

# Run simulation
end_state = AbidesMarkets.run(config);

# Retrieving results from `end_state`
order_book = end_state["agents"][1].order_books["ABM"]; # Julia starts indexing from 1, not 0

# Get L1 snapshots
L1 = AbidesMarkets.get_L1_snapshots(order_book);

# All times are in ns from 1970, this loop converts them to a more readable format
best_bids_time = Time[];
best_asks_time = Time[];
for i in axes(L1.best_bids, 1) # same as best_asks by default
    # x*1e-9 converts ns to seconds, the remaining part of the conversion is performed with the Dates library functions
    push!(best_bids_time, Time(unix2datetime(L1.best_bids[i, 1]*1e-9)));
    push!(best_asks_time, Time(unix2datetime(L1.best_asks[i, 1]*1e-9)));
end

# Generate plots for L1 output
fig = plot(best_bids_time, L1.best_bids[:, 2], linecolor=:orange, label=nothing);
plot!(fig, best_asks_time, L1.best_asks[:, 2], linecolor=:steelblue, label=nothing);
ylims!(fig, 100000-100, 100000+100);

# Order book history L2
L2 = AbidesMarkets.get_L2_snapshots(order_book, 10);
L2_times = Time[];
for instant in L2.times
    push!(L2_times, Time(unix2datetime(instant*1e-9)));
end

# Generate plots for L2 output (plotting fifth best bid and fifth best ask)
fig = plot(scatter(L2_times, L2.bids[:,5,1], markersize=2.5, markerstrokewidth=0, markercolor=:orange, label=nothing));
scatter!(fig, L2_times, L2.asks[:,5,1], markersize=2.5, markerstrokewidth=0, markercolor=:steelblue, label=nothing);
ylims!(fig, 100000-100, 100000+100);

aggregated_bids, aggregated_times = aggregate_LOB_measurement_avg(L2.bids[:,1,1], L2_times, Minute(1))
```