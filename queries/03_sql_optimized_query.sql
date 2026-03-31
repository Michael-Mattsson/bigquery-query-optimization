-- ============================================
-- SQL Optimized Query
-- - Filters early (last 1 year)
-- - Reduces scanned data before joins
-- ============================================

CREATE TABLE `project-ebfa42f4-7d2c-45b2-89a.Results.sql_optimized_results` AS

WITH max_week AS (
  SELECT MAX(week) AS latest_week
  FROM `bigquery-public-data.google_trends.international_top_rising_terms`
),

filtered_a AS (
  SELECT term, score, rank, dma_name, dma_id, week
  FROM `bigquery-public-data.google_trends.top_terms`
  WHERE week >= DATE_SUB((SELECT latest_week FROM max_week), INTERVAL 1 YEAR)
),

filtered_b AS (
  SELECT term, score, rank, percent_gain, week, dma_name, dma_id
  FROM `bigquery-public-data.google_trends.top_rising_terms`
  WHERE week >= DATE_SUB((SELECT latest_week FROM max_week), INTERVAL 1 YEAR)
),

filtered_c AS (
  SELECT term, week, region_name, country_name, country_code, region_code, score, rank
  FROM `bigquery-public-data.google_trends.international_top_terms`
  WHERE week >= DATE_SUB((SELECT latest_week FROM max_week), INTERVAL 1 YEAR)
),

filtered_d AS (
  SELECT term, week, score, rank, percent_gain, country_name, region_name
  FROM `bigquery-public-data.google_trends.international_top_rising_terms`
  WHERE week >= DATE_SUB((SELECT latest_week FROM max_week), INTERVAL 1 YEAR)
)

SELECT
  a.term AS top_term,
  a.score AS top_score,
  a.rank AS top_rank,
  a.dma_name,
  a.dma_id,
  a.week AS top_week,

  b.score AS dma_rising_score,
  b.rank AS dma_rising_rank,
  b.percent_gain AS dma_rising_percent_gain,

  c.region_name AS intl_region_name,
  c.country_name AS intl_country_name,
  c.country_code AS intl_country_code,
  c.region_code AS intl_region_code,
  c.score AS intl_top_score,
  c.rank AS intl_top_rank,

  d.score AS intl_rising_score,
  d.rank AS intl_rising_rank,
  d.percent_gain AS intl_rising_percent_gain

FROM filtered_a a
JOIN filtered_b b
  ON a.term = b.term
  AND a.week = b.week
  AND a.dma_name = b.dma_name
JOIN filtered_c c
  ON a.term = c.term
  AND a.week = c.week
JOIN filtered_d d
  ON a.term = d.term
  AND a.week = d.week
  AND c.country_name = d.country_name
  AND c.region_name = d.region_name;
