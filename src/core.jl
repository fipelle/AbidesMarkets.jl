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
    np_array_to_matrix(X::Matrix{PyCall.PyObject})

Converts `X` into a Matrix{Union{Missing, Float64}} handling `None` appropriately.

    np_array_to_matrix(X::Matrix{Float64})

Converts `X` into a Matrix{Union{Missing, Float64}} for internal consistency.
"""
function np_array_to_matrix(X::Matrix{PyCall.PyObject})
    out = zeros(size(X)) |> Matrix{Union{Missing, Float64}};
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

np_array_to_matrix(X::Matrix{Float64}) = convert(Matrix{Union{Missing, Float64}}, X);

"""
    get_L1_snapshots(order_book::PyObject)

Get the L1 snapshots from the order book.
"""
function get_L1_snapshots(order_book::PyObject)
    L1 = order_book.get_L1_snapshots();
    best_bids = np_array_to_matrix(L1["best_bids"]);
    best_asks = np_array_to_matrix(L1["best_asks"]);
    return best_bids, best_asks;
end