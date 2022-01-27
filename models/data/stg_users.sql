{{ config(materialized='view') }}

WITH source_data AS (

    SELECT id as user_id, 
        creation_date,
        location, 
        reputation,
        up_votes,
        down_votes,
        views
    FROM `bigquery-public-data`.stackoverflow.users
)

SELECT * FROM source_data