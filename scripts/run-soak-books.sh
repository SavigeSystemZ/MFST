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

while [[ $# -gt 0 ]]; do
  case "$1" in
    --count) count="${2:?missing value}"; shift 2 ;;
    --mutate) mutate_count="${2:?missing value}"; shift 2 ;;
    --prefix) prefix="${2:?missing value}"; shift 2 ;;
    --out) out_name="${2:?missing value}"; shift 2 ;;
    --cleanup) cleanup=1; shift ;;
    -h|--help)
      echo "Usage: $0 [--count N] [--mutate N] [--prefix NAME] [--out DIR] [--cleanup]"
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

echo "=== soak start ==="
echo "fiction_root: $fiction_root"
echo "workdir:      $workdir"
echo "count:        $count"
echo "mutate_count: $mutate_count"
echo "cleanup:      $cleanup"

scaffold_start="$(date +%s)"
for i in $(seq 1 "$count"); do
  name="$(printf "%s-%03d-Book" "$prefix" "$i")"
  "$template_root/scripts/scaffold-from-template.sh" "$name" >/dev/null
done
scaffold_end="$(date +%s)"

validate_start="$(date +%s)"
check_pass=0
check_fail=0
for i in $(seq 1 "$count"); do
  name="$(printf "%s-%03d-Book" "$prefix" "$i")"
  d="$fiction_root/$name"
  if (
    cd "$d" &&
    ./scripts/health-check.sh >/dev/null &&
    ./scripts/ensure-context.sh --status >/dev/null &&
    ./scripts/book-writing-quality-check.sh >/dev/null
  ); then
    check_pass=$((check_pass + 1))
  else
    check_fail=$((check_fail + 1))
  fi
done
validate_end="$(date +%s)"

mutate_list="$workdir/mutated_books.txt"
export SOAK_FICTION_ROOT="$fiction_root"
export SOAK_COUNT="$count"
export SOAK_MUTATE="$mutate_count"
export SOAK_PREFIX="$prefix"
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
for i in $(seq 1 "$count"); do
  name="$(printf "%s-%03d-Book" "$prefix" "$i")"
  MYLIT_INSTALL_NONINTERACTIVE=1 \
  MYLIT_BOOKS_ROOT="$fiction_root" \
  MYLIT_BOOK_DIR="$fiction_root/$name" \
  MYLIT_TEMPLATE_ROOT="$template_root" \
    "$installer" >/dev/null
done
restore_end="$(date +%s)"

restore_pass=0
restore_fail=0
for i in $(seq 1 "$count"); do
  name="$(printf "%s-%03d-Book" "$prefix" "$i")"
  d="$fiction_root/$name"
  if (
    cd "$d" &&
    test -f "workflows/version-control-optional-git.md" &&
    test -f "assets/audio/README.md" &&
    test -f "context/book/threads-and-hooks.md"
  ); then
    restore_pass=$((restore_pass + 1))
  else
    restore_fail=$((restore_fail + 1))
  fi
done

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
python3 - <<'PY'
from pathlib import Path
import json, time
import os
summary = {
  "timestamp_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
  "suite": "book-template soak + merge-restore",
  "count": int(os.environ["SOAK_COUNT"]),
  "mutate_count": int(os.environ["SOAK_MUTATE"]),
  "prefix": os.environ["SOAK_PREFIX"],
  "durations_sec": {
    "scaffold": int(os.environ["SOAK_SCAFFOLD_END"]) - int(os.environ["SOAK_SCAFFOLD_START"]),
    "validate": int(os.environ["SOAK_VALIDATE_END"]) - int(os.environ["SOAK_VALIDATE_START"]),
    "restore": int(os.environ["SOAK_RESTORE_END"]) - int(os.environ["SOAK_RESTORE_START"]),
  },
  "validation": {"pass": int(os.environ["SOAK_CHECK_PASS"]), "fail": int(os.environ["SOAK_CHECK_FAIL"])},
  "restore": {"pass": int(os.environ["SOAK_RESTORE_PASS"]), "fail": int(os.environ["SOAK_RESTORE_FAIL"])}
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
f"- restore: {summary['durations_sec']['restore']}\n",
encoding="utf-8")
PY

if (( cleanup == 1 )); then
  for i in $(seq 1 "$count"); do
    name="$(printf "%s-%03d-Book" "$prefix" "$i")"
    rm -rf "${fiction_root:?}/$name"
  done
fi

echo "=== soak complete ==="
echo "report: $report_md"
echo "json:   $report_json"
echo "validation: pass=$check_pass fail=$check_fail"
echo "restore:    pass=$restore_pass fail=$restore_fail"
