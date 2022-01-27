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

SELECT f.tag,
    f.post_dw,
    f.post_hour,
    f.total_posts,
    f.total_no_accepted_answers,
    f.total_unanswered
FROM final f
JOIN {{ ref('top_25') }} t
    ON t.tag = f.tag



