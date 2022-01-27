{{ config(materialized='view') }}

WITH base AS

(   SELECT post_id,
        accepted_answer_id,
        creation_date,
        owner_user_id,
        CASE 
            WHEN accepted_answer_id is null THEN 1 
            ELSE 0 
        END as no_accepted_answers, 
        CASE 
            WHEN answer_count = 0 THEN 1 
            ELSE 0 
        END as unanswered, 
        SPLIT(tags,'|') as split_tags
    FROM {{ ref('stg_posts') }}
)

Select * FROM base, UNNEST(split_tags) as tag