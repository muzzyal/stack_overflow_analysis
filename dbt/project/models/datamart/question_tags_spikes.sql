{{
    config(
        materialized='table'
    )
}}

WITH max_month AS (
 SELECT max(month_date)
 FROM {{ ref("question_tags_aggregation") }}
)

, grouping_data AS (
 SELECT
  CASE
   WHEN date(month_date) > date_add(date((SELECT * FROM max_month)), INTERVAL -6 MONTH) THEN 1
   ELSE 2
  END AS data_grouping
  , tag_name
  , questions_asked
  , question_views
  , answered_questions
  , answer_count
  , no_answers_received
  , no_accepted_answers_received
  , answer_count_without_approval
 FROM {{ ref("question_tags_aggregation") }}
 WHERE date(month_date) > date_add(date((SELECT * FROM max_month)), INTERVAL -12 MONTH)
)

, aggregating_grouped_data AS (
 SELECT
  data_grouping
  , tag_name
  , sum(questions_asked) AS questions_asked
  , sum(question_views) AS question_views
  , sum(answered_questions) AS answered_questions
  , sum(answer_count) AS answer_count
  , sum(no_answers_received) AS no_answers_received
  , sum(no_accepted_answers_received) AS no_accepted_answers_received
  , sum(answer_count_without_approval) AS answer_count_without_approval
 FROM grouping_data
 GROUP BY
  data_grouping
  , tag_name
)

SELECT
 group1.*
 , group2.questions_asked AS previously_asked_this_year
 , group1.questions_asked - coalesce(group2.questions_asked, 0) AS increase_in_questions_actuals
 , (group1.questions_asked - group2.questions_asked) / group2.questions_asked AS increase_in_questions
FROM aggregating_grouped_data AS group1
LEFT JOIN aggregating_grouped_data AS group2
 ON
  group1.tag_name = group2.tag_name
  AND group1.data_grouping = 1
  AND group2.data_grouping = 2
WHERE group1.data_grouping = 1
