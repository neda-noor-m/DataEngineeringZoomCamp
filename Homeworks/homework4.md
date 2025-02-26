<h2>Question 1: Understanding dbt model resolution </h2>
Provided you've got the following sources.yaml <br>

```python
version: 2

sources:
  - name: raw_nyc_tripdata
    database: "{{ env_var('DBT_BIGQUERY_PROJECT', 'dtc_zoomcamp_2025') }}"
    schema:   "{{ env_var('DBT_BIGQUERY_SOURCE_DATASET', 'raw_nyc_tripdata') }}"
    tables:
      - name: ext_green_taxi
      - name: ext_yellow_taxi
```
with the following env variables setup where dbt runs: <br> <br>

```python
export DBT_BIGQUERY_PROJECT=myproject
export DBT_BIGQUERY_DATASET=my_nyc_tripdata
```
What does this .sql model compile to? <br>

1- select * from {{ source('raw_nyc_tripdata', 'ext_green_taxi' ) }}<br>
2- select * from dtc_zoomcamp_2025.raw_nyc_tripdata.ext_green_taxi<br>
3- select * from dtc_zoomcamp_2025.my_nyc_tripdata.ext_green_taxi<br>
4- select * from myproject.raw_nyc_tripdata.ext_green_taxi<br>
5- select * from myproject.my_nyc_tripdata.ext_green_taxi<br>
6- select * from dtc_zoomcamp_2025.raw_nyc_tripdata.green_taxi<br>

in `select * from {{ source('raw_nyc_tripdata', 'ext_green_taxi' ) }}`, 'raw_nyc_tripdata' points  to the source name defined under `sources`. so, the database name and schema is taken from that source name. Since we use `export DBT_BIGQUERY_PROJECT=myproject` and `export DBT_BIGQUERY_DATASET=my_nyc_tripdata` finally this query is translated to:
`select * from myproject.my_nyc_tripdata.ext_green_taxi`<br><br>

**answer: 5** 

---------------------------------------------------------------------

<h2>Question 2: dbt Variables & Dynamic Models</h2>
Say you have to modify the following dbt_model (fct_recent_taxi_trips.sql) to enable Analytics Engineers to dynamically control the date range.<br>

In development, you want to process only the last 7 days of trips<br>
In production, you need to process the last 30 days for analytics<br>
```python
select *
from {{ ref('fact_taxi_trips') }}
where pickup_datetime >= CURRENT_DATE - INTERVAL '30' DAY
```
<br>What would you change to accomplish that in a such way that command line arguments takes precedence over ENV_VARs, which takes precedence over DEFAULT value?<br>

1- Add ORDER BY pickup_datetime DESC and LIMIT {{ var("days_back", 30) }}<br>
2- Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", 30) }}' DAY<br>
3- Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ env_var("DAYS_BACK", "30") }}' DAY<br>
4-Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY<br>
5- Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ env_var("DAYS_BACK", var("days_back", "30")) }}' DAY
<h4>1- Command-Line Arguments (`--vars`):</h4>
Command-line arguments should be used to pass in the date range when running dbt. These should override both the environment variables and the default value. <br>
<h4>2- Environment Variables (`env_var`):</h4>
If no command-line argument is passed, you can use environment variables as the next source of truth for determining the date range. <br>
<h4>3- Default Value::</h4>
If neither the command-line argument nor the environment variable is provided, use a default value (e.g., 30 days for production). <br><br>

**answer: 4**

___________________________________________________________________________

<h2>Question 3: dbt Data Lineage and Execution</h2>
Considering the data lineage below and that taxi_zone_lookup is the only materialization build (from a .csv seed file), Select the option that does NOT apply for materializing fct_taxi_monthly_zone_revenue:<br>

1- dbt run<br>
2- dbt run --select +models/core/dim_taxi_trips.sql+ --target prod<br>
3- dbt run --select +models/core/fct_taxi_monthly_zone_revenue.sql<br>
4- dbt run --select +models/core/<br>
5- dbt run --select models/staging/+<br>

`dbt run --select models/staging/+` <br>
❌ This runs only the staging models, excluding fct_taxi_monthly_zone_revenue, which is in core, making it the correct answer.<br>


**answer: 5**

________________________________________________________________________________________________
<h2>Question 4: dbt Macros and Jinja</h2>
Consider you're dealing with sensitive data (e.g.: PII), that is only available to your team and very selected few individuals, in the raw layer of your DWH (e.g: a specific BigQuery dataset or PostgreSQL schema),<br>

Among other things, you decide to obfuscate/masquerade that data through your staging models, and make it available in a different schema (a staging layer) for other Data/Analytics Engineers to explore <br>

