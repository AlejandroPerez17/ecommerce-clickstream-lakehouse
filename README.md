# eCommerce Clickstream Lakehouse

> End-to-end, fully local batch data pipeline: **110M real e-commerce events** processed with
> **Apache Spark on HDFS** (Docker Compose), modeled as a **medallion lakehouse + star schema**,
> served through a **BI-agnostic PostgreSQL layer** into **Power BI** and **IBM Cognos** dashboards.

[TODO: dashboard GIF → `docs/img/dashboard.gif` (15–25 s, ScreenToGif)]

![Apache Spark](https://img.shields.io/badge/Apache_Spark-3.5-E25A1C?logo=apachespark&logoColor=white)
![Hadoop HDFS](https://img.shields.io/badge/Hadoop_HDFS-3.4-66CCFF?logo=apachehadoop&logoColor=black)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?logo=postgresql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-Dashboard-F2C811)
![Python](https://img.shields.io/badge/Python-3.11-3776AB?logo=python&logoColor=white)

## Business question

Where is revenue lost to cart abandonment (by category and brand), and which products, brands
and time windows concentrate conversion? Secondary: funnel evolution `view → cart → purchase`
over time (incl. Black Friday 2019-11-29), traffic vs. purchase hours, and AOV by segment.

## Architecture

[TODO: `docs/img/architecture.png` — export from mermaid.live]

`Kaggle CSV (14.3 GB) → HDFS bronze → silver → gold (Parquet/Snappy) → PostgreSQL (serving) → Power BI / Cognos`

## Key results

| Metric | Value |
|---|---|
| Events processed | [TODO after full run] |
| Total revenue (Oct–Nov 2019) | [TODO] |
| Conversion rate | [TODO] |
| Cart abandonment rate | [TODO] |
| AOV | [TODO] |
| Full pipeline runtime (16 GB laptop) | [TODO] |

## Tech stack

| Layer | Tech |
|---|---|
| Containers | Docker Compose (WSL2) |
| Storage | HDFS 3.4 (1 namenode + 1 datanode) |
| Compute | Spark 3.5 standalone (PySpark) |
| Format | Parquet + Snappy, medallion (bronze/silver/gold) |
| Serving | PostgreSQL 16 (BI-agnostic) |
| BI | Power BI Desktop · IBM Cognos Analytics (trial evidence) |

## Data model

Star schema: `fact_sales` + aggregate facts (`fact_kpi_daily`, `fact_funnel_daily`,
`fact_hourly_traffic`, `fact_product_daily`) over conformed dimensions `dim_date`, `dim_product`.
Full dictionary: [`docs/data_dictionary.md`](docs/data_dictionary.md) [TODO].

[TODO: `docs/img/star_schema.png`]

## How to run

```bash
docker compose -f docker/docker-compose.yml up -d
bash scripts/run_pipeline.sh
# Open bi/powerbi/dashboard.pbix → Refresh (PostgreSQL localhost:5432, schema: gold)
```

Data download (not versioned): see [`scripts/download_data.md`](scripts/download_data.md).

## Pipeline metrics

[TODO: link `docs/pipeline_metrics.md` — rows in/out per layer, job durations, layer sizes, machine specs.]

## Data quality

Every run writes a JSON + Markdown quality report: row reconciliation CSV↔parquet↔PostgreSQL,
schema enforcement, dedupe stats, quarantine counts, referential integrity, KPI sanity ranges.
Reports in [`docs/quality_reports/`](docs/quality_reports/). [TODO: link final full-run report.]

## Decision records

| ADR | Title | Status |
|---|---|---|
| [001](docs/decision_records/ADR-001-dataset-selection.md) | Dataset selection | Accepted |
| [002](docs/decision_records/ADR-002-local-lakehouse-hdfs-spark.md) | Local lakehouse: HDFS + Spark standalone in Docker | Accepted |
| 003 | Order definition without order_id | [TODO F4] |
| 004 | Partitioning strategy | [TODO F3] |
| 005 | SCD policy for dim_product | [TODO F4] |
| 006 | Serving granularity | [TODO F4] |
| 007 | BI-agnostic serving layer | [TODO F4] |
| 008 | Resource-constrained design | [TODO F4] |

## Attribution

Dataset: [*eCommerce behavior data from multi category store*](https://www.kaggle.com/datasets/mkechinov/ecommerce-behavior-data-from-multi-category-store),
provided by [REES46 Marketing Platform](https://rees46.com). Use requires attribution — see
[`LICENSE-DATA.md`](LICENSE-DATA.md). Code is MIT licensed.