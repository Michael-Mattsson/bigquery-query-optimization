# Analysis

This section documents the benchmarking process used to evaluate query performance and cost across three optimization strategies in BigQuery.

## Objective

Measure how different optimization approaches impact:

- Query runtime
- Data scanned (bytes processed)
- Estimated query cost
- Performance of repeated (follow-up) queries

---

## Strategies Evaluated

| Strategy                | Description                          |
|------------------------|--------------------------------------|
| Baseline               | No filtering, full table joins       |
| SQL Optimized          | Filtered subqueries before joins     |
| Architecture Optimized | Partitioned + clustered table design |

---

## Benchmark Design

### Step 1 — Initial Query Execution

Each strategy was executed to:

- Materialize results into a table
- Measure:
  - Runtime
  - Bytes processed
  - Estimated cost

This reflects the **initial cost of computation or data restructuring**.

---

### Step 2 — Follow-Up Query Testing

A consistent analytical query was executed across all three tables:

- Filter: last 3 months
- Filter: country = United Kingdom
- Aggregation: average score by term

This simulates a **real-world analytical workload** (e.g., dashboard query).

---

## Results Summary

| Strategy                | Runtime (sec) | Initial Scan (GB) | Initial Cost | Follow-up Scan (GB) | Follow-up Cost |
|------------------------|---------------|-------------------|--------------|---------------------|----------------|
| Baseline               | 64.24         | 38.14             | $0.15        | 208.76              | $1.019         |
| SQL Optimized          | 13.36         | 32.16             | $0.157       | 40.93               | $0.20          |
| Architecture Optimized | 18.34         | 172.35            | $0.842       | 1.85                | $0.009         |

---

## Key Observations

### 1. Initial Cost vs Long-Term Efficiency

- Architecture optimization has the highest upfront cost
- However, it produces **massive savings in repeated queries**

This confirms that:
> Optimization at the storage level trades upfront cost for long-term efficiency

---

### 2. SQL Optimization Has Diminishing Returns

- Filtering before joins reduces intermediate data
- But underlying data is still scanned

Result:
- Moderate improvement (~5x)
- Limited scalability

---

### 3. Partitioning Drives the Largest Gains

Partition pruning reduced scan size from:

- **172 GB → 1.85 GB**

This happens because:
- Only relevant time partitions are read

---

### 4. Clustering Improves Within-Partition Efficiency

- Further reduces scanned data by skipping irrelevant blocks
- Most effective when filtering on clustered columns

---

## Validation Checks

### Partition Effectiveness

```sql
SELECT *
FROM `project-ebfa42f4-7d2c-45b2-89a.Results.architecture_optimized_results`
WHERE top_week = '2024-01-01'
