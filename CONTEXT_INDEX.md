# Context index — meta system (what to load when)

| Task | Load first | Then |
|------|------------|------|
| First-time meta session | `README.md`, `AGENTS.md`, `META_CHARTER.md` | `TEMPLATE_SPEC.md` |
| Editing template behavior | `MASTER_SYSTEM_PROMPT.md` | `WORKFLOWS.md` |
| Before finishing a change | `QUALITY_GATES.md` | `../_Template_Fiction_System/CHANGELOG.md` |
| Book author asks for prose | **Stop meta** — open **book folder** | that project’s `AGENTS.md` |
| MCP / tooling questions | `MCP_AND_TOOLS.md` | template `MCP_GUIDANCE.md` |
| Ownership / root vs user | `../PERMISSIONS_AND_OWNERSHIP.md` | template `BOOK_MANIFEST.yaml` (`preferred_file_owner`) |
| Cross-layer file map | `../SYSTEM_INTEGRATION.md` | — |
| Multi-agent template changes | `MULTI_AGENT_MAINTENANCE.md` | template `HANDOFF_PROTOCOL.md`, `agents/` |
| Context seeds & ensure-context | `CONTEXT_AUTOMATION.md` | template `scripts/ensure-context.sh`, `context/_seeds/` |

## Adjacent paths

- Template root: `../_Template_Fiction_System/`
- Books root: `..` (sibling **folders** per title; git optional)
- Workspace overview: `../ARCHITECTURE_AND_OPERATIONS.md`

---

*Context index version: 1.5.0*
