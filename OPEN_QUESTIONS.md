# OPEN ARCHITECTURAL QUESTIONS

This document tracks unresolved or experimental features for the Ultimate AI Fiction System. **Interim resolutions** document what authors can do *today* without waiting for a final architecture.

## 1. Integrated Audio Generation

- **Question:** How do we integrate Suno or ElevenLabs prompts directly into the `assets/audio/` workflow?
- **Status:** Long-term “vendor session” patterns still TBD.
- **Interim resolution (2026-04-23):** Store **prompt text** (style, tempo, VO casting, lyrics constraints) under `assets/prompts/` with an `## Audio` section or dedicated `*.md` files. Use optional `assets/audio/` for **small exports** or **pointer files** to large binaries; see `_Template_Fiction_System/assets/audio/README.md` and `CONTENT_POLICY.md` for rights and safety.

## 2. Multi-Author Collaboration

- **Question:** How does the system handle two human authors working on the same book folder?
- **Status:** Exploring git-based conflict resolution vs. the current filesystem-as-truth model.
- **Interim resolution:** Treat the book directory as a **single working tree**. Prefer **git** (or Darcs/Pijul) with branch-per-writer or explicit file ownership zones; require **human merge** for `canon/` and `HANDOFF_PROTOCOL.md` conflicts. Log intent in `context/HANDOFF_BRIEF.md` and `context/book/decisions-pending.md` so agents do not “resolve” authorship disputes.

## 3. Mobile/Tablet Interoperability

- **Question:** Can this system be used by a human writing on an iPad?
- **Status:** Investigating web-based MCP bridges to allow mobile browsers to interface with the local filesystem.
- **Interim resolution:** Use **Working Copy** + SSH, **Syncthing**, or cloud sync pointed at the book folder **plus** a desktop agent session for heavy MCP. MCP remains **optional**; Markdown + `ensure-context.sh` on the synced device is enough for drafting if structure is preserved.

---

*Meta Open Questions v2.2*
