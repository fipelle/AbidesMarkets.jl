"""
    build_config(kwargs::NamedTuple)

Build a configuration starting from the one of the official rmscXX templates.

# Notes
- More information on the templates is available at https://github.com/jpmorganchase/abides-jpmc-public.
"""
function build_config(config_suffix::String, kwargs::NamedTuple)
    rmscXX = pyimport("abides_markets.configs.$(config_suffix)");
    return rmscXX.build_config(kwargs...);
end

"""
    run(config::Dict)

Run simulation using the configuration in `config`.
"""
function run(config::Dict)
    abides = pyimport("abides_core.abides");
    return abides.run(config);
end

"""
    ndarray_to_matrix(X::Matrix{PyCall.PyObject})

Converts `X` into a JMatrix{Float64} handling `None` appropriately.

    ndarray_to_matrix(X::Matrix{Float64})

Converts `X` into a JMatrix{Float64} for internal consistency.
"""
function ndarray_to_matrix(X::Matrix{PyCall.PyObject})
    out = convert(JMatrix{Float64}, zeros(size(X)));
    for j in axes(out, 2), i in axes(out, 1)
        try
            out[i,j] = convert(Float64, X[i,j]);
        catch e
            if "$(e.val)" == "PyObject TypeError('must be real number, not NoneType')"
                out[i,j] = missing;
            else
                throw(e);
            end
        end
    end

    return out;
end

ndarray_to_matrix(X::Matrix{Float64}) = convert(JMatrix{Float64}, X);

"""
    get_L1_snapshots(order_book::PyObject)

Get the L1 snapshots from the order book in an ad-hoc Julia structure.
"""
function get_L1_snapshots(order_book::PyObject)
    L1_python = order_book.get_L1_snapshots();
    return SnapshotL1(
        ndarray_to_matrix(L1_python["best_bids"]), 
        ndarray_to_matrix(L1_python["best_asks"])
    );
end

"""
    adjust_L2_snapshots(X::Union{Array{Float64, 3}, Array{Int64, 3}})

Adjust inconsistent use of zeros at source to indicate missing observations in bids/asks.
"""
function adjust_L2_snapshots(X::Union{Array{Float64, 3}, Array{Int64, 3}})
    missing_entries = iszero.(view(X, :, :, 1)) .| iszero.(view(X, :, :, 2)); # zero prices or volumes at given price
    adjusted_X = convert(JArray{Float64}, X);
    adjusted_X[missing_entries, :] .= missing;
    return adjusted_X;
end

"""
    get_L2_snapshots(order_book::PyObject, nlevels::Int64)

Get the L2 snapshots from the order book in an ad-hoc Julia structure.
"""
function get_L2_snapshots(order_book::PyObject, nlevels::Int64)
    
    # Get L2 snapshot from Python
    L2_python = order_book.get_L2_snapshots(nlevels=nlevels);

    # Generate times
    times = Time[];
    for instant in L2_python["times"]
        push!(times, Time(unix2datetime(instant*1e-9)));
    end

    # Return output
    return SnapshotL2(
        times,
        adjust_L2_snapshots(L2_python["bids"]),
        adjust_L2_snapshots(L2_python["asks"])
    );
end