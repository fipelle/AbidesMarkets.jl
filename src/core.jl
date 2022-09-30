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