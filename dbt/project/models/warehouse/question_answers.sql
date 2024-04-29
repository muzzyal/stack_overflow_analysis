{{
    config(
        materialized='table'
    )
}}

SELECT DISTINCT
 parent_id AS question_id
 , id AS answer_id
FROM {{ source("stackoverflow_source", "posts_answers") }}
