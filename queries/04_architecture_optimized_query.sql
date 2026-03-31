-- ============================================
-- Architecture Optimized Table
-- - Partitioned by date (top_week)
-- - Clustered by term and country
-- ============================================

CREATE TABLE `project-ebfa42f4-7d2c-45b2-89a.Results.architecture_optimized_results`
PARTITION BY top_week
CLUSTER BY top_term, intl_country_name AS

SELECT *
FROM `project-ebfa42f4-7d2c-45b2-89a.Results.sql_optimized_results`;
