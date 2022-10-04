"""
    parse_logs_df(end_state::Dict)

Takes the `end_state` dictionary returned by an ABIDES simulation, goes through all the agents, extracts their log, and un-nest them returns a single dataframe with the logs from all the agents warning.
"""
function parse_logs_df(end_state::Dict)
    parse_logs_df = pyimport("abides_core.utils").parse_logs_df;
    return parse_logs_df(end_state);
end

"""
    aggregate_LOB_measurement(X::Vector{Float64}, times::DateTime, frequency::String, f::Function; f_args::Tuple, f_kwargs::NamedTuple)


"""
function aggregate_LOB_measurement(X::Vector{Float64}, times::DateTime, frequency::String, f::Function; f_args::Tuple, f_kwargs::NamedTuple)
    
    # Error management
    if frequency ∉ ["seconds", "minutes", "hours"]
        error("Frequency must be either 'seconds', 'minutes' or 'hours'!");
    end

    # Time aggregation with `f`
    
end

"""
    eop_LOB_measurement(X::Vector{Float64}, times::DateTime, frequency::String)

Aggregate `X` by returing the EOP measurement taken at the specified `frequency`.
"""
eop_LOB_measurement(X::Vector{Float64}, times::DateTime, frequency::String) = aggregate_LOB_measurement(X, times, frequency, last);

"""
    avg_LOB_measurement(X::Vector{Float64}, times::DateTime, frequency::String)

Aggregate `X` by returing the average (non-overlapping) measurement taken at the specified `frequency`.
"""
avg_LOB_measurement(X::Vector{Float64}, times::DateTime, frequency::String) = aggregate_LOB_measurement(X, times, frequency, mean; f_kwargs=(dims=1, ));