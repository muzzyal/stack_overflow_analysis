{{
    config(
        materialized='table'
    )
}}

SELECT
 id
 , format_date('%Y%m%d', date(creation_date)) AS date_id
 , last_editor_user_id
 , score
FROM {{ source("stackoverflow_source", "posts_answers") }}
