-- ============================================
-- Follow-Up Query (Architecture Optimized)
-- ============================================

SELECT
  top_term,
  AVG(top_score) AS avg_top_score,
  COUNT(*) AS record_count
FROM `project-ebfa42f4-7d2c-45b2-89a.Results.architecture_optimized_results`
WHERE top_week >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)
  AND intl_country_name = 'United Kingdom'
GROUP BY top_term;
