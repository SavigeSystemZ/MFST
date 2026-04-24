# Meta system — session log

Append **structural** decisions only; book prose belongs in book folders.

---

## 2026-04-23 — Template v1.7.0 optionals

**Goals:**

- Close optional gaps: MCP §6 completeness, `assets/audio/` interim workflow, context seeds for legacy books, `.gitignore`, MCP documentation, meta open-question interim resolutions.

**Decisions:**

- `fiction-fetch` added alongside expanded `fiction-filesystem` roots; Brave block remains optional with placeholder key.
- `health-check.sh` now requires `mcp/mcp-server-config.json` (template integrity); invalid JSON emits a **WARN** only.
- `ensure-context.sh` seeds `assets/**/README.md` from `context/_seeds/assets/` without overwriting human edits.

**Files touched:**

- `_Template_Fiction_System/` — MCP bundle, `ensure-context.sh`, `health-check.sh`, seeds, `.gitignore`, `MCP_GUIDANCE.md`, `README.md`, `skills/README.md`, `context/README.md`, `workflows/context-refresh.md`, `CHANGELOG.md`, `BOOK_MANIFEST.yaml`, indices, `SELF_HEALING_AND_ADAPTATION.md`, `characters/templates/deep-psyche-profile.md`, `assets/audio/README.md`.
- `_Meta_Fiction_System/` — `DRIFT_AND_SYNC.md` §6, `OPEN_QUESTIONS.md`, `CONTEXT_AUTOMATION.md`, `MCP_AND_TOOLS.md`, `SESSION_LOG.md` (this file), version bumps on index/workflow docs.
- `../install-mylit-book.sh` — `assets/audio/` in self-heal mkdir list.

**Next session prompt suggestion:**

- If authors need **git** in template: consider a separate “opt-in” doc; do not mandate VCS for zero-friction humans.

---
