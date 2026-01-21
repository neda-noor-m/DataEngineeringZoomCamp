import pandas as pd
import sys

param = int(sys.argv[1])

d = pd.DataFrame({"name":["neda", "sata"], "param":  [param, param]})
print(d)
print(f"program name:{sys.argv[0]}")

d.to_parquet("file_1.parquet")