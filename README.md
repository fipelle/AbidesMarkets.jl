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
config = AbidesMarkets.build_config("rmsc04", NamedTuple());
println(sort(collect(keys(config)))); # <- show keys in `config` in alphabetical order

# Run simulation
end_state = AbidesMarkets.run(config);

# Retrieving results from `end_state`
order_book = end_state["agents"][1].order_books["ABM"]; # Julia starts indexing from 1, not 0
```