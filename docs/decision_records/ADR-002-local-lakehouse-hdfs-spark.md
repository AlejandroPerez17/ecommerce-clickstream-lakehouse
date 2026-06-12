# ADR-002: Local lakehouse on HDFS + Spark standalone in Docker

- **Status:** Accepted
- **Date:** 2026-06-10
- **Context:** The pipeline must run fully local on Windows 11 + WSL2 (16 GB RAM, 10 GB cap),
  be reproducible with one command, and serve an explicit didactic goal: hands-on practice
  with the Hadoop/Spark distributed stack covered by the IBM Data Engineering certification (§2).
- **Decision:** Run a Docker Compose pseudo-cluster: HDFS 3.4 (1 namenode + 1 datanode,
  `dfs.replication=1`) as the lake, Spark 3.5 standalone (1 master + 1 worker) as compute,
  and PostgreSQL 16 as the BI-agnostic serving layer.
- **Alternatives considered:**
  - MinIO (S3 API) storage: closer to modern cloud stacks, but removes the Hadoop learning objective; kept as roadmap (§13).
  - Single-container Spark `local[*]` without master/worker: lighter, but demonstrates no cluster topology; retained as documented lite fallback (§10.2).
  - Cloud free tiers (Databricks CE, EMR/Dataproc trials): managed convenience, but quotas/expiry hurt reproducibility and hide HDFS/cluster operations.
- **Consequences:** Gains: one-command reproducibility, real HDFS + Spark UI operations,
  an architecture that mirrors production topologies. Sacrifices: distribution is logical only
  (single host), tight RAM budget requiring per-container limits and month-by-month processing
  (§10, future ADR-008), and `replication=1` (no fault tolerance — acceptable locally).