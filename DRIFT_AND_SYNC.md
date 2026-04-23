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

---
*Meta Drift & Sync Protocol v2.0*