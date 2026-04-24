# Optional monorepo migration (meta + template in one git remote)

Today many MyLit installs keep **`_Meta_Fiction_System/`** and **`_Template_Fiction_System/`** as **siblings** on disk. GitHub Actions in this meta repository can only execute template smoke tests when the template directory **exists inside the same checkout**.

## Why migrate

- CI runs **`tests/smoke-scaffold.sh`** on every push.
- Single PR can update governance + template with one atomic review.

## Minimal layout inside one remote

```
repo-root/
  _Meta_Fiction_System/     # contents of current meta repo (or keep flat root — see below)
  _Template_Fiction_System/ # full template tree
  .github/workflows/ci.yml  # lives under meta today; move or symlink per your layout
```

**Flat alternative:** merge meta files to repo root and move `workflows/` paths — higher churn; prefer nested folders.

## Steps (human-driven)

1. Create a new empty repository or branch dedicated to the monorepo.
2. Copy or `git subtree add` both trees preserving paths above.
3. Move `.github/workflows/ci.yml` to the **monorepo root** `.github/workflows/` and adjust paths in `ci-verify.sh` / `ci-template-if-present.sh` if you flatten meta.
4. Run `./_Meta_Fiction_System/scripts/ci-full-workspace.sh` locally until green.
5. Update remotes; archive old meta-only repo if desired.

This document is **non-normative**; sibling layout remains fully supported.

---

*Monorepo migration doc version: 1.0.0*
