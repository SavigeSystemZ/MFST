# DRIFT & SYNC PROTOCOL (v2.0)

When the `_Template_Fiction_System` is upgraded (e.g., from v1.5 to v2.0), existing book projects will experience "system drift." This protocol governs the synchronization process.

## 1. Semantic Versioning
- **Major (X.0.0):** Breaking structural change (e.g., a folder was renamed). Requires a manual migration script.
- **Minor (0.X.0):** New feature or prompt enhancement. Recommended update.
- **Patch (0.0.X):** Typo fix or small clarification. Optional update.

## 2. Synchronization Workflow
1. **Compare Manifests:** Check `template_version` in the book's `BOOK_MANIFEST.yaml` against the master template.
2. **Selective Merge:** Use `rsync` or the `install-mylit-book.sh` installer to copy NEW files (prompts, workflows, rules) into the book directory without overwriting the book's specific `canon/`, `characters/`, or `manuscript/` data.
3. **Manual Overwrite (High Risk):** Only overwrite `MASTER_SYSTEM_PROMPT.md` if the book project has not yet been significantly customized.

## 3. Migration Scripts
For Major version jumps, the Meta-Architect will provide a `migration_vX_to_vY.sh` in the `_Meta_Fiction_System/` to automate the transition.

## 4. Template v1.5.0 → v1.6.0 (assets scaffold)

**Added:** `assets/README.md`, `assets/prompts/README.md` (multi-modal prompts per `TEMPLATE_SPEC.md` §4).

**Existing book directories** (still on 1.5.x in `BOOK_MANIFEST.yaml`):

1. From the parent of `_Template_Fiction_System` (e.g. `Fiction/`), copy only the new tree:
   - `rsync -a --ignore-existing _Template_Fiction_System/assets/ YOUR_BOOK/assets/`
2. Run `./scripts/health-check.sh` inside the book root.
3. Bump `template_version` in that book’s `BOOK_MANIFEST.yaml` to `1.6.0` when satisfied.

## 5. Template v1.6.0 → v1.6.1 (lore-safe rule + psychology rows)

**Changed:** `.cursor/rules/book-writing-core.mdc` (no hard-coded author names), `characters/template-character.md` (Enneagram / trauma / micro-expressions), `AGENTS.md` (assets + red-team + audio note), `install-mylit-book.sh` self-heal directories.

**Existing books:** merge or copy those files from `_Template_Fiction_System/`; re-run `./scripts/health-check.sh`; set `template_version` to `1.6.1` when satisfied.

---
*Meta Drift & Sync Protocol v2.0*