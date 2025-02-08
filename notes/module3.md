OLTP: OnLine Transaction Processing<br>
OLAP: OnLine Analytical Processing<br>

A data mart is a subset of a data warehouse that focuses on a specific business area, department, or subject. It is designed to provide easy access to relevant data for a particular group of users, such as sales, marketing, finance, or customer support.

External tables
External tables are similar to standard BigQuery tables, with this difference taht BQ just saves metadata and schema and their data resides in an external source. 


<H1>External tables</H1>
BigQuery supports a few external data sources: you may query these sources directly from BigQuery even though the data itself isn't stored in BQ.

An external table is a table that acts like a standard BQ table. The table metadata (such as the schema) is stored in BQ storage but the data itself is external.

You may create an external table from a CSV or Parquet file stored in a Cloud Storage bucket:

```python
CREATE OR REPLACE EXTERNAL TABLE `taxi-rides-ny.nytaxi.external_yellow_tripdata`
OPTIONS (
  format = 'CSV',
  uris = ['gs://nyc-tl-data/trip data/yellow_tripdata_2019-*.csv', 'gs://nyc-tl-data/trip data/yellow_tripdata_2020-*.csv']
);
```

BQ processes 0B for this query when you run it. Because this operation does not actually scan or process the data inside the files. Instead, it only registers metadata about the external files stored in Google Cloud Storage (GCS).

This query will create an external table based on 2 CSV files. BQ will figure out the table schema and the datatypes based on the contents of the files.

Be aware that BQ cannot determine processing costs of external tables.

You may import an external table into BQ as a regular internal table by copying the contents of the external table into a new internal table. For example:

```python
CREATE OR REPLACE TABLE taxi-rides-ny.nytaxi.yellow_tripdata_non_partitoned AS
SELECT * FROM taxi-rides-ny.nytaxi.external_yellow_tripdata;
```
