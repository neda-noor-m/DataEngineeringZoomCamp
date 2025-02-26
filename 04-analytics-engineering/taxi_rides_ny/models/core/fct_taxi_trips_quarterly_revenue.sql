{{
    config(
        materialized='table'
    )
}}

select *
from {{ ref('fact_trips') }}