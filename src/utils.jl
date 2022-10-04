"""
    parse_logs_df(end_state::Dict)

Takes the `end_state` dictionary returned by an ABIDES simulation, goes through all the agents, extracts their log, and un-nest them returns a single dataframe with the logs from all the agents warning.
"""
function parse_logs_df(end_state::Dict)
    parse_logs_df = pyimport("abides_core.utils").parse_logs_df;
    return parse_logs_df(end_state);
end

"""
    aggregate_LOB_measurement(X::Vector{Float64}, times::Vector{Time}, time_step::Period, f::Function; f_args::Tuple, f_kwargs::NamedTuple)


"""
function aggregate_LOB_measurement(X::Vector{Float64}, times::Vector{Time}, time_step::Period, f::Function; f_args::Tuple, f_kwargs::NamedTuple)
    
    # Time aggregation with `f`
    aggregated_times = collect(minimum(times):time_step:maximum(times));
end

"""
    eop_LOB_measurement(X::Vector{Float64}, times::Vector{Time}, time_step::Period)

Aggregate `X` by returing the EOP measurement taken at the specified `time_step`.
"""
eop_LOB_measurement(X::Vector{Float64}, times::Vector{Time}, time_step::Period) = aggregate_LOB_measurement(X, times, time_step, last);

"""
    avg_LOB_measurement(X::Vector{Float64}, times::Vector{Time}, time_step::Period)

Aggregate `X` by returing the average (non-overlapping) measurement taken at the specified `time_step`.
"""
avg_LOB_measurement(X::Vector{Float64}, times::Vector{Time}, time_step::Period) = aggregate_LOB_measurement(X, times, time_step, mean; f_kwargs=(dims=1, ));