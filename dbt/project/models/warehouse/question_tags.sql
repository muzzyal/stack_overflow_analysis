{{
    config(
        materialized='table'
    )
}}

WITH tag_split AS (
 SELECT
  id
  , split(tags, '|') AS tag
 FROM {{ source("stackoverflow_source", "posts_questions") }}
)

, question_with_tags_unnested AS (
 SELECT
  id AS question_id
  , tag AS tag_name
 FROM tag_split, unnest(tag) AS tag
)

SELECT
 questions.question_id
 , dim_tags.id AS tag_id
FROM question_with_tags_unnested AS questions
LEFT JOIN {{ ref('dim_tags') }} AS dim_tags
 ON questions.tag_name = dim_tags.tag_name
