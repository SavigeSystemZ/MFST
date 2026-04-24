#!/usr/bin/env bash
set -euo pipefail

# Prune old _StressSoak_* artifact directories under Fiction root.
#
# Usage:
#   ./scripts/prune-soak-artifacts.sh --days 14
#   ./scripts/prune-soak-artifacts.sh --days 30 --dry-run

days=14
dry_run=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --days) days="${2:?missing value}"; shift 2 ;;
    --dry-run) dry_run=1; shift ;;
    -h|--help)
      echo "Usage: $0 [--days N] [--dry-run]"
      exit 0
      ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

[[ "$days" =~ ^[0-9]+$ ]] || { echo "--days must be integer" >&2; exit 1; }
(( days >= 0 )) || { echo "--days must be >= 0" >&2; exit 1; }

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
meta_root="$(cd "$script_dir/.." && pwd)"
fiction_root="$(cd "$meta_root/.." && pwd)"

echo "=== prune soak artifacts ==="
echo "fiction_root: $fiction_root"
echo "days:        $days"
echo "dry_run:     $dry_run"

pruned=0
kept=0
while IFS= read -r -d '' d; do
  if (( dry_run == 1 )); then
    echo "DRY-RUN prune: $d"
  else
    rm -rf "${d:?}"
    echo "PRUNED: $d"
  fi
  pruned=$((pruned + 1))
done < <(find "$fiction_root" -maxdepth 1 -mindepth 1 -type d -name '_StressSoak_*' -mtime +"$days" -print0)

while IFS= read -r -d '' d; do
  kept=$((kept + 1))
done < <(find "$fiction_root" -maxdepth 1 -mindepth 1 -type d -name '_StressSoak_*' -print0)

echo "SUMMARY: pruned=$pruned current_remaining=$kept"
