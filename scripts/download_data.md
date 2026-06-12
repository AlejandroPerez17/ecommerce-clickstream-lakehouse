# Data download — Kaggle (raw zone)

Raw data is **never** versioned. Target directory: `data/raw/` (gitignored).
Free disk required: ~25 GB during download (zip + CSVs); ≥60 GB total for the project (§10.1).

## Option A — Kaggle API (recommended, run in WSL)

1. Get an API token: kaggle.com → *Settings* → *API* → **Create New Token** (downloads `kaggle.json`).
2. Configure:

```bash
pip install kaggle
mkdir -p ~/.kaggle
mv /mnt/c/Users/<YOUR_USER>/Downloads/kaggle.json ~/.kaggle/
chmod 600 ~/.kaggle/kaggle.json
```

3. Download and extract (from repo root):

```bash
kaggle datasets download -d mkechinov/ecommerce-behavior-data-from-multi-category-store -p data/raw
unzip -o data/raw/ecommerce-behavior-data-from-multi-category-store.zip -d data/raw
rm data/raw/*.zip   # free ~9 GB once extraction is verified below
```

## Option B — Manual

1. Open https://www.kaggle.com/datasets/mkechinov/ecommerce-behavior-data-from-multi-category-store (login required).
2. Download `2019-Oct.csv` and `2019-Nov.csv` (or the full zip) into `data/raw/` and extract.
   Note: individually downloaded files may arrive as `<name>.csv.zip` — unzip each one.

## Integrity verification (mandatory — record actuals)

```bash
ls -lh data/raw/2019-*.csv
head -n 1 data/raw/2019-Oct.csv
head -n 1 data/raw/2019-Nov.csv
wc -l data/raw/2019-Oct.csv data/raw/2019-Nov.csv
```

| Check | Expected |
|---|---|
| Header (both files) | `event_time,event_type,product_id,category_id,category_code,brand,price,user_id,user_session` |
| `2019-Oct.csv` | ~5.3 GB · 42,448,765 lines (42,448,764 events + header) * |
| `2019-Nov.csv` | ~9.0 GB · 67,501,980 lines (67,501,979 events + header) * |

\* Reference values — **record the actual `wc -l` output** in `docs/pipeline_metrics.md`.
The bronze reconciliation check (§8) requires the exact count: `parquet rows == wc -l − 1`.

If any check fails: delete and re-download. Never patch raw files by hand.