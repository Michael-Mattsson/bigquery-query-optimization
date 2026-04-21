# Warehouse Performance Benchmark Study (BigQuery)

👉 [Read Full Case Study](./full_report.md)

## Full Report [Download PDF version](./final_report.pdf)


> In modern cloud warehouses, poorly designed data systems—not slow queries—are the primary source of inefficiency.

## Overview

This project benchmarks how different optimization strategies impact query performance and cost in Google BigQuery using large-scale datasets (40M–200M+ rows).

The goal was to understand where performance gains actually come from:
- Writing better SQL  
- Designing better data systems  

## What I Did

I implemented and compared three query strategies:

- **Baseline (Naive):** No optimization, full table scans  
- **SQL Optimized:** Applied filtering, column reduction, and join improvements  
- **Architecture Optimized:** Partitioned and clustered tables for efficient data access  

Each approach was evaluated using:
- Runtime  
- Bytes scanned  
- Query cost  

Follow-up queries were also executed to simulate repeated workloads.

## Key Results (from Baseline to Architecture Optimized)

- ~15x faster execution  
- ~100x reduction in data scanned  
- ~100x reduction in query cost  

The largest improvements came from **data layout optimization**, not just SQL changes.

## Why This Matters

BigQuery (and similar cloud warehouses) charge based on **data scanned**, not compute time.

This means:
- Inefficient queries scale costs quickly  
- Optimization directly impacts business spend  
- Data architecture decisions have long-term effects  

This project demonstrates that:
> Designing data systems correctly is more impactful than optimizing queries in isolation.

## Tools & Technologies

- Google BigQuery  
- SQL  
- Public dataset: `google_trends`  
- Query performance metrics (bytes scanned, cost estimation)  

## How It Was Done

- Built a baseline query joining multiple large tables  
- Applied SQL optimizations (filtering early, reducing intermediate data, joins)  
- Created partitioned and clustered tables  
- Benchmarked performance across strategies  
- Compared initial vs repeated query performance  

## Key Takeaways

- Query optimization provides short-term gains  
- Architecture optimization provides scalable, long-term efficiency  
- The primary cost driver in BigQuery is **data scanned**  
- Partitioning and clustering dramatically reduce repeated query cost  

## Project Structure

- [queries](./queries) → SQL scripts for each strategy  
- [analysis](./analysis) → benchmarking results and comparisons  
- [visuals](./visuals) → charts and performance screenshots  
- [report](./report) → full case study write-up  

## Next Steps / Improvements

- Add materialized view benchmarks  
- Compare with other warehouses (Snowflake, Redshift)  
- Simulate multi-user workloads  
- Build a cost monitoring dashboard  
