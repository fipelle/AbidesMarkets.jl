# Dependencies
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
from abides_core import abides
from abides_core.utils import parse_logs_df, ns_date, str_to_ns, fmt_ts
from abides_markets.configs import rmsc04

# Configuration and simulation
config = rmsc04.build_config(seed=0)
config.keys()
end_state = abides.run( config )
order_book = end_state["agents"][0].order_books["ABM"]

# Get L1 and L2 snapshots
L1 = order_book.get_L1_snapshots()
L2 = order_book.get_L2_snapshots(nlevels=10)