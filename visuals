## Data Scanned: Initial vs Follow-Up

![Data Scan Comparison](visuals/data-scan-comparison.png)

The baseline approach scans over 200GB per query in repeated workloads, while the architecture-optimized model reduces this to under 2GB. This ~100x reduction is driven by partition pruning (limiting time ranges) and clustering (skipping irrelevant data blocks).

This confirms that in BigQuery, reducing data scanned—not query runtime—is the most effective way to control cost.





## Query Cost Comparison

![Cost Comparison](visuals/cost-comparison.png)

Query cost closely follows data scanned. The baseline approach costs just over $1 per query, while the architecture-optimized model reduces this to under $0.01.

Although architecture optimization incurs a higher upfront cost during table creation, this cost is quickly amortized across repeated queries, making it significantly more cost-efficient at scale.




## Query Runtime Comparison

![Runtime Comparison](visuals/runtime-comparison.png)

SQL optimization significantly improves runtime by reducing intermediate data during joins. However, the architecture-optimized model achieves the fastest execution in repeated queries due to reduced data access.

While runtime improvements are meaningful (~15x faster overall), they are secondary to reductions in data scanned, which ultimately drive both performance and cost efficiency.
