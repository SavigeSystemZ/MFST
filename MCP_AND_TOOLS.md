# MCP and tools — meta guidance

## Philosophy

MCP servers are **optional accelerators**. The template must remain **fully usable** with Markdown + shell scripts + Cursor rules only.

## Bundled book template config

The runnable scaffold ships **`../_Template_Fiction_System/mcp/mcp-server-config.json`** with:

- **Scoped filesystem** — `canon`, `manuscript`, `characters`, `context`, `assets`, `prompts`, `workflows` (cwd = book root).
- **Fetch** — public URL → markdown for research (still: summarize, cite, respect copyright).
- **Brave search** — optional; requires `BRAVE_API_KEY` in the user’s environment or local MCP override (do not commit keys).
- **Memory** — graph-style recall; must be reconciled to `canon/` periodically.

Authors should read **`../_Template_Fiction_System/MCP_GUIDANCE.md`** before enabling any server.

## When to document an MCP in the template

Add or adjust guidance in `_Template_Fiction_System/MCP_GUIDANCE.md` when:

- A tool is **stable**, **repeatable**, and **licensing-clear** for the author’s workflow.
- The MCP replaces a fragile manual loop (e.g., large research synthesis with citations).

## What meta should not do

- Commit API keys or tokens.
- Hard-require a commercial MCP for core workflows.

## Suggested categories (book projects)

- **Research**: web fetch, library APIs (respect copyright; summarize, don’t paste long excerpts).
- **Organization**: task trackers, calendars (production schedules).
- **Asset**: image/audio prompt storage remains **in-repo text** under `assets/prompts/`; binaries optional per `assets/audio/README.md`.

## Audit

When adding MCP docs, include **data handling** notes: what leaves the machine, what is stored in-repo, and what must stay **out of git** (see template `.gitignore`).

---

*MCP meta doc version: 1.8.0*
