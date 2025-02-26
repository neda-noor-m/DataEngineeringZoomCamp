{{
    config(
        materialized='table'
    )
}}

select sum(total_amount) as total_amount
from {{ ref('fact_trips') }}
group by year, quarter, service_type