{{ config(materialized='view') }}

WITH base AS

(   SELECT post_id, 
        tag,
        no_accepted_answers,
        unanswered,
        EXTRACT(DAYOFWEEK FROM creation_date) as post_dw,
        EXTRACT(HOUR FROM creation_date) as post_hour
    FROM {{ ref('post_tags') }}
),
final as (
    
    SELECT tag,
        post_dw,
        post_hour, 
        COUNT(post_id) as total_posts,
        SUM(no_accepted_answers) as total_no_accepted_answers,
        SUM(unanswered) as total_unanswered
    FROM base
    GROUP BY tag, post_dw, post_hour
)

SELECT tag,
    post_dw,
    post_hour,
    total_posts,
    total_no_accepted_answers,
    total_unanswered
FROM final 



