{{
    config(
        materialized='table'
    )
}}

WITH dates AS (
 SELECT
  date_trunc(date_add(current_date(), INTERVAL -20 YEAR), MONTH) AS start_date
  , date_trunc(date_add(current_date(), INTERVAL 5 YEAR), MONTH) AS end_date
)

SELECT
 format_date('%Y%m%d', calendar_date) AS id
 , format_date('%Y%m', calendar_date) AS month_key
 , format_date('%Y', calendar_date) AS year_key
 , calendar_date AS day_date
 , format_date('%Y-%m-01', calendar_date) AS month_date
 , format_date('%Y-01-01', calendar_date) AS year_date
FROM (
 SELECT calendar_date
 FROM dates, unnest(generate_date_array(start_date, end_date, INTERVAL 1 DAY)) AS calendar_date
)
ORDER BY id
