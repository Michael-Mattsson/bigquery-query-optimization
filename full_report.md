# Warehouse Performance Benchmark Study in BigQuery

**Author:** Michael Mattsson  
**Date:** March 2026  
**Project Type:** Applied Analytics Case Study  

---

## Executive Summary

This study evaluates how different query optimization strategies impact performance and cost in Google BigQuery when working with large-scale analytical datasets (40M–200M+ rows per table).

Three approaches were benchmarked:

- **Baseline (Naive):** No optimization  
- **SQL Optimized:** Query-level improvements  
- **Architecture Optimized:** Partitioning and clustering  

### Key Results (Baseline vs Architecture Optimized)

- **Execution time reduced from 64.24s to 0.537s (~120× faster)**  
- **Data scanned reduced from 208.76GB to 1.85GB (~113× reduction)**  
- **Query cost reduced from $1.019 to $0.009 (~113× cheaper per query)**  

These results reflect **repeated query performance**, not just one-time execution.

The key takeaway: in BigQuery, **cost is driven primarily by data scanned—not execution time**.  
Optimizing how data is stored consistently delivers greater impact than optimizing SQL alone.

---

## 1. Problem Context

Modern cloud data warehouses operate on a **pay-per-query model**, where cost scales with data processed.

In this environment, inefficient queries create compounding issues:

- **Technical:** Increased runtime and resource usage  
- **Operational:** Slower dashboards and delayed insights  
- **Financial:** Costs grow linearly with data volume  

At scale, even small inefficiencies become expensive—especially in shared environments.

This project explores a practical question:

> Is it more effective to optimize queries, or redesign how data is stored?

---

## 2. Dataset Overview

**Source:** BigQuery Public Dataset – Google Trends  

### Tables Used

| Table | Rows |
|------|------|
| top_terms | 43,908,480 |
| top_rising_terms | 43,853,880 |
| international_top_terms | 205,865,839 |
| international_top_rising_terms | 95,618,061 |

### Characteristics

- Time-series structure (`week`)  
- High-cardinality dimensions (`term`, `country`)  
- Join-heavy analytical workload  

This setup reflects real-world BI scenarios involving large joins and aggregations.

---

## 3. Methodology

### 3.1 Optimization Framework

Performance was evaluated across three layers:

**Query-Level Optimization**
- Filter early  
- Reduce selected columns  
- Improve joins  

**Data Layout Optimization**
- Partitioning (time-based)  
- Clustering (frequently filtered columns)  

**Workload Perspective**
- Focus on repeated queries rather than one-off execution  

---

### 3.2 Benchmark Strategies

#### Strategy 1: Baseline (Naive)

- Full table scans  
- No filtering before joins  

**Outcome:**  
High cost, slow runtime, poor scalability  

---

#### Strategy 2: SQL Optimized

- Filters applied inside subqueries before joins  
- Reduced intermediate data  

**Outcome:**  
Moderate improvements in runtime and cost without changing data structure  

---

#### Strategy 3: Architecture Optimized

- Partitioned by `top_week`  
- Clustered by `top_term`, `intl_country_name`  

**Effect:**
- Partition pruning limits time-based scans  
- Clustering skips irrelevant data blocks  

**Outcome:**  
Minimal data scanned and significantly lower cost for repeated queries  

---

## 4. Results

### 4.1 Initial Query Performance

| Strategy | Runtime (sec) | Bytes Scanned (GB) | Cost |
|----------|--------------|-------------------|------|
| Baseline | 64.24 | 38.14 | $0.15 |
| SQL Optimized | 13.36 | 32.16 | $0.157 |
| Architecture Optimized | 18.34 | 172.35 | $0.842 |

**Interpretation**

SQL optimization improves efficiency with minimal effort.  
Architecture optimization appears more expensive initially due to data restructuring, but this is a **one-time cost**.

---

### 4.2 Follow-Up Query Performance

| Strategy | Runtime (sec) | Bytes Scanned (GB) | Cost |
|----------|--------------|-------------------|------|
| Baseline | 3.76 | 208.76 | $1.019 |
| SQL Optimized | 0.822 | 40.93 | $0.20 |
| Architecture Optimized | 0.537 | 1.85 | $0.009 |

**Interpretation**

- Baseline continues full scans  
- SQL optimization reduces scan size  
- Architecture optimization reduces scan size **by orders of magnitude**  

**Conclusion:** Data layout, not query syntax, dominates performance at scale.

---

## 5. Trade-Off Analysis

Each strategy reflects a different trade-off:

- **Baseline:** Simple but inefficient  
- **SQL Optimized:** Easy improvements, limited scalability  
- **Architecture Optimized:** Higher upfront cost, best long-term performance  

For repeated workloads, architecture optimization is the clear winner.

---

## 6. Key Observations

- **Data scanned is the primary cost driver**  
- **Partitioning provides the largest gains** by limiting time-based scans  
- **Clustering adds further efficiency** by skipping irrelevant data blocks  
- Performance optimization is ultimately a **data design problem**, not just a SQL problem  

---

## 7. Business Impact

### Example Scenario

If a query runs **1,000 times per day**:

- Baseline → ~$1,019/day  
- Architecture optimized → ~$9/day  

### Annual Cost Comparison

- Baseline → ~$372,000/year  
- Optimized → ~$3,285/year  

**~99% cost reduction**

Poor data design can turn simple analytics into a major expense.

---

## 8. Practical Recommendations

- Partition large tables on time-based columns  
- Cluster on frequently filtered fields  
- Apply filters before joins  
- Monitor **bytes scanned** as the key metric  
- Precompute results for repeated workloads  

---

## 9. Limitations

- Single dataset and workload pattern  
- No concurrency simulation  
- Results depend on data distribution and query design  

---

## 10. Conclusion

The main source of inefficiency in cloud data warehouses is not poor SQL, but **inefficient data architecture**.

SQL optimization provides incremental gains.  
Architecture optimization delivers **system-level efficiency at scale**.

> Instead of optimizing queries individually, design systems where efficient execution is built in.

---

## 11. References

- Selinger et al. (1979)  
- Melnik et al. (2010)  
- Google Cloud – BigQuery Documentation  
- Leis et al. (2021)  
- Zhang et al. (2024)  
- Perriot et al. (2017)  
- Gohil (2025)  
- FinOps Foundation (2023)  
- Geektak (2023)  

---

## Project Structure

- Queries: `./queries/`  
- Visuals: `./visuals/`  

