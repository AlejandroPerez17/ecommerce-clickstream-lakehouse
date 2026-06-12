# Data License & Attribution

The dataset used in this project is **not** included in this repository and is **not**
covered by the code's MIT license.

## Dataset

- **Name:** eCommerce behavior data from multi category store
- **Source:** https://www.kaggle.com/datasets/mkechinov/ecommerce-behavior-data-from-multi-category-store
- **Provided by:** [REES46 Marketing Platform](https://rees46.com) (Open CDP project)
- **Files used (v1.0):** `2019-Oct.csv`, `2019-Nov.csv` (~110M events, ~14.3 GB)

## License terms

The dataset is free to use **with mandatory attribution**: any use must reference both the
Kaggle dataset page and REES46 Marketing Platform (links above), as stated on the dataset page.

## How this repository complies

- Raw data is never committed: `data/` is gitignored; download steps in `scripts/download_data.md`.
- Attribution links are present in this file and in the project README.
- Derived aggregates exported for BI evidence (e.g. Cognos uploads) retain this attribution.