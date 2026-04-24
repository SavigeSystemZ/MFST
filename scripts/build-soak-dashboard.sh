#!/usr/bin/env bash
set -euo pipefail

# Build a Markdown dashboard from _StressSoak_*/results.json files.
#
# Usage:
#   ./scripts/build-soak-dashboard.sh
#   ./scripts/build-soak-dashboard.sh --limit 30 --out soak-dashboard/README.md

limit=50
out_rel="soak-dashboard/README.md"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --limit) limit="${2:?missing value}"; shift 2 ;;
    --out) out_rel="${2:?missing value}"; shift 2 ;;
    -h|--help)
      echo "Usage: $0 [--limit N] [--out RELPATH]"
      exit 0
      ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

[[ "$limit" =~ ^[0-9]+$ ]] || { echo "--limit must be integer" >&2; exit 1; }
(( limit > 0 )) || { echo "--limit must be > 0" >&2; exit 1; }

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
meta_root="$(cd "$script_dir/.." && pwd)"
fiction_root="$(cd "$meta_root/.." && pwd)"
out_abs="$meta_root/$out_rel"
mkdir -p "$(dirname "$out_abs")"

export SOAK_FICTION_ROOT="$fiction_root"
export SOAK_LIMIT="$limit"
export SOAK_OUT="$out_abs"

python3 - <<'PY'
from pathlib import Path
import json, os
from datetime import datetime, timezone

fiction = Path(os.environ["SOAK_FICTION_ROOT"])
limit = int(os.environ["SOAK_LIMIT"])
out = Path(os.environ["SOAK_OUT"])

rows = []
for d in fiction.glob("_StressSoak_*"):
    r = d / "results.json"
    if not r.exists():
        continue
    try:
        data = json.loads(r.read_text(encoding="utf-8"))
    except Exception:
        continue
    if "suite" not in data:
        continue
    ts = data.get("timestamp_utc", "")
    rows.append((ts, d.name, data))

rows.sort(key=lambda x: x[0], reverse=True)
rows = rows[:limit]

def g(d, *keys, default=0):
    cur = d
    for k in keys:
        if not isinstance(cur, dict) or k not in cur:
            return default
        cur = cur[k]
    return cur

lines = [
    "# Soak Dashboard",
    "",
    f"- Generated: {datetime.now(timezone.utc).isoformat(timespec='seconds')}",
    f"- Source: `{fiction}`",
    f"- Entries: {len(rows)} (limit={limit})",
    "",
    "| Run | Timestamp | Count | Parallel | Val Fail | Restore Fail | Scaf p90 | Val p90 | Rest p90 | Report |",
    "|---|---|---:|---:|---:|---:|---:|---:|---:|---|",
]

for ts, name, data in rows:
    count = g(data, "count", default=0)
    parallel = g(data, "parallel", default="n/a")
    vfail = g(data, "validation", "fail", default=0)
    rfail = g(data, "restore", "fail", default=0)
    sp90 = g(data, "latency_ms", "scaffold", "p90", default=0)
    vp90 = g(data, "latency_ms", "validate", "p90", default=0)
    rp90 = g(data, "latency_ms", "restore", "p90", default=0)
    report = f"`{name}/REPORT.md`"
    lines.append(f"| `{name}` | {ts or 'n/a'} | {count or 'n/a'} | {parallel} | {vfail} | {rfail} | {sp90} | {vp90} | {rp90} | {report} |")

out.write_text("\n".join(lines) + "\n", encoding="utf-8")
print(f"WROTE_DASHBOARD {out}")
PY
