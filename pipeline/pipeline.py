import pandas as pd
import sys

param = int(sys.argv[1])

d = pd.DataFrame({"name":["neda", "sata"], "param": param})
print(d)

d.to_parquet("file_1.parquet")