And optionally, yet another layer (service layer), where you'll build your dimension (dim_) and fact (fct_) tables (assuming the Star Schema dimensional modeling) for Dashboarding and for Tech Product Owners/Managers <br>

You decide to make a macro to wrap a logic around it:<br>

```python
{% macro resolve_schema_for(model_type) -%}

    {%- set target_env_var = 'DBT_BIGQUERY_TARGET_DATASET'  -%}
    {%- set stging_env_var = 'DBT_BIGQUERY_STAGING_DATASET' -%}

    {%- if model_type == 'core' -%} {{- env_var(target_env_var) -}}
    {%- else -%}                    {{- env_var(stging_env_var, env_var(target_env_var)) -}}
    {%- endif -%}

{%- endmacro %}
```
And use on your staging, dim_ and fact_ models as:<br>
```python
{{ config(
    schema=resolve_schema_for('core'), 
) }}
```
That all being said, regarding macro above, select all statements that are true to the models using it:<br>

1- Setting a value for DBT_BIGQUERY_TARGET_DATASET env var is mandatory, or it'll fail to compile<br>
2- Setting a value for DBT_BIGQUERY_STAGING_DATASET env var is mandatory, or it'll fail to compile<br>
3- When using core, it materializes in the dataset defined in DBT_BIGQUERY_TARGET_DATASET<br>
4- When using stg, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET<br>
5- When using staging, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET<br> <br>

<h4>"Setting a value for DBT_BIGQUERY_STAGING_DATASET env var is mandatory, or it'll fail to compile"</h4>
The env_var(stging_env_var, env_var(target_env_var)) means:<br>
If DBT_BIGQUERY_STAGING_DATASET is set, it is used.<br>
If not, it falls back to DBT_BIGQUERY_TARGET_DATASET.<br>
Since there is a fallback, the compilation will not fail even if DBT_BIGQUERY_STAGING_DATASET is missing. ❌ False (not mandatory, as it has a fallback)<br><br>

**answer:2**

____________________________________________________________________________________
<h2>Question 5: Taxi Quarterly Revenue Growth</h2>
Create a new model fct_taxi_trips_quarterly_revenue.sql <br>
Compute the Quarterly Revenues for each year for based on total_amount<br>
Compute the Quarterly YoY (Year-over-Year) revenue growth<br>

Considering the YoY Growth in 2020, which were the yearly quarters with the best (or less worse) and worst results for green, and yellow<br><br>

1- green: {best: 2020/Q2, worst: 2020/Q1}, yellow: {best: 2020/Q2, worst: 2020/Q1}<br>
2- green: {best: 2020/Q2, worst: 2020/Q1}, yellow: {best: 2020/Q3, worst: 2020/Q4}<br>
3- green: {best: 2020/Q1, worst: 2020/Q2}, yellow: {best: 2020/Q2, worst: 2020/Q1}<br>
4- green: {best: 2020/Q1, worst: 2020/Q2}, yellow: {best: 2020/Q1, worst: 2020/Q2}<br>
5- green: {best: 2020/Q1, worst: 2020/Q2}, yellow: {best: 2020/Q3, worst: 2020/Q4}<br><br>

first lets create fct_taxi_trips_quarterly_revenue model:
```python
#fct_taxi_trips_quarterly_revenue.sql
{{
    config(
        materialized='table'
    )
}}

WITH quarterly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM fct_table.pickup_datetime) AS year,
        EXTRACT(QUARTER FROM fct_table.pickup_datetime) AS quarter,
        CONCAT(EXTRACT(YEAR FROM fct_table.pickup_datetime), '/Q', EXTRACT(QUARTER FROM fct_table.pickup_datetime)) AS year_quarter,
        fct_table.service_type as service_type,
        SUM(total_amount) AS total_revenue
    FROM {{ ref('fact_trips') }} as fct_table
    GROUP BY 1, 2, 3, 4
),
yoy_growth AS (
    SELECT
        q1.year,
        q1.quarter,
        q1.year_quarter,
        q1.service_type,
        q1.total_revenue,
        q2.total_revenue AS previous_year_revenue,
        ROUND(
            ((q1.total_revenue - q2.total_revenue) / NULLIF(q2.total_revenue, 0)) * 100, 2
        ) AS yoy_growth_percentage
    FROM quarterly_revenue q1
    LEFT JOIN quarterly_revenue q2
    ON q1.service_type = q2.service_type
    AND q1.year = q2.year + 1
    AND q1.quarter = q2.quarter
)
SELECT * FROM yoy_growth
ORDER BY service_type, year, quarter

```
then make a query:<br>
```python
-- Best quarter for Green Taxi (highest growth)
SELECT * FROM {{ this }}  
WHERE service_type = 'Green'  
ORDER BY yoy_growth_percentage DESC  
LIMIT 1;  

-- Worst quarter for Green Taxi (lowest growth)
SELECT * FROM {{ this }}  
WHERE service_type = 'Green'  
ORDER BY yoy_growth_percentage ASC  
LIMIT 1;  

-- Best quarter for Yellow Taxi  
SELECT * FROM {{ this }}  
WHERE service_type = 'Yellow'  
ORDER BY yoy_growth_percentage DESC  
LIMIT 1;  

-- Worst quarter for Yellow Taxi  
SELECT * FROM {{ this }}  
WHERE service_type = 'Yellow'  
ORDER BY yoy_growth_percentage ASC  
LIMIT 1;  
```

