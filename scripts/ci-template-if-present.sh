#!/usr/bin/env bash
set -euo pipefail

# If this repository ever includes `_Template_Fiction_System/` at its root
# (monorepo layout), run full template checks. Otherwise print a notice.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ -d "$ROOT/_Template_Fiction_System/scripts" ]]; then
  echo "=== Monorepo: running full template CI ==="
  exec "$ROOT/scripts/ci-full-template.sh" "$ROOT/_Template_Fiction_System"
fi

echo "::notice title=Template CI skipped::_Template_Fiction_System/ not at repo root — run scripts/ci-full-workspace.sh from the MyLit Fiction parent on your machine for full checks."
