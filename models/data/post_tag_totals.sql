{{ config(materialized='view') }}

WITH base AS

(
    SELECT tag, 
        COUNT(post_id) total_posts, 
        SUM(no_accepted_answers) as total_no_accepted_answers,
        SUM(unanswered) as total_unanswered
    FROM {{ ref('post_tags') }}
    GROUP BY tag
),

final AS 
(
    SELECT tag,
        total_posts,
        total_no_accepted_answers,
        total_unanswered,
        total_no_accepted_answers/total_posts as percent_no_accepted_answers,
        total_unanswered/total_posts as percent_unanswered
    FROM base
)
SELECT * FROM final
ORDER BY total_unanswered DESC
