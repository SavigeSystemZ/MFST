#!/usr/bin/env bash
set -euo pipefail

# Stress/soak harness for MyLit book-template reliability.
# Runs from any cwd; resolves Fiction root from this script location.
#
# Example:
#   ./_Meta_Fiction_System/scripts/run-soak-books.sh --count 100 --cleanup
#
# Defaults:
# - count: 25 books
# - mutate: max(1, count/5) books
# - output folder: _StressSoak_<count>_<timestamp>
# - cleanup: false (keeps generated books for inspection)

count=25
cleanup=0
prefix="Load"
out_name=""
mutate_count=0
parallel=1
prune_existing=0
export_csv_path=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --count) count="${2:?missing value}"; shift 2 ;;
    --mutate) mutate_count="${2:?missing value}"; shift 2 ;;
    --prefix) prefix="${2:?missing value}"; shift 2 ;;
    --out) out_name="${2:?missing value}"; shift 2 ;;
    --parallel) parallel="${2:?missing value}"; shift 2 ;;
    --export-csv) export_csv_path="${2:?missing value}"; shift 2 ;;
    --prune-existing) prune_existing=1; shift ;;
    --cleanup) cleanup=1; shift ;;
    -h|--help)
      echo "Usage: $0 [--count N] [--mutate N] [--prefix NAME] [--out DIR] [--parallel N] [--export-csv PATH|auto] [--prune-existing] [--cleanup]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

[[ "$count" =~ ^[0-9]+$ ]] || { echo "--count must be integer" >&2; exit 1; }
(( count > 0 )) || { echo "--count must be > 0" >&2; exit 1; }
if [[ "$mutate_count" =~ ^[0-9]+$ ]]; then :; else echo "--mutate must be integer" >&2; exit 1; fi
if (( mutate_count == 0 )); then mutate_count=$(( count / 5 )); fi
if (( mutate_count < 1 )); then mutate_count=1; fi
if (( mutate_count > count )); then mutate_count="$count"; fi
[[ "$parallel" =~ ^[0-9]+$ ]] || { echo "--parallel must be integer" >&2; exit 1; }
(( parallel > 0 )) || { echo "--parallel must be > 0" >&2; exit 1; }

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
meta_root="$(cd "$script_dir/.." && pwd)"
fiction_root="$(cd "$meta_root/.." && pwd)"
template_root="$fiction_root/_Template_Fiction_System"
installer="$fiction_root/install-mylit-book.sh"

[[ -d "$template_root" ]] || { echo "Missing template root: ${template_root@Q}" >&2; exit 1; }
[[ -x "$installer" ]] || { echo "Missing installer: ${installer@Q}" >&2; exit 1; }

ts="$(date -u +%Y%m%dT%H%M%SZ)"
if [[ -z "$out_name" ]]; then
  out_name="_StressSoak_${count}_${ts}"
fi
workdir="$fiction_root/$out_name"
mkdir -p "$workdir"

report_md="$workdir/REPORT.md"
report_json="$workdir/results.json"
timings_dir="$workdir/timings"
mkdir -p "$timings_dir/scaffold" "$timings_dir/validate" "$timings_dir/restore"

run_parallel_stage() {
  # run_parallel_stage <label> <function_name> <count> <parallel>
  local label="$1"
  local fn="$2"
  local n="$3"
  local pool="$4"
  local running=0
  local failed=0
  local i
  for i in $(seq 1 "$n"); do
    "$fn" "$i" &
    running=$((running + 1))
    if (( running >= pool )); then
      if ! wait -n; then
        failed=1
      fi
      running=$((running - 1))
    fi
  done
  while (( running > 0 )); do
    if ! wait -n; then
      failed=1
    fi
    running=$((running - 1))
  done
  if (( failed != 0 )); then
    echo "FAIL: stage ${label} had one or more job failures." >&2
    return 1
  fi
}

scaffold_one() {
  local i="$1"
  local name
  local t0 t1
  name="$(printf "%s-%03d-Book" "$prefix" "$i")"
  t0=$(date +%s%N)
  "$template_root/scripts/scaffold-from-template.sh" "$name" >/dev/null
  t1=$(date +%s%N)
  echo $(((t1 - t0) / 1000000)) > "$timings_dir/scaffold/${i}.ms"
}

