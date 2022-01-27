{{ config(materialized='view') }}

WITH source_data AS (

    SELECT id as post_id, 
        title,
        body,
        accepted_answer_id,
        answer_count, 
        comment_count, 
        creation_date,
        favorite_count,
        owner_user_id,
        score,
        tags,
        view_count 
    FROM `bigquery-public-data`.stackoverflow.stackoverflow_posts
)

SELECT * FROM source_data