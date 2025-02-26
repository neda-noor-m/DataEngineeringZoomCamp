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

