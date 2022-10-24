"""
    parse_logs_df(end_state::Dict)

Takes the `end_state` dictionary returned by an ABIDES simulation, goes through all the agents, extracts their log, and un-nest them returns a single dataframe with the logs from all the agents warning.
"""
function parse_logs_df(end_state::Dict)
    parse_logs_df = pyimport("abides_core.utils").parse_logs_df;
    return parse_logs_df(end_state);
end

Dates.floor(X::Dates.Time, P::Dates.Period) = floor(DateTime("$(today())T$(X)", "yyyy-mm-ddTHH:MM:SS.s"), P) |> Time;
Dates.ceil(X::Dates.Time, P::Dates.Period) = ceil(DateTime("$(today())T$(X)", "yyyy-mm-ddTHH:MM:SS.s"), P) |> Time;

"""
    aggregate_LOB_measurement(X::Union{Vector{Float64}, JVector{Float64}}, times::Vector{Time}, time_step::Period, f::Function; f_args::Tuple=(), f_kwargs::NamedTuple=NamedTuple())

Aggregate `X` by taking its `f` transformation at the specified `time_step`.
"""
function aggregate_LOB_measurement(X::Union{Vector{Float64}, JVector{Float64}}, times::Vector{Time}, time_step::Period, f::Function; f_args::Tuple=(), f_kwargs::NamedTuple=NamedTuple())
    
    # Initialise output variables
    aggregated_times = floor(minimum(times), Minute(5)):time_step:ceil(maximum(times), Minute(5));
    aggregated_X = convert(JMatrix{Float64}, zeros(1, length(aggregated_times)));
    aggregated_X[1] = missing; # always skip the very first instant for internal consistency

    # Loop over each period
    for index in axes(aggregated_times, 1)
        
        # Skip the first instant
        if index > 1

            # Aggregation window
            window = aggregated_times[index-1] .< times .<= aggregated_times[index]; # always skip the very first instant for internal consistency
            X_window = collect(skipmissing(X[window]));

            # Aggregate and update `aggregated_X`
            if length(X_window) > 0 # implicitely controls both for the size of window and the number of missing observations in X_window
                f_index_output = f(X_window, f_args...; f_kwargs...);
                if length(f_index_output) == 1
                    aggregated_X[1, index] = f_index_output[1];
                else
                    error("`f` returns a vector output!");
                end
            else
                aggregated_X[1, index] = missing;
            end
        end
    end
    
    # Return output
    return aggregated_X, aggregated_times;
end

"""
    aggregate_LOB_measurement_eop(X::Union{Vector{Float64}, JVector{Float64}}, times::Vector{Time}, time_step::Period)

Aggregate `X` by returing the EOP measurement taken at the specified `time_step`.
"""
aggregate_LOB_measurement_eop(X::Union{Vector{Float64}, JVector{Float64}}, times::Vector{Time}, time_step::Period) = aggregate_LOB_measurement(X, times, time_step, last);

"""
    aggregate_LOB_measurement_avg(X::Union{Vector{Float64}, JVector{Float64}}, times::Vector{Time}, time_step::Period)

Aggregate `X` by returing the average (non-overlapping) measurement taken at the specified `time_step`.
"""
aggregate_LOB_measurement_avg(X::Union{Vector{Float64}, JVector{Float64}}, times::Vector{Time}, time_step::Period) = aggregate_LOB_measurement(X, times, time_step, mean; f_kwargs=(dims=1, ));

"""
    compare_aggregated_LOB_measurements(X::JMatrix{Float64}, Y::JMatrix{Float64}, f_ticks::Function, f_time::Function)

Compare two vectors of aggregated LOB measurements. 

Each column of `X` and `Y` denotes a different point in time, while each row is a different entry (perhaps different levels).
"""
function compare_aggregated_LOB_measurements(X::JMatrix{Float64}, Y::JMatrix{Float64}, f_ticks::Function, f_time::Function; f_ticks_args::Tuple=(), f_ticks_kwargs::NamedTuple=NamedTuple(), f_time_args::Tuple=(), f_time_kwargs::NamedTuple=NamedTuple())

    # Loop over each point in time
    statistics_ticks = zeros(size(X, 1));
    for index in axes(X, 2)
        statistics_ticks[index] = f_ticks(X[:, index], Y[:, index], f_ticks_args...; f_ticks_kwargs...);
    end
    
    # Return output
    return f_time(statistics_ticks, f_time_args...; f_time_kwargs...);
end

"""
    compare_aggregated_LOB_measurements_mse(X::JMatrix{Float64}, Y::JMatrix{Float64})

Compare two vectors of aggregated LOB measurements through the MSE.
"""
compare_aggregated_LOB_measurements_mse(X::JMatrix{Float64}, Y::JMatrix{Float64}) = compare_aggregated_LOB_measurements(X, Y, (x, y) -> mean(skipmissing(x-y).^2), mean);

"""
    aggregate_L2_snapshot(X::SnapshotL2, time_step::Period, f::Function; f_args::Tuple=(), f_kwargs::NamedTuple=NamedTuple())

Aggregate `X` by taking its `f` transformation at the specified `time_step`.
"""
function aggregate_L2_snapshot(X::SnapshotL2, time_step::Period, f::Function; f_args::Tuple=(), f_kwargs::NamedTuple=NamedTuple())
    
    # Get number of L2 levels
    nlevels = size(X.bids, 2);

    # Memory pre-allocation for output's components
    aggregated_times = floor(minimum(L2.times), Minute(5)):time_step:ceil(maximum(L2.times), Minute(5));
    aggregated_bids = convert(JArray{Float64}, zeros(length(aggregated_times), nlevels, 2));
    aggregated_asks = convert(JArray{Float64}, zeros(length(aggregated_times), nlevels, 2));

    # Loop over prices and volumes
    for j=1:2

        # Loop over levels
        for i=1:nlevels
            aggregated_bids[:, i, j], _ = aggregate_LOB_measurement(X.bids[:, i, j], times, time_step, f, f_args=f_args, f_kwargs=f_kwargs);
            aggregated_asks[:, i, j], _ = aggregate_LOB_measurement(X.asks[:, i, j], times, time_step, f, f_args=f_args, f_kwargs=f_kwargs);
        end
    end

    # Generate and return aggregated L2 snapshot
    return SnapshotL2(aggregated_times, aggregated_bids, aggregated_asks);
end

"""
    aggregate_L2_snapshot_eop(X::SnapshotL2, times::Vector{Time}, time_step::Period)

Aggregate `X` by returing the EOP measurement taken at the specified `time_step`.
"""
aggregate_L2_snapshot_eop(X::SnapshotL2, times::Vector{Time}, time_step::Period) = aggregate_L2_snapshot(X, times, time_step, last);

"""
    aggregate_L2_snapshot_avg(X::SnapshotL2, times::Vector{Time}, time_step::Period)

Aggregate `X` by returing the average (non-overlapping) measurement taken at the specified `time_step`.
"""
aggregate_L2_snapshot_avg(X::SnapshotL2, times::Vector{Time}, time_step::Period) = aggregate_L2_snapshot(X, times, time_step, mean; f_kwargs=(dims=1, ));
