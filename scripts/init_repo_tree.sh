#!/usr/bin/env bash
# Creates the full repository tree defined in ECOMMERCE-LAKEHOUSE-DESIGN.md §9.
# Idempotent: safe to re-run. Run from the repo root in WSL.
set -euo pipefail

if [[ ! -d .git ]]; then
  echo "WARN: no .git found — make sure you are at the repo root." >&2
fi

# Versioned directories (get .gitkeep if empty)
DIRS=(
  docker/conf
  src/common
  src/jobs
  sql
  scripts
  bi/powerbi
  bi/cognos/exports
  bi/cognos/evidence
  docs/img
  docs/quality_reports
  docs/decision_records
  notebooks
  tests
)

# Local-only data zones (gitignored, no .gitkeep needed)
DATA_DIRS=(
  data/raw
)

for d in "${DIRS[@]}"; do
  mkdir -p "$d"
  if [[ -z "$(ls -A "$d")" ]]; then
    touch "$d/.gitkeep"
  fi
done

for d in "${DATA_DIRS[@]}"; do
  mkdir -p "$d"
done

echo "Tree created:"
find . -path ./.git -prune -o -type d -print | sort