validate_one() {
  local i="$1"
  local name d t0 t1
  name="$(printf "%s-%03d-Book" "$prefix" "$i")"
  d="$fiction_root/$name"
  t0=$(date +%s%N)
  if (
    cd "$d" &&
    ./scripts/health-check.sh >/dev/null &&
    ./scripts/ensure-context.sh --status >/dev/null &&
    ./scripts/book-writing-quality-check.sh >/dev/null
  ); then
    : > "$workdir/validate-${i}.ok"
  else
    : > "$workdir/validate-${i}.fail"
  fi
  t1=$(date +%s%N)
  echo $(((t1 - t0) / 1000000)) > "$timings_dir/validate/${i}.ms"
}

restore_one() {
  local i="$1"
  local name t0 t1
  name="$(printf "%s-%03d-Book" "$prefix" "$i")"
  t0=$(date +%s%N)
  MYLIT_INSTALL_NONINTERACTIVE=1 \
  MYLIT_BOOKS_ROOT="$fiction_root" \
  MYLIT_BOOK_DIR="$fiction_root/$name" \
  MYLIT_TEMPLATE_ROOT="$template_root" \
    "$installer" >/dev/null
  t1=$(date +%s%N)
  echo $(((t1 - t0) / 1000000)) > "$timings_dir/restore/${i}.ms"
}

restore_verify_one() {
  local i="$1"
  local name d
  name="$(printf "%s-%03d-Book" "$prefix" "$i")"
  d="$fiction_root/$name"
  if (
    cd "$d" &&
    test -f "workflows/version-control-optional-git.md" &&
    test -f "assets/audio/README.md" &&
    test -f "context/book/threads-and-hooks.md"
  ); then
    : > "$workdir/restore-${i}.ok"
  else
    : > "$workdir/restore-${i}.fail"
  fi
}

echo "=== soak start ==="
echo "fiction_root: $fiction_root"
echo "workdir:      $workdir"
echo "count:        $count"
echo "mutate_count: $mutate_count"
echo "parallel:     $parallel"
echo "prune_exist:  $prune_existing"
echo "export_csv:   ${export_csv_path:-<disabled>}"
echo "cleanup:      $cleanup"

# Guard against collisions from prior runs with same prefix/count.
if (( prune_existing == 1 )); then
  for i in $(seq 1 "$count"); do
    name="$(printf "%s-%03d-Book" "$prefix" "$i")"
    rm -rf "${fiction_root:?}/$name"
  done
fi

scaffold_start="$(date +%s)"
run_parallel_stage "scaffold" scaffold_one "$count" "$parallel"
scaffold_end="$(date +%s)"

validate_start="$(date +%s)"
rm -f "$workdir"/validate-*.ok "$workdir"/validate-*.fail
run_parallel_stage "validate" validate_one "$count" "$parallel"
check_pass=$(find "$workdir" -maxdepth 1 -type f -name 'validate-*.ok' | wc -l | tr -d ' ')
check_fail=$(find "$workdir" -maxdepth 1 -type f -name 'validate-*.fail' | wc -l | tr -d ' ')
validate_end="$(date +%s)"

mutate_list="$workdir/mutated_books.txt"
export SOAK_FICTION_ROOT="$fiction_root"
export SOAK_COUNT="$count"
export SOAK_MUTATE="$mutate_count"
export SOAK_PREFIX="$prefix"
export SOAK_PARALLEL="$parallel"
export SOAK_MUTATE_LIST="$mutate_list"
python3 - <<'PY'
from pathlib import Path
import random
import os
root = Path(os.environ["SOAK_FICTION_ROOT"])
count = int(os.environ["SOAK_COUNT"])
mutate = int(os.environ["SOAK_MUTATE"])
prefix = os.environ["SOAK_PREFIX"]
books = [root / f"{prefix}-{i:03d}-Book" for i in range(1, count + 1)]
random.seed(20260424)
chosen = random.sample(books, mutate)
for b in chosen:
    for rel in ("workflows/version-control-optional-git.md", "assets/audio/README.md", "context/book/threads-and-hooks.md"):
        p = b / rel
        if p.exists():
            p.unlink()
