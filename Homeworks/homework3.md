```python
-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `taxi-rides-ny-447721.HMW_3.external_yellow_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://de_zoomcamp_2025_nedanoor/yellow_tripdata_2024-*.parquet']
);
```
```python
-- Load data from GCS into a regular table
load data into `taxi-rides-ny-447721.HMW_3.yellow_tripdata_load`
from files(
  format = 'PARQUET',
  uris = ['gs://de_zoomcamp_2025_nedanoor/yellow_tripdata_2024-*.parquet']
);
```

<h2>Question 1</h2>
What is count of records for the 2024 Yellow Taxi Data?<br>
1- 65,623<br>
2- 840,402<br>
3- 20,332,093<br>
4- 85,431,289<br>

```python
select count(*) as cont
from `taxi-rides-ny-447721.HMW_3.yellow_tripdata_load`;
```
***answer:3***
---------------------------------------------------------------------
<h2>Question 2</h2>
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?<br>

1- 18.82 MB for the External Table and 47.60 MB for the Materialized Table<br>
2- 0 MB for the External Table and 155.12 MB for the Materialized Table<br>
3- 2.14 GB for the External Table and 0MB for the Materialized Table<br>
4- 0 MB for the External Table and 0MB for the Materialized Table<br>

**answer:2**

```python
from google.cloud import bigquery

client = bigquery.Client()
query = """
SELECT COUNT(DISTINCT PULocationID) 
FROM `taxi-rides-ny-447721.ny_taxi.external_yellow_tripdata`
"""
job_config = bigquery.QueryJobConfig(dry_run=True)
query_job = client.query(query, job_config=job_config)

print(f"Estimated bytes to be processed: {query_job.total_bytes_processed / (1024*1024)} MB")
```
---------------------------------------------------------------------
<h2>Question 3</h2>
Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table. Why are the estimated number of Bytes different?<br><br>

1- BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.<br>
2- BigQuery duplicates data across multiple storage partitions, so selecting two columns instead of one requires scanning the table twice, doubling the estimated bytes processed.<br>
3- BigQuery automatically caches the first queried column, so adding a second column increases processing time but does not affect the estimated bytes scanned.<br>
4- When selecting multiple columns, BigQuery performs an implicit join operation between them, increasing the estimated bytes processed<br>

**answer:1**

---------------------------------------------------------------------
<h2>Question 4</h2>
How many records have a fare_amount of 0?<br><br>

1- 128,210<br>
2- 546,578<br>
3- 20,188,016<br>
4- 8,333<br>

```python
SELECT COUNT(DISTINCT PULocationID) as PUL, COUNT(distinct DOLocationID) as DOL  FROM `taxi-rides-ny-447721.HMW_3.yellow_tripdata_load`;
```
**answer:4**
---------------------------------------------------------------------
<h2>Question 5</h2>
What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)<br><br>

1- Partition by tpep_dropoff_datetime and Cluster on VendorID<br>
2- Cluster on by tpep_dropoff_datetime and Cluster on VendorID<br>
3- Cluster on tpep_dropoff_datetime Partition by VendorID<br>
4- Partition by tpep_dropoff_datetime and Partition by VendorID<br>

```python
create or replace table `taxi-rides-ny-447721.HMW_3.yellow_tripdata_partitioned`
partition by DATE(tpep_dropoff_datetime)
cluster by VendorID as
select * from `taxi-rides-ny-447721.HMW_3.yellow_tripdata_load`;
```
**answer:1**

---------------------------------------------------------------------
<h2>Question 6</h2>
Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)<br>

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values?<br><br>

Choose the answer which most closely matches.<br><br>

1- 12.47 MB for non-partitioned table and 326.42 MB for the partitioned table<br>
2- 310.24 MB for non-partitioned table and 26.84 MB for the partitioned table<br>
3- 5.87 MB for non-partitioned table and 0 MB for the partitioned table<br>
4- 310.31 MB for non-partitioned table and 285.64 MB for the partitioned table<br>

```python
# regular table: it will process 310.24 MB
select distinct(VendorID) 
from `taxi-rides-ny-447721.HMW_3.yellow_tripdata_load`
where tpep_dropoff_datetime between '2024-03-01' and '2024-03-15';

# partitioned table: it will process 26.84 MB
select distinct(VendorID) 
from `taxi-rides-ny-447721.HMW_3.yellow_tripdata_partitioned`
where tpep_dropoff_datetime between '2024-03-01' and '2024-03-15';
```

**answer:2**
