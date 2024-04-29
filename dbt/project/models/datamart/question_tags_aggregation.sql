{{
    config(
        materialized='ephemeral'
    )
}}

SELECT
 month_date
 , tag_name
 , sum(1) AS questions_asked
 , sum(view_count) AS question_views
 , sum(has_accepted_answer) AS answered_questions
 , sum(answer_count) AS answer_count
 , sum(CASE WHEN answer_count = 0 THEN 1 ELSE 0 END) AS no_answers_received
 , sum(CASE WHEN has_accepted_answer = 0 THEN 1 ELSE 0 END) AS no_accepted_answers_received
 , sum(CASE WHEN has_accepted_answer = 0 THEN answer_count ELSE 0 END) AS answer_count_without_approval
FROM {{ ref("question_with_tags") }}
GROUP BY
 month_date
 , tag_name
