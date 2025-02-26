{{
    config(
        materialized='table'
    )
}}

WITH filtered_trips AS (
    SELECT 
        service_type,
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(MONTH FROM pickup_datetime) AS month,
        fare_amount
    FROM {{ ref('fact_trips') }}  -- Reference to your existing fact table
    WHERE fare_amount > 0
        AND trip_distance > 0
        AND payment_type_description IN ('Cash', 'Credit Card')
),
percentiles AS (
    SELECT 
        service_type,
        year,
        month,
        APPROX_QUANTILES(fare_amount, 100)[OFFSET(90)] AS p90,  -- 90th percentile
        APPROX_QUANTILES(fare_amount, 100)[OFFSET(95)] AS p95,  -- 95th percentile
        APPROX_QUANTILES(fare_amount, 100)[OFFSET(97)] AS p97   -- 97th percentile
    FROM filtered_trips
    GROUP BY service_type, year, month
)

SELECT * FROM percentiles
ORDER BY service_type, year, month