# AbidesMarkets.jl
Julia wrapper for [ABIDES-Markets](https://github.com/jpmorganchase/abides-jpmc-public): a J.P. Morgan Chase's multi-agent discrete event simulator specialised for financial markets.

## Installation

### Preliminary setup 
This package uses [PyCall](https://github.com/JuliaPy/PyCall.jl) to load [ABIDES](https://github.com/jpmorganchase/abides-jpmc-public). within Julia. Therefore, the latter should be installed in the Python version being used by [PyCall](https://github.com/JuliaPy/PyCall.jl). On Mac and Windows systems, [PyCall](https://github.com/JuliaPy/PyCall.jl) will use [Conda](https://github.com/JuliaPy/Conda.jl) to install a separate version of Python that is private to Julia (by default). The following lines of code apply the necessary configurations:
`aa`

On GNU/Linux systems, [PyCall](https://github.com/JuliaPy/PyCall.jl) will default to using the python3 program (if any, otherwise python) in your PATH. In this case, ABIDES can be installed following the [official guide](https://github.com/jpmorganchase/abides-jpmc-public).

### Package installation
Having setup [PyCall](https://github.com/JuliaPy/PyCall.jl), AbidesMarkets.jl can then be installed with the Julia package manager.
From the Julia REPL, type `]` to enter the Pkg REPL mode and run:

```
pkg> add AbidesMarkets
```

Or, equivalently, via the `Pkg` API:

```julia
julia> import Pkg; Pkg.add("AbidesMarkets")
```
