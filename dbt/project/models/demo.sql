{{
    config(
        materialized='table'

    )
}}

SELECT *
FROM {{ source("stackoverflow_source", "posts_questions") }}
LIMIT 10