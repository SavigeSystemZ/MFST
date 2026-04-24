#!/usr/bin/env bash
set -euo pipefail

# Compare two soak results.json files and print regression deltas.
#
# Usage:
#   ./scripts/compare-soak-results.sh OLD.json NEW.json
#   ./scripts/compare-soak-results.sh OLD.json NEW.json --markdown OUT.md

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 OLD.json NEW.json [--markdown OUT.md]" >&2
  exit 1
fi

old="$1"
new="$2"
shift 2
md_out=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --markdown) md_out="${2:?missing value}"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

[[ -f "$old" ]] || { echo "Missing file: ${old@Q}" >&2; exit 1; }
[[ -f "$new" ]] || { echo "Missing file: ${new@Q}" >&2; exit 1; }

export SOAK_OLD="$old"
export SOAK_NEW="$new"
export SOAK_MD_OUT="$md_out"

python3 - <<'PY'
import json, os
from pathlib import Path

old = json.loads(Path(os.environ["SOAK_OLD"]).read_text(encoding="utf-8"))
new = json.loads(Path(os.environ["SOAK_NEW"]).read_text(encoding="utf-8"))
md_out = os.environ.get("SOAK_MD_OUT", "")

def g(d, *keys, default=0):
    cur = d
    for k in keys:
        if not isinstance(cur, dict) or k not in cur:
            return default
        cur = cur[k]
    return cur

def exists_path(d, path):
    cur = d
    for k in path:
        if not isinstance(cur, dict) or k not in cur:
            return False
        cur = cur[k]
    return True

def delta(path):
    ov = g(old, *path, default=0)
    nv = g(new, *path, default=0)
    has_old = exists_path(old, path)
    return ov, nv, nv - ov, has_old

rows = []
for stage in ("scaffold", "validate", "restore"):
    for metric in ("p50", "p90", "p99", "avg", "max"):
        ov, nv, dv, has_old = delta(("latency_ms", stage, metric))
        rows.append((f"{stage}.{metric}", ov, nv, dv, has_old, "latency"))

ov, nv, dv, has_old = delta(("validation", "fail"))
rows.append(("validation.fail", ov, nv, dv, has_old, "fail"))
ov, nv, dv, has_old = delta(("restore", "fail"))
rows.append(("restore.fail", ov, nv, dv, has_old, "fail"))

print("=== Soak Comparison ===")
print("old:", os.environ["SOAK_OLD"])
print("new:", os.environ["SOAK_NEW"])
print("")
print(f"{'metric':28} {'old':>8} {'new':>8} {'delta':>8}")
for m, o, n, d, has_old, _kind in rows:
    old_s = str(o) if has_old else "n/a"
    delta_s = str(d) if has_old else "n/a"
    print(f"{m:28} {old_s:>8} {n:8} {delta_s:>8}")

regressions = []
missing_baseline = []
for m, o, n, d, has_old, kind in rows:
    if not has_old and kind == "latency":
        missing_baseline.append(m)
        continue
    if m.endswith(".fail"):
        if d > 0:
            regressions.append((m, d))
    else:
        if d > 0:
            regressions.append((m, d))

if regressions:
    print("\nSTATUS: REGRESSION detected")
    for m, d in regressions:
        print(f" - {m}: +{d}")
else:
    print("\nSTATUS: no regressions (non-increasing failures/latencies)")
if missing_baseline:
    print("NOTE: baseline missing latency metrics for:", ", ".join(missing_baseline))

if md_out:
    lines = [
        "# Soak Comparison",
        "",
        f"- old: `{os.environ['SOAK_OLD']}`",
        f"- new: `{os.environ['SOAK_NEW']}`",
        "",
        "| Metric | Old | New | Delta |",
        "|---|---:|---:|---:|",
    ]
    for m, o, n, d, has_old, _kind in rows:
        lines.append(f"| `{m}` | {o if has_old else 'n/a'} | {n} | {d if has_old else 'n/a'} |")
    lines.append("")
    if regressions:
        lines.append("**Status:** REGRESSION detected")
        lines.extend([f"- `{m}`: +{d}" for m, d in regressions])
    else:
        lines.append("**Status:** no regressions (non-increasing failures/latencies)")
    if missing_baseline:
        lines.append("")
        lines.append("**Note:** baseline lacked latency metrics for:")
        lines.extend([f"- `{m}`" for m in missing_baseline])
    Path(md_out).write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"WROTE_MARKDOWN {md_out}")
PY
