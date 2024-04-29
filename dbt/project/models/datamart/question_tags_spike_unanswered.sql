{{
    config(
        materialized='table'
    )
}}

SELECT
 tag_name
 , no_answers_received / questions_asked AS unanswered
 , no_accepted_answers_received / questions_asked AS unaccepted_answered
 , answer_count_without_approval
FROM {{ ref("question_tags_spikes") }}
WHERE increase_in_questions >= 1 OR increase_in_questions_actuals > 100
