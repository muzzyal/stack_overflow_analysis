{{
    config(
        materialized='table'
    )
}}

SELECT
 id
 , format_date('%Y%m%d', date(creation_date)) AS date_id
 , answer_count
 , CASE WHEN accepted_answer_id IS NOT null THEN 1 ELSE 0 END AS has_accepted_answer
 , score
 , view_count
FROM {{ source("stackoverflow_source", "posts_questions") }}
