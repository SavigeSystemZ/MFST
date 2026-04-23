# Meta charter — maintaining the book-builder template

## Mission

Keep `_Template_Fiction_System/` the **best practical scaffold** for long-form fiction (single novels through series and compendia) worked on by AI agents **under human direction**, with strong canon discipline, traceability, and safe defaults.

## Principles

1. **Separation of concerns** — Meta defines *how to build the machine*; each **book project folder** defines *what the story is*.
2. **Copy, don’t mutate** — Books are copies of the template; the template is maintained centrally.
3. **Human authority** — The human owns copyright, content policy, and publication decisions. Agents assist; they do not override.
4. **Lawful use** — Template text must not instruct evasion of law, harassment, or non-consensual harm. Mature fiction is acceptable when **declared in the book’s** `CONTENT_POLICY.md` and consistent with host/platform rules the human chooses.
5. **No template lock-in** — Prefer plain Markdown, YAML, and shell; avoid proprietary-only formats.
6. **Discoverability** — A new agent must find the “read order” within minutes via `README.md` and `CONTEXT_INDEX.md`.

## Scope boundaries

| In scope (meta) | Out of scope (meta) |
|-----------------|----------------------|
| Folder layout, rules, prompts, workflows, scripts | Plot, characters, scenes, dialogue |
| Template versioning and migration notes | Marketing copy unless requested as boilerplate |
| Quality gates and checklists | Cover art assets |
| Generic craft guidance placeholders | Worldbuilding specifics for one series |

## Conflict resolution

If template rules conflict with a book’s needs, **the book folder wins locally** (fork prompts/rules in that copy). Meta then decides whether to **generalize** a pattern back into the template.

## Success criteria

- A new book scaffolded in **one command** is usable without editing meta files.
- Template changes are **documented**, **versioned**, and **reversible** (backups; git optional if you adopt it).
- Agents can run a **continuity / structure pass** using only files in the book project folder.

## Filesystem (MyLit default)

- Prefer file ownership by the human’s primary account (**`whyte`**). Agents should avoid creating manuscript or template files as `root` without follow-up `chown` (see workspace `PERMISSIONS_AND_OWNERSHIP.md`).

---

*Charter version: 1.2.0*
