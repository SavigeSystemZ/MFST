#!/usr/bin/env bash
set -euo pipefail

# Arguments: <TEMPLATE_ROOT>
# Runs: bash -n, shellcheck (if available), JSON structure check, health-check, smoke scaffold.

TEMPLATE="${1:?Usage: $0 /path/to/_Template_Fiction_System}"
[[ -d "$TEMPLATE/scripts" ]] || { echo "Not a template root: ${TEMPLATE@Q}" >&2; exit 1; }

echo "=== bash -n (template scripts) ==="
for s in "$TEMPLATE/scripts"/*.sh; do
  bash -n "$s"
  echo "OK $s"
done

if command -v shellcheck >/dev/null 2>&1; then
  echo "=== shellcheck (template scripts) ==="
  shellcheck "$TEMPLATE/scripts"/*.sh
  echo "OK shellcheck"
else
  echo "SKIP shellcheck (not installed)"
fi

echo "=== MCP JSON structure ==="
export MYLIT_TEMPLATE="$TEMPLATE"
python3 - <<'PY'
import json, pathlib, os

p = pathlib.Path(os.environ["MYLIT_TEMPLATE"]) / "mcp" / "mcp-server-config.json"
cfg = json.loads(p.read_text(encoding="utf-8"))
srv = cfg.get("mcpServers")
assert isinstance(srv, dict) and srv, "mcpServers must be a non-empty object"
for name, spec in srv.items():
    assert isinstance(spec, dict), f"{name}: must be object"
    assert "command" in spec, f"{name}: missing command"
    assert "args" in spec and isinstance(spec["args"], list), f"{name}: args must be list"
print("OK mcp structure:", ", ".join(srv.keys()))
PY

echo "=== health-check (template as book) ==="
( cd "$TEMPLATE" && ./scripts/health-check.sh )

echo "=== smoke scaffold (creates sibling dir, then removes) ==="
"$TEMPLATE/tests/smoke-scaffold.sh"

echo "=== ci-full-template: PASS ==="
