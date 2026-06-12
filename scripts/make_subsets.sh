#!/usr/bin/env bash
# Generates smoke (100k rows) and dev (5M rows) subsets from 2019-Oct.csv (§7.1).
# Run from the repo root in WSL — head is orders of magnitude faster than PowerShell.
# These files feed the --env smoke|dev pipeline modes.
set -euo pipefail

SRC="data/raw/2019-Oct.csv"
SMOKE_OUT="data/raw/smoke_2019-Oct.csv"
DEV_OUT="data/raw/dev_2019-Oct.csv"
SMOKE_LINES=100001    # header + 100,000 events
DEV_LINES=5000001     # header + 5,000,000 events
EXPECTED_HEADER='event_time,event_type,product_id,category_id,category_code,brand,price,user_id,user_session'

if [[ ! -f "$SRC" ]]; then
  echo "ERROR: $SRC not found. Follow scripts/download_data.md first." >&2
  exit 1
fi

echo "Generating smoke subset ($SMOKE_LINES lines)..."
head -n "$SMOKE_LINES" "$SRC" > "$SMOKE_OUT"

echo "Generating dev subset ($DEV_LINES lines)..."
head -n "$DEV_LINES" "$SRC" > "$DEV_OUT"

# ── Validation ──
fail=0
for spec in "$SMOKE_OUT:$SMOKE_LINES" "$DEV_OUT:$DEV_LINES"; do
  path="${spec%%:*}"
  expected="${spec##*:}"
  actual=$(wc -l < "$path")
  header=$(head -n 1 "$path" | tr -d '\r')
  if [[ "$actual" -ne "$expected" ]]; then
    echo "FAIL: $path -> $actual lines (expected $expected)"
    fail=1
  elif [[ "$header" != "$EXPECTED_HEADER" ]]; then
    echo "FAIL: $path -> header mismatch: $header"
    fail=1
  else
    echo "OK:   $path -> $actual lines, header verified ($(du -h "$path" | cut -f1))"
  fi
done

exit "$fail"