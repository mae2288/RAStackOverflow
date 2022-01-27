{{ config(materialized='view') }}

WITH source_data as (
    
    SELECT id as comment_id,
        text,
        creation_date, 
        post_id, 
        user_id,
        score
    FROM `bigquery-public-data`.stackoverflow.comments
)

SELECT * FROM source_data