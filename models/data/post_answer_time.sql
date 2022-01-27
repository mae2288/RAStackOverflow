{{ config(materialized='view') }}

WITH posts AS (

    SELECT post_id, 
        tag,
        creation_date 
    FROM {{ ref('post_tags') }}
),

first_answer AS (

    SELECT parent_id, 
        MIN(creation_date) as first_answer
    FROM {{ ref('stg_answers') }}
    GROUP BY parent_id
),

base AS (
    SELECT p.post_id, 
        p.tag, 
        p.creation_date,
        a.first_answer,
        TIMESTAMP_DIFF(a.first_answer, p.creation_date, MINUTE) as answer_minutes
    FROM posts p
    JOIN first_answer a
        ON p.post_id = a.parent_id

),

final as (
    SELECT tag, 
        COUNT(post_id) as total_posts,
        SUM(answer_minutes) as total_minutes,
        AVG(answer_minutes) as avg_minutes
    FROM base  
    GROUP BY tag
)
SELECT f.*
FROM final f