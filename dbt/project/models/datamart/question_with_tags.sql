{{
    config(
        materialized='table'
    )
}}

SELECT
 qs.id
 , d.month_date
 , qs.answer_count
 , qs.has_accepted_answer
 , qs.score
 , qs.view_count
 , ts.tag_name
FROM {{ ref("fact_questions") }} AS qs
LEFT JOIN {{ ref("question_tags") }} AS qts
 ON qs.id = qts.question_id
LEFT JOIN {{ ref("dim_tags") }} AS ts
 ON qts.tag_id = ts.id
LEFT JOIN {{ ref("dim_date") }} AS d
 ON qs.date_id = d.id
