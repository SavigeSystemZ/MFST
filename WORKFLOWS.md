# Meta workflows — evolving the template

## A. Routine improvement (most common)

1. Open `TEMPLATE_SPEC.md` — confirm the idea fits the contract.
2. Implement changes under `../_Template_Fiction_System/`.
3. Update `../_Template_Fiction_System/CHANGELOG.md` with **Added / Changed / Fixed / Migration**.
4. Bump `template_version` in the template’s `BOOK_MANIFEST.yaml` (semver):
   - **PATCH**: typos, clarifications, non-breaking additions.
   - **MINOR**: new optional files, new prompts, backward-compatible rules.
   - **MAJOR**: moved paths, renamed mandatory files, incompatible rule behavior.
5. If **MAJOR** or **MINOR** affects existing books, append a dated section to `DRIFT_AND_SYNC.md`.

## B. New mandatory file or directory

1. Add the file/dir to the template with a **README** inside opaque folders.
2. Add a row to `TEMPLATE_SPEC.md` §1 or §2.
3. Add a **health-check** hint in template `SELF_HEALING_AND_ADAPTATION.md`.
4. MINOR or MAJOR bump per blast radius.

## B2. New optional workflow (Markdown under `workflows/`)

1. Add the file under `_Template_Fiction_System/workflows/` (keep book-agnostic; no lore).
2. Register it in the template’s `WORKFLOWS.md` table and a row in template `CONTEXT_INDEX.md` when authors should discover it.
3. **PATCH** bump if purely additive guidance; **MINOR** if it changes recommended defaults for all titles.
4. If existing books benefit from a one-file merge, add a short subsection to `DRIFT_AND_SYNC.md`.

## C. New per-tool agent playbook

1. Add `agents/<id>.md` under `_Template_Fiction_System/agents/` (copy from `generic-assistant.md` if needed).
2. Register the row in `agents/README.md`.
3. MINOR bump; see `MULTI_AGENT_MAINTENANCE.md`.

## D. New Cursor rule

1. Place `.mdc` in `_Template_Fiction_System/.cursor/rules/`.
2. Keep `description` crisp; use `globs` when the rule is file-specific (e.g. `manuscript/chapters/**`).
3. Avoid `alwaysApply: true` unless the rule is short and universal.
4. Cross-link from template `CONTEXT_INDEX.md` if agents should know about it.

## E. Review checklist before “release”

Execute `QUALITY_GATES.md` in full (includes **Gate 6** — run `./scripts/ci-verify.sh` in meta; `./scripts/ci-full-workspace.sh` from the Fiction parent when the template tree is present).
Also run **Gate 7** fiction-domain checks via `ci-full-template.sh` (which now executes `scripts/book-writing-quality-check.sh`).
For heavy resilience checks, run `./scripts/run-soak-books.sh --count 100 --parallel 8 --prune-existing --cleanup` from the Fiction parent.

## F. Propagation to existing books

Meta does **not** auto-merge into `[BOOK_DIR]/` or other titles. Instead:

1. Write explicit steps in `DRIFT_AND_SYNC.md` (“copy file X”, “merge section Y”).
2. Optionally provide a **patch-style** snippet the human can apply.

## Version tags (optional git)

If this tree is versioned with git, tag template releases: `template-vX.Y.Z`.

---

*Workflows doc version: 1.8.3*
