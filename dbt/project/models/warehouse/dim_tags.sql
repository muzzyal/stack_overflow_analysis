{{
    config(
        materialized='incremental'
    )
}}

WITH tag_split AS (
 SELECT split(tags, '|') AS tag
 FROM {{ source("stackoverflow_source", "posts_questions") }}
)

, tag_unnest AS (
 SELECT DISTINCT tag
 FROM tag_split, unnest(tag) AS tag
 {% if is_incremental() %}
  LEFT JOIN {{ this }} AS existing_tags
   ON tag = existing_tags.tag_name
  WHERE existing_tags.tag_name IS null
 {% endif %}
)

, new_tag_enumeration AS (
 SELECT
  tag
  , row_number() OVER (ORDER BY tag) AS enumeration
 FROM tag_unnest
)

SELECT
 enumeration {% if is_incremental() %} + (SELECT max(id) FROM {{ this }}){% endif %} AS id
 , tag AS tag_name
FROM new_tag_enumeration
