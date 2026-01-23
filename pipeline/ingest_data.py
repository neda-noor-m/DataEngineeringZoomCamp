#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd


year = 2021
month=1
prefix = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/'
url= f"{prefix}yellow_tripdata_{year}-{month:02d}.csv.gz"


dtype = {
    "VendorID": "Int64",
    "passenger_count": "Int64",
    "trip_distance": "float64",
    "RatecodeID": "Int64",
    "store_and_fwd_flag": "string",
    "PULocationID": "Int64",
    "DOLocationID": "Int64",
    "payment_type": "Int64",
    "fare_amount": "float64",
    "extra": "float64",
    "mta_tax": "float64",
    "tip_amount": "float64",
    "tolls_amount": "float64",
    "improvement_surcharge": "float64",
    "total_amount": "float64",
    "congestion_surcharge": "float64"
}

parse_dates = [
    "tpep_pickup_datetime",
    "tpep_dropoff_datetime"
]

df = pd.read_csv(
    url,
    dtype=dtype,
    parse_dates=parse_dates
)




get_ipython().system('uv add sqlalchemy psycopg2-binary')



from sqlalchemy import create_engine
engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')


# In[5]:


df_itr = pd.read_csv(url, dtype=dtype,
    parse_dates=parse_dates, chunksize=100000, iterator=True)

first = True
for chunk_data in df_itr:
    if first:
        chunk_data.head(0).to_sql(name="yellow_taxi_data", con=engine, if_exists="replace")
        first = False
    chunk_data.to_sql(name="yellow_taxi_data", con=engine, if_exists="append")

    print("Inserted:", len(chunk_data))


# from sqlalchemy import text

# sql_text = "DROP TABLE IF EXISTS yellow_taxi_data"

# with engine.begin() as conn:
#     conn.execute(text(sql_text))


# In[ ]:




