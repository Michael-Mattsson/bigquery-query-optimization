-- ============================================
-- Validation Queries
-- Used to confirm partitioning + clustering effectiveness
-- ============================================

-- 1. Partition pruning check
-- Expect: very small bytes processed
SELECT *
FROM `project-ebfa42f4-7d2c-45b2-89a.Results.architecture_optimized_results`
WHERE top_week = '2024-01-01';


-- 2. Control test (no filters)
-- Expect: similar bytes scanned across tables
SELECT COUNT(*)
FROM `project-ebfa42f4-7d2c-45b2-89a.Results.sql_optimized_results`;

SELECT COUNT(*)
FROM `project-ebfa42f4-7d2c-45b2-89a.Results.architecture_optimized_results`;
