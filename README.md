# Warehouse Performance Benchmark Study in BigQuery

**Author:** Michael Mattsson  
**Date:** March 2026  
**Project Type:** SQL Optimization / Data Engineering Case Study  

**Summary:**  
This project benchmarks different query optimization strategies in BigQuery using large-scale Google Trends data. The goal is to understand how query design impacts runtime, cost, and scalability in a cloud data warehouse.

---

## 1. Introduction

Working with large datasets in cloud warehouses like BigQuery can quickly become expensive and slow if queries are not designed efficiently.

This project explores a simple but important question:

> *How much does query optimization actually matter in BigQuery?*

To answer that, I tested three approaches:
- **Naive (baseline)** — no optimization
- **SQL optimized** — better query design
- **Architecture optimized** — partitioning and clustering

---

## 2. Dataset

This project uses the **Google Trends public dataset** available in BigQuery.

### Tables Used
- `top_terms` (~43.9M rows)
- `top_rising_terms` (~43.8M rows)
- `international_top_terms` (~205.8M rows)
- `international_top_rising_terms` (~95.6M rows)

### Key Columns
- `term`, `week`
- `score`, `rank`, `percent_gain`
- `dma_name`, `dma_id`
- `country_name`, `region_name`

### Why This Dataset?
- Large enough to expose performance differences  
- Requires multiple joins (real-world scenario)  
- Time-based structure (ideal for partitioning)  

---

## 3. Problem Statement

Analytical queries on large datasets often:
- Scan excessive amounts of data  
- Generate large intermediate joins  
- Lead to high costs in pay-per-query systems  

In BigQuery specifically:

> **Cost is driven by bytes processed, not query complexity.**

So inefficient queries don’t just run slower — they cost more.

---

## 4. Methodology

This study evaluates performance across three levels of optimization:

### 1. Naive (Baseline)
- Full table scans  
- No filtering before joins  
- Redundant columns selected  
- No cost awareness  

### 2. SQL Optimized
- Filter early (CTEs)  
- Column pruning (no `SELECT *`)  
- Reduced intermediate data  
- Cleaner joins  

### 3. Architecture Optimized (Conceptual)
- Partitioning by `week`  
- Clustering by join keys (`term`, `region`, etc.)  
- Potential for materialized views  

---

## 5. SQL Optimization Strategy

### Filter Early

Each table is filtered before joins:

```sql
WHERE week >= DATE_SUB(latest_week, INTERVAL 1 YEAR)
```

This reduces:
- Data scanned  
- Join size  
- Intermediate results  

---

### Column Pruning

Instead of:

```sql
SELECT *
```

Only required columns are selected:

```sql
SELECT term, score, rank, week
```

This directly reduces bytes processed.

---

### Join Efficiency

- Avoid redundant columns already enforced by joins  
- Remove duplicate fields (e.g., same `term`, `week` across tables)  
- Keep only necessary dimensions  

---

## 6. Performance Comparison

| Strategy              | Runtime (sec) | Bytes Processed (GB) | Estimated Cost ($) | Rows Output |
|---------------------|--------------|----------------------|--------------------|-------------|
| Naive (Baseline)     | 51.48        | 38.14               | 0.186              | ~6B         |
| SQL Optimized        | ~10–20*      | 32.16               | 0.143              | ~1B         |
| Architecture Optimized | TBD         | TBD                 | TBD                | TBD         |

\*Runtime significantly reduced; exact value depends on execution conditions

---

### Key Improvements

- **~80% reduction in output rows** (6B → 1B)  
- **~15% reduction in data scanned** (38GB → 32GB)  
- **Major runtime improvement** due to reduced join complexity  

---

### Interpretation

- Most performance gains came from **reducing intermediate data**
- Cost improvement was **moderate**, not proportional to runtime
- Indicates **column scanning dominates pricing**, not result size

---

> ⚠️ **Important Insight**  
> Reducing rows does NOT guarantee lower cost in BigQuery.  
> Cost is driven by **columns scanned**, not output size.

---

## 7. Tradeoffs

| Strategy | Pros | Cons |
|--------|------|------|
| Naive | Simple | Expensive, slow |
| SQL Optimized | Faster, cleaner | Limited cost reduction |
| Architecture Optimized | Lowest cost, scalable | Requires setup & maintenance |

---

## 8. Key Takeaways

- Filtering early matters more than anything  
- Joins are the biggest cost driver  
- Reducing rows ≠ reducing cost  
- Column selection directly impacts pricing  
- True cost reduction comes from data layout (partitioning/clustering)  

> You don’t optimize queries for syntax — you optimize them for **data movement**.

---

## 9. Recommendations

If you’re working in BigQuery:

- Always filter on **partition columns**  
- Never use `SELECT *` in production queries  
- Design tables based on **query patterns**, not just storage  
- Monitor **bytes processed**, not just runtime  
- Use clustering for high-frequency join/filter columns  

---

## 10. Sources

- Google Cloud BigQuery Documentation  
- Melnik et al. (2010) — *Dremel: Interactive Analysis of Web-Scale Datasets*  
- Selinger et al. (1979) — *Access Path Selection in RDBMS*  
- Leis et al. (2021) — *Cost-Optimal Query Processing*  
- Zhang et al. (2024) — *Cost-Intelligent Data Analytics in the Cloud*  
- FinOps Foundation (2023)  
- Gohil (2025) — BigQuery Cost Optimization  