**answer:4**
__________________________________________________________________________________________

<h2>Question 6: P97/P95/P90 Taxi Monthly Fare</h2>
  
Create a new model fct_taxi_trips_monthly_fare_p95.sql <br>
Filter out invalid entries (fare_amount > 0, trip_distance > 0, and payment_type_description in ('Cash', 'Credit Card'))<br>
Compute the continous percentile of fare_amount partitioning by service_type, year and and month<br>
Now, what are the values of p97, p95, p90 for Green Taxi and Yellow Taxi, in April 2020?<br>

1- green: {p97: 55.0, p95: 45.0, p90: 26.5}, yellow: {p97: 52.0, p95: 37.0, p90: 25.5}<br>
2- green: {p97: 55.0, p95: 45.0, p90: 26.5}, yellow: {p97: 31.5, p95: 25.5, p90: 19.0}<br>
3- green: {p97: 40.0, p95: 33.0, p90: 24.5}, yellow: {p97: 52.0, p95: 37.0, p90: 25.5}<br>
4- green: {p97: 40.0, p95: 33.0, p90: 24.5}, yellow: {p97: 31.5, p95: 25.5, p90: 19.0}<br>
5- green: {p97: 55.0, p95: 45.0, p90: 26.5}, yellow: {p97: 52.0, p95: 25.5, p90: 19.0}<br> <br>

first creat fct_taxi_trips_monthly_fare_p95.sql:
```python
{{
    config(
        materialized='table'
    )
}}

WITH clean_fact_trips AS (
    SELECT
        service_type,
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(MONTH FROM pickup_datetime) AS month,
        fare_amount,
        trip_distance,
        payment_type_description
    FROM {{ ref('fact_trips') }}
    WHERE
        fare_amount > 0
        AND trip_distance > 0
        AND lower(payment_type_description) in ('cash', 'credit card')
),

fare_amt_perc AS(
    SELECT
        service_type,
        year,
        month,
        PERCENTILE_CONT(fare_amount, 0.97) OVER (PARTITION BY service_type, year, month) AS p97,
        PERCENTILE_CONT(fare_amount, 0.95) OVER (PARTITION BY service_type, year, month) AS p95,
        PERCENTILE_CONT(fare_amount, 0.90) OVER (PARTITION BY service_type, year, month) AS p90
    FROM clean_fact_trips
    --GROUP BY service_type, year, month
    --ORDER BY year, month, service_type
)

SELECT * FROM fare_amt_perc
```
and then query:
```python
select service_type, max(p97) as p97, max(p95) as p95, max(p90) as p90
from `taxi-rides-ny-447721.taxi_rides_ny.fct_taxi_trips_monthly_fare_p95`
where month=4 and year=2020
group by service_type
```
**answer:2**
___________________________________________________________________________________________
[WARNING]: Test 'test.taxi_rides_ny.relationships_stg_yellow_tripdata_dropoff_locationid__locationid__ref_taxi_zone_lookup_csv_.085c4830e7' (models/staging/schema.yml) depends on a node named 'taxi_zone_lookup.csv' in package '' which was not found

solve:
This warning indicates that dbt is trying to reference a model or source named taxi_zone_lookup.csv, but it cannot find it. 
We might have a typo in our ref() function.

```python
tests:
  - name: relationships_stg_yellow_tripdata_dropoff_locationid
    description: "Ensure dropoff_location_id exists in taxi_zone_lookup.csv"
    relationships:
      to: ref('taxi_zone_lookup.csv')  # ❌ Wrong reference
      field: locationid
```

to:
```python
  to: ref('taxi_zone_lookup')  # ✅ Correct reference
```

