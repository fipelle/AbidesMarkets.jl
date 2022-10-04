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

Aggregate `X` by taking its `f` transformation at the specified `time_step`.
"""
function aggregate_LOB_measurement(X::Vector{Float64}, times::Vector{Time}, time_step::Period, f::Function; f_args::Tuple=(), f_kwargs::NamedTuple=NamedTuple())
    
    # Initialise output variable
    aggregated_X = Float64[];
    
    # Convenient aggregator
    aggregated_times = minimum(times):time_step:maximum(times);

    # Loop over each period
    for index in axes(aggregated_times, 1)
        
        # Skip the first instant
        if index > 1

            # Aggregation window
            window = aggregated_times[index-1] .< times .<= aggregated_times[index]; # always skip the very first instant for internal consistency
            
            # Aggregate and push
            push!(aggregated_X, f(X[window], f_args...; f_kwargs...));
        end
    end
    
    # Return output
    return aggregated_X;
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