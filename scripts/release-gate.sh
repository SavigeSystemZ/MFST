#!/usr/bin/env bash
set -euo pipefail

# Release gate for MyLit meta/template quality.
# Runs governance CI, full workspace checks, soak test, and optional trend comparison.
#
# Example:
#   ./_Meta_Fiction_System/scripts/release-gate.sh \
#     --count 100 --parallel 8 --baseline baselines/latest.json --update-baseline

count=100
parallel=8
out_name=""
baseline_rel="baselines/latest.json"
noise_ms=5
regress_pct=15
update_baseline=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --count) count="${2:?missing value}"; shift 2 ;;
    --parallel) parallel="${2:?missing value}"; shift 2 ;;
    --out) out_name="${2:?missing value}"; shift 2 ;;
    --baseline) baseline_rel="${2:?missing value}"; shift 2 ;;
    --latency-noise-ms) noise_ms="${2:?missing value}"; shift 2 ;;
    --latency-regress-pct) regress_pct="${2:?missing value}"; shift 2 ;;
    --update-baseline) update_baseline=1; shift ;;
    -h|--help)
      echo "Usage: $0 [--count N] [--parallel N] [--out DIR] [--baseline RELPATH] [--latency-noise-ms N] [--latency-regress-pct N] [--update-baseline]"
      exit 0
      ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
meta_root="$(cd "$script_dir/.." && pwd)"
fiction_root="$(cd "$meta_root/.." && pwd)"

ts="$(date -u +%Y%m%dT%H%M%SZ)"
if [[ -z "$out_name" ]]; then
  out_name="_StressSoak_ReleaseGate_${count}_${ts}"
fi

baseline_abs="$meta_root/$baseline_rel"
out_abs="$fiction_root/$out_name"
compare_md="$out_abs/COMPARE.md"

echo "=== release gate start ==="
echo "meta_root:  $meta_root"
echo "fiction:    $fiction_root"
echo "count:      $count"
echo "parallel:   $parallel"
echo "out:        $out_abs"
echo "baseline:   $baseline_abs"

( cd "$meta_root" && ./scripts/ci-verify.sh )
( cd "$fiction_root" && ./_Meta_Fiction_System/scripts/ci-full-workspace.sh )

( cd "$fiction_root" && ./_Meta_Fiction_System/scripts/run-soak-books.sh \
    --count "$count" \
    --parallel "$parallel" \
    --prune-existing \
    --cleanup \
    --export-csv auto \
    --prefix "Gate" \
    --out "$out_name" )

if [[ -f "$baseline_abs" ]]; then
  echo "=== comparing against baseline ==="
  ( cd "$fiction_root" && ./_Meta_Fiction_System/scripts/compare-soak-results.sh \
      "$baseline_abs" \
      "$out_abs/results.json" \
      --latency-noise-ms "$noise_ms" \
      --latency-regress-pct "$regress_pct" \
      --strict \
      --markdown "$compare_md" )
else
  echo "NOTE: baseline missing; skipping strict compare."
fi

if (( update_baseline == 1 )); then
  mkdir -p "$(dirname "$baseline_abs")"
  cp "$out_abs/results.json" "$baseline_abs"
  echo "UPDATED_BASELINE: $baseline_abs"
fi

echo "=== release gate PASS ==="
echo "report:  $out_abs/REPORT.md"
echo "results: $out_abs/results.json"
echo "csv:     $out_abs/timings.csv"
if [[ -f "$compare_md" ]]; then
  echo "compare: $compare_md"
fi
