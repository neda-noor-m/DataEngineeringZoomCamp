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
