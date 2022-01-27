{{ config(materialized='view') }}

WITH source_data AS (
    
    SELECT id as badge_id,
        name as badge_name, 
        date as badge_date,
        user_id,
        class
    FROM `bigquery-public-data`.stackoverflow.badges
)

SELECT * FROM source_data