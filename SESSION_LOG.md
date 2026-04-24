# Meta system — session log

Append **structural** decisions only; book prose belongs in book folders.

---

## 2026-04-24 — Domain-first quality push (template **1.8.1**)

**Goal:** Ensure “100-quality” means **book-writing system rigor**, not generic app-dev checkboxes.

**Ship:** `_Template_Fiction_System/scripts/book-writing-quality-check.sh` (anti-slop rails, handoff sections, red-team prompt presence, lore contamination scan) and integration into `scripts/ci-full-template.sh`; `QUALITY_GATES.md` Gate 7.

**Stress follow-up:** discovered mixed-ownership edge case during local stress books; hardened lore scan to fail on unreadable files and documented drift path to **1.8.2**.

---

## 2026-04-24 — CI, scaffold smoke, MyLit fence (template **1.8.0**)

**Goals:** Close engineering gap vs “world-class” bar: automated governance checks, optional monorepo path for full template CI, explicit fencing of speculative MFST scaffolding text.

**Ship:** `.github/workflows/ci.yml`; `scripts/ci-verify.sh`, `ci-template-if-present.sh`, `ci-full-template.sh`, `ci-full-workspace.sh`; `CI_AND_RELEASE.md`, `MONOREPO_MIGRATION.md`; `QUALITY_GATES.md` Gate 6; template `tests/smoke-scaffold.sh`; `SYSTEM_INTEGRATION.md` §4; `02_TEMPLATE_BOUNDARIES…` MyLit implementation blockquote at Part 2.

**Note:** A literal **101/100** score is marketing, not engineering — these changes target **measurable** quality (CI + smoke + contracts).

---

## 2026-04-24 — Soak harness automation

**Goal:** make stress testing repeatable and cheap, not a manual one-off.

**Ship:** `scripts/run-soak-books.sh` (parameterized count/mutate/prefix/cleanup, report JSON+Markdown, deterministic mutation set) plus Gate 8 in `QUALITY_GATES.md`.

**Enhancement:** added parallel workers (`--parallel`), collision handling (`--prune-existing`), and latency percentile reporting (p50/p90/p99) in report JSON/Markdown.

---

## 2026-04-23 — Template v1.7.2 prompts index + meta README discovery

**Goals:** Close discoverability gap (`prompts/advanced_passes/` existed but was not indexed); align scattered `*version*` footers; surface `OPEN_QUESTIONS`, `CONTEXT_AUTOMATION`, and `INTEGRATING_EXISTING_BOOKS.md` on meta `README.md`.

**Ship:** Template `1.7.2`; `DRIFT_AND_SYNC.md` §8; `META_CHARTER.md` routing note (**1.3.0**).

---

## 2026-04-23 — Template v1.7.1 optional Git playbook

**Goals:** Ship non-mandatory Git guidance (SESSION_LOG “next session” item) without requiring VCS for novelists.

**Decisions:** New `workflows/version-control-optional-git.md`; wired into template `WORKFLOWS.md`, `README.md`, `CONTEXT_INDEX.md`; Cursor `CONTEXT_LOAD_ORDER.md` adds MCP sanity line; meta `DRIFT_AND_SYNC.md` §7; `MULTI_AGENT_MAINTENANCE.md` §4 for meta `SESSION_LOG.md` cadence; `INTEGRATING_EXISTING_BOOKS.md` lists `mcp/` + `_seeds/assets/`.

**Next:** None queued — resume book work or template hardening per human priority.

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

**Resolved (see v1.7.1 log entry):** optional Git workflow doc added; no mandate on VCS.

---
