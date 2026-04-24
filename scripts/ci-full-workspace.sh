#!/usr/bin/env bash
set -euo pipefail

# Run from the **Fiction** parent directory (sibling of `_Meta_Fiction_System` and
# `_Template_Fiction_System`), e.g.:
#   ./_Meta_Fiction_System/scripts/ci-full-workspace.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
META="$(cd "$SCRIPT_DIR/.." && pwd)"
FICTION="$(cd "$META/.." && pwd)"
TEMPLATE="$FICTION/_Template_Fiction_System"

[[ -d "$TEMPLATE" ]] || { echo "ERROR: expected template at ${TEMPLATE@Q}" >&2; exit 1; }

exec "$META/scripts/ci-full-template.sh" "$TEMPLATE"