Path(os.environ["SOAK_MUTATE_LIST"]).write_text("\n".join(str(p.name) for p in chosen) + "\n", encoding="utf-8")
PY

restore_start="$(date +%s)"
run_parallel_stage "restore" restore_one "$count" "$parallel"
restore_end="$(date +%s)"

rm -f "$workdir"/restore-*.ok "$workdir"/restore-*.fail
run_parallel_stage "restore-verify" restore_verify_one "$count" "$parallel"
restore_pass=$(find "$workdir" -maxdepth 1 -type f -name 'restore-*.ok' | wc -l | tr -d ' ')
restore_fail=$(find "$workdir" -maxdepth 1 -type f -name 'restore-*.fail' | wc -l | tr -d ' ')

export SOAK_SCAFFOLD_START="$scaffold_start"
export SOAK_SCAFFOLD_END="$scaffold_end"
export SOAK_VALIDATE_START="$validate_start"
export SOAK_VALIDATE_END="$validate_end"
export SOAK_RESTORE_START="$restore_start"
export SOAK_RESTORE_END="$restore_end"
export SOAK_CHECK_PASS="$check_pass"
export SOAK_CHECK_FAIL="$check_fail"
export SOAK_RESTORE_PASS="$restore_pass"
export SOAK_RESTORE_FAIL="$restore_fail"
export SOAK_REPORT_JSON="$report_json"
export SOAK_REPORT_MD="$report_md"
export SOAK_TIMINGS_DIR="$timings_dir"
python3 - <<'PY'
from pathlib import Path
import json, time
import os

def pct(vals, q):
    if not vals:
        return 0
    vals = sorted(vals)
    idx = int(round((q / 100.0) * (len(vals) - 1)))
    idx = max(0, min(idx, len(vals) - 1))
    return vals[idx]

def load_ms(stage):
    d = Path(os.environ["SOAK_TIMINGS_DIR"]) / stage
    out = []
    for p in sorted(d.glob("*.ms")):
        try:
            out.append(int(p.read_text().strip()))
        except Exception:
            pass
    return out

scaffold_ms = load_ms("scaffold")
validate_ms = load_ms("validate")
restore_ms = load_ms("restore")

