# ADR-001: Dataset selection

- **Status:** Accepted
- **Date:** 2026-06-10
- **Context:** The project needs a real, free dataset large enough to justify Spark/HDFS
  (≥100M rows), with business semantics supporting funnel and revenue KPIs
  (view → cart → purchase), a clear license, a path to scale without code changes,
  and feasibility on a 16 GB laptop (design doc §1, §10).
- **Decision:** Use the REES46 "eCommerce behavior data from multi category store" dataset
  from Kaggle, months Oct + Nov 2019 (~110M events, ~14.3 GB CSV), with mandatory attribution.
- **Alternatives considered:**
  - NYC Taxi (TLC): comparable volume, but no e-commerce funnel/revenue semantics and overused in portfolios.
  - Ecobici CDMX trips: local relevance, but low volume (weak big-data justification) and no monetary KPIs.
  - Synthetic clickstream generator: unlimited volume, but no real-world data-quality issues and weak portfolio credibility.
- **Consequences:** Gains: canonical Spark use case (sessionization, dedupe, window functions),
  Black Friday storytelling, documented extension path to 285M events (§7.3). Sacrifices:
  no `order_id`/`quantity` columns (order must be derived — future ADR-003), high null rates
  in `category_code` (~30%) and `brand` (~14%) requiring an `unknown` policy, and attribution
  obligations (LICENSE-DATA.md).