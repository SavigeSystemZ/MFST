# CI and release — meta + template

## What runs on GitHub Actions

Workflow: `.github/workflows/ci.yml`

1. **`scripts/ci-verify.sh`** — always: required meta Markdown files exist; `bash -n` (+ `shellcheck` if installed) on `scripts/*.sh`.
2. **`scripts/ci-template-if-present.sh`** — if the repository root contains `_Template_Fiction_System/` (**monorepo** layout), runs **`scripts/ci-full-template.sh`**, which:
   - `bash -n` + `shellcheck` on template `scripts/*.sh`
   - Validates `mcp/mcp-server-config.json` structure (`mcpServers`, `command`, `args`)
   - `./scripts/health-check.sh` inside the template tree
   - `./scripts/book-writing-quality-check.sh` (fiction-domain contract checks)
   - `_Template_Fiction_System/tests/smoke-scaffold.sh` (creates and deletes a disposable book folder next to the template)

If your remote is **meta-only** (template lives as a sibling directory on disk but not in git), CI still passes governance checks; run the full suite **locally** (below).

## Full verification on your machine (MyLit `Fiction/` layout)

From the directory that contains **both** `_Meta_Fiction_System/` and `_Template_Fiction_System/`:

```bash
chmod +x _Meta_Fiction_System/scripts/*.sh _Template_Fiction_System/tests/smoke-scaffold.sh
./_Meta_Fiction_System/scripts/ci-full-workspace.sh
```

## Soak harness (book-writing stress)

For repeatable large-batch stress tests (scaffold + validate + merge-restore):

```bash
./_Meta_Fiction_System/scripts/run-soak-books.sh --count 100 --parallel 8 --prune-existing --cleanup
```

Artifacts are written under a timestamped `_StressSoak_*` directory with:
- `REPORT.md`
- `results.json`
- `mutated_books.txt`
- `timings/` per-book stage timings used for p50/p90/p99 latency summaries

## Optional: monorepo migration for “always-on” template CI

See **`MONOREPO_MIGRATION.md`** if you want GitHub to execute scaffold smoke on every push.

## Release tagging (optional)

If this repository uses git tags for template drops: `template-vX.Y.Z` on commits that bump `_Template_Fiction_System/BOOK_MANIFEST.yaml`.

---

*CI and release doc version: 1.3.0*
