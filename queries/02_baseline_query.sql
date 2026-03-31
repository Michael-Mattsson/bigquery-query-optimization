-- ============================================
-- Baseline (Naive) Query
-- No filtering, no optimization
-- ============================================

CREATE TABLE `project-ebfa42f4-7d2c-45b2-89a.Results.baseline_results` AS

SELECT
    -- Domestic top terms
    a.score AS top_score,
    a.rank AS top_rank,
    a.refresh_date AS top_refresh_date,
    a.dma_name,
    a.dma_id,
    a.term AS top_term,
    a.week AS top_week,

    -- Domestic rising terms
    b.score AS dma_rising_score,
    b.rank AS dma_rising_rank,
    b.percent_gain AS dma_rising_percent_gain,
    b.refresh_date AS dma_rising_refresh_date,

    -- International top terms
    c.region_name AS intl_region_name,
    c.score AS intl_top_score,
    c.rank AS intl_top_rank,
    c.refresh_date AS intl_top_refresh_date,
    c.country_name AS intl_country_name,
    c.country_code,
    c.region_code,

    -- International rising terms
    d.country_name AS intl_rising_country_name,
    d.region_name AS intl_rising_region_name,
    d.refresh_date AS intl_rising_refresh_date,
    d.country_code AS intl_rising_country_code,
    d.score AS intl_rising_score,
    d.rank AS intl_rising_rank,
    d.percent_gain AS intl_rising_percent_gain

FROM `bigquery-public-data.google_trends.top_terms` a
JOIN `bigquery-public-data.google_trends.top_rising_terms` b
  ON a.term = b.term
  AND a.week = b.week
  AND a.dma_name = b.dma_name
JOIN `bigquery-public-data.google_trends.international_top_terms` c
  ON a.term = c.term
  AND a.week = c.week
JOIN `bigquery-public-data.google_trends.international_top_rising_terms` d
  ON a.term = d.term
  AND a.week = d.week
  AND c.country_name = d.country_name
  AND c.region_name = d.region_name;