summary = {
  "timestamp_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
  "suite": "book-template soak + merge-restore",
  "count": int(os.environ["SOAK_COUNT"]),
  "mutate_count": int(os.environ["SOAK_MUTATE"]),
  "parallel": int(os.environ.get("SOAK_PARALLEL", "0")),
  "prefix": os.environ["SOAK_PREFIX"],
  "durations_sec": {
    "scaffold": int(os.environ["SOAK_SCAFFOLD_END"]) - int(os.environ["SOAK_SCAFFOLD_START"]),
    "validate": int(os.environ["SOAK_VALIDATE_END"]) - int(os.environ["SOAK_VALIDATE_START"]),
    "restore": int(os.environ["SOAK_RESTORE_END"]) - int(os.environ["SOAK_RESTORE_START"]),
  },
  "validation": {"pass": int(os.environ["SOAK_CHECK_PASS"]), "fail": int(os.environ["SOAK_CHECK_FAIL"])},
  "restore": {"pass": int(os.environ["SOAK_RESTORE_PASS"]), "fail": int(os.environ["SOAK_RESTORE_FAIL"])},
  "latency_ms": {
    "scaffold": {"count": len(scaffold_ms), "p50": pct(scaffold_ms, 50), "p90": pct(scaffold_ms, 90), "p99": pct(scaffold_ms, 99), "max": max(scaffold_ms) if scaffold_ms else 0, "avg": int(sum(scaffold_ms) / len(scaffold_ms)) if scaffold_ms else 0},
    "validate": {"count": len(validate_ms), "p50": pct(validate_ms, 50), "p90": pct(validate_ms, 90), "p99": pct(validate_ms, 99), "max": max(validate_ms) if validate_ms else 0, "avg": int(sum(validate_ms) / len(validate_ms)) if validate_ms else 0},
    "restore": {"count": len(restore_ms), "p50": pct(restore_ms, 50), "p90": pct(restore_ms, 90), "p99": pct(restore_ms, 99), "max": max(restore_ms) if restore_ms else 0, "avg": int(sum(restore_ms) / len(restore_ms)) if restore_ms else 0},
  }
}
Path(os.environ["SOAK_REPORT_JSON"]).write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
Path(os.environ["SOAK_REPORT_MD"]).write_text(
f"# Soak Report\n\n"
f"- Timestamp (UTC): {summary['timestamp_utc']}\n"
f"- Count: {summary['count']}\n"
f"- Mutated books: {summary['mutate_count']}\n"
f"- Prefix: `{summary['prefix']}`\n\n"
f"## Validation\n\n"
f"- health/context/domain checks: {summary['validation']['pass']}/{summary['count']} pass\n"
f"- failures: {summary['validation']['fail']}\n\n"
f"## Merge-restore\n\n"
f"- restore checks: {summary['restore']['pass']}/{summary['count']} pass\n"
f"- failures: {summary['restore']['fail']}\n\n"
f"## Durations (sec)\n\n"
f"- scaffold: {summary['durations_sec']['scaffold']}\n"
f"- validate: {summary['durations_sec']['validate']}\n"
f"- restore: {summary['durations_sec']['restore']}\n\n"
f"## Latency percentiles (ms)\n\n"
f"- scaffold: p50={summary['latency_ms']['scaffold']['p50']} p90={summary['latency_ms']['scaffold']['p90']} p99={summary['latency_ms']['scaffold']['p99']} avg={summary['latency_ms']['scaffold']['avg']} max={summary['latency_ms']['scaffold']['max']}\n"
f"- validate: p50={summary['latency_ms']['validate']['p50']} p90={summary['latency_ms']['validate']['p90']} p99={summary['latency_ms']['validate']['p99']} avg={summary['latency_ms']['validate']['avg']} max={summary['latency_ms']['validate']['max']}\n"
f"- restore: p50={summary['latency_ms']['restore']['p50']} p90={summary['latency_ms']['restore']['p90']} p99={summary['latency_ms']['restore']['p99']} avg={summary['latency_ms']['restore']['avg']} max={summary['latency_ms']['restore']['max']}\n",
encoding="utf-8")
PY

# Optional per-book timing CSV export.
if [[ -n "$export_csv_path" ]]; then
  if [[ "$export_csv_path" == "auto" ]]; then
    export_csv_path="$workdir/timings.csv"
  elif [[ "$export_csv_path" != /* ]]; then
    export_csv_path="$workdir/$export_csv_path"
  fi
  export SOAK_EXPORT_CSV="$export_csv_path"
  python3 - <<'PY'
from pathlib import Path
import os

root = Path(os.environ["SOAK_TIMINGS_DIR"])
out = Path(os.environ["SOAK_EXPORT_CSV"])
rows = ["stage,book_index,latency_ms"]
for stage in ("scaffold", "validate", "restore"):
    d = root / stage
    for p in sorted(d.glob("*.ms")):
        idx = p.stem
        ms = p.read_text().strip()
        rows.append(f"{stage},{idx},{ms}")
out.write_text("\n".join(rows) + "\n", encoding="utf-8")
print("WROTE_CSV", out)
PY
fi

# Trim marker files from final artifact directory; timings + report remain.
rm -f "$workdir"/validate-*.ok "$workdir"/validate-*.fail "$workdir"/restore-*.ok "$workdir"/restore-*.fail

if (( cleanup == 1 )); then
  for i in $(seq 1 "$count"); do
    name="$(printf "%s-%03d-Book" "$prefix" "$i")"
    rm -rf "${fiction_root:?}/$name"
  done
fi

echo "=== soak complete ==="
echo "report: $report_md"
echo "json:   $report_json"
if [[ -n "$export_csv_path" ]]; then
  echo "csv:    $export_csv_path"
fi
echo "validation: pass=$check_pass fail=$check_fail"
echo "restore:    pass=$restore_pass fail=$restore_fail"
