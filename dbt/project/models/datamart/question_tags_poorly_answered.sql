{{
    config(
        materialized='table'
    )
}}

WITH max_month AS (
 SELECT max(month_date)
 FROM {{ ref("question_tags_aggregation") }}
)

, recent_answers AS (
 SELECT
  qs.tag_name
  , sum(1) AS answers
  , sum(ans.score) AS answer_score_total
  , sum(CASE WHEN ans.score < 0 THEN 1 ELSE 0 END) AS negative_score_answer_count
  , sum(CASE WHEN ans.score < 0 THEN 1 ELSE 0 END) / sum(1) AS negative_score_answers
 FROM {{ ref("fact_answers") }} AS ans
 LEFT JOIN {{ ref("question_answers") }} AS qas
  ON ans.id = qas.answer_id
 LEFT JOIN {{ ref("question_with_tags") }} AS qs
  ON qas.question_id = qs.id
 WHERE date(qs.month_date) > date_add(date((SELECT * FROM max_month)), INTERVAL -6 MONTH)
 GROUP BY qs.tag_name
)

SELECT ans.*
FROM recent_answers AS ans
INNER JOIN {{ ref("question_tags_spike_unanswered") }} AS sp_ua
 ON ans.tag_name = sp_ua.tag_name
WHERE ans.answers >= 10
