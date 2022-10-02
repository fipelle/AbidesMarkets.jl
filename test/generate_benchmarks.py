# Dependencies
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
from abides_core import abides
from abides_core.utils import parse_logs_df, ns_date, str_to_ns, fmt_ts
from abides_markets.configs import rmsc04

# Build runnable configuration
config = rmsc04.build_config(seed=0)
sorted(config.keys())

# Run simulation
end_state = abides.run( config )

# Retrieving results from `end_state`
order_book = end_state["agents"][0].order_books["ABM"]

# Get L1 snapshots
L1 = order_book.get_L1_snapshots()
pd.DataFrame(L1['best_bids'], columns=['time', 'p', 'q']).to_csv("./benchmarks/rmsc04/L1_best_bids.csv")
pd.DataFrame(L1['best_asks'], columns=['time', 'p', 'q']).to_csv("./benchmarks/rmsc04/L1_best_asks.csv")

# Get L2 snapshots
L2 = order_book.get_L2_snapshots(nlevels=10)
pd.DataFrame(L2['times'], columns=['time']).to_csv("./benchmarks/rmsc04/L2_times.csv")
pd.DataFrame(L2['bids'][:,:,0], columns=['p']).to_csv("./benchmarks/rmsc04/L2_bids_p.csv")
pd.DataFrame(L2['bids'][:,:,1], columns=['q']).to_csv("./benchmarks/rmsc04/L2_bids_q.csv")
pd.DataFrame(L2['asks'][:,:,0], columns=['p']).to_csv("./benchmarks/rmsc04/L2_asks_p.csv")
pd.DataFrame(L2['asks'][:,:,1], columns=['q']).to_csv("./benchmarks/rmsc04/L2_asks_q.csv")
