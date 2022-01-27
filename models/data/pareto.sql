{{ config(materialized='view') }}

WITH posts AS (

    SELECT tag,
        total_posts,
        total_unanswered,
        percent_unanswered,
        total_no_accepted_answers,
        percent_no_accepted_answers,
        SUM(total_posts) OVER (ORDER BY total_unanswered DESC) AS rt_posts_unanswered,
        SUM(total_unanswered) OVER (ORDER BY total_unanswered DESC) AS rt_unanswered,
        SUM(total_posts) OVER (ORDER BY total_no_accepted_answers DESC) AS rt_posts_noaccepted,
        SUM(total_no_accepted_answers) OVER (ORDER BY total_no_accepted_answers DESC) AS rt_noaccepted
    FROM {{ ref('post_tag_totals') }}
    WHERE tag <> ''
),
summed AS (
    SELECT SUM(total_unanswered) as all_unanswered,
        SUM(total_no_accepted_answers) as all_noaccepted
    FROM posts
)
SELECT p.tag,
    p.total_posts,
    p.total_unanswered,
    p.percent_unanswered,
    p.rt_unanswered/p.rt_posts_unanswered as rt_percent_unanswered,
    p.rt_unanswered/s.all_unanswered as unanswered_pareto,
    p.total_no_accepted_answers,
    p.percent_no_accepted_answers,
    p.rt_noaccepted/p.rt_posts_noaccepted as rt_percent_noaccepted,
    p.rt_noaccepted/s.all_noaccepted as noaccepted_pareto
FROM posts p
JOIN summed s 
    ON 1=1
ORDER BY p.total_unanswered DESC