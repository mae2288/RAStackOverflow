{{ config(materialized='view') }}

SELECT tag FROM {{ ref('pareto') }} ORDER BY total_unanswered DESC LIMIT 25