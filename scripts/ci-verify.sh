#!/usr/bin/env bash
set -euo pipefail

# Meta-only checks (safe on GitHub when the remote is governance Markdown only).
# For full template + scaffold smoke, run from the Fiction parent:
#   ./_Meta_Fiction_System/scripts/ci-full-workspace.sh

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "=== Meta governance file presence ==="
for f in TEMPLATE_SPEC.md QUALITY_GATES.md DRIFT_AND_SYNC.md WORKFLOWS.md CONTEXT_INDEX.md AGENTS.md META_CHARTER.md; do
  [[ -f "$f" ]] || { echo "MISSING: $f" >&2; exit 1; }
  echo "OK $f"
done

echo "=== Meta shell scripts (bash -n) ==="
shopt -s nullglob
scripts=(scripts/*.sh)
if [[ ${#scripts[@]} -eq 0 ]]; then
  echo "(no scripts/*.sh yet)"
else
  for s in "${scripts[@]}"; do
    bash -n "$s"
    echo "OK bash -n $s"
  done
  if command -v shellcheck >/dev/null 2>&1; then
    shellcheck "${scripts[@]}"
    echo "OK shellcheck meta scripts"
  else
    echo "SKIP: shellcheck not installed"
  fi
fi

echo "=== Meta CI verify: PASS ==="
