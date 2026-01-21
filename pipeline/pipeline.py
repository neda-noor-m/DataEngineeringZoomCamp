import pandas as pd

d = pd.DataFrame({"name":["neda", "sata"]})
print(d)

d.to_parquet("file_1.parquet")