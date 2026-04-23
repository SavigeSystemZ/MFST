# META QUALITY GATES — THE PERFECTION PROTOCOL

Before any update, script, or prompt change is finalized in `_Template_Fiction_System` and its version is bumped in `BOOK_MANIFEST.yaml`, the Supreme Meta-Architect must clear these extreme Quality Gates.

## Gate 1: The "Anti-Slop" Guarantee
- **Check:** Does the new prompt or rule inadvertently encourage the LLM to use flowery, generic, or passive language?
- **Test:** If the prompt generates the word "tapestry" or "testament," it fails. Rewrite the negative constraints.

## Gate 2: The Agent Compatibility Check
- **Check:** Is the new workflow agnostic? 
- **Test:** Does this workflow function equally well if executed by Claude 3 Opus (via web), Gemini 1.5 Pro (via API), or Cursor (via IDE)? If it relies on a specific UI feature, it fails. Rewrite it to rely on the filesystem (`HANDOFF_BRIEF.md`).

## Gate 3: The Multi-Modal Capability Test
- **Check:** Does the template support non-text asset generation?
- **Test:** Can an agent cleanly generate an image prompt and store it in `assets/prompts/` without confusing the prompt with the manuscript prose?

## Gate 4: The Lore Contamination Audit
- **Check:** Is the template truly generic?
- **Test:** Grep the entire `_Template_Fiction_System` for any specific character names, world locations, or magic systems (e.g., "Rook", "Savige", "Mana"). If any exist outside of `[BRACKETED_PLACEHOLDERS]`, the template is contaminated. Scrub it immediately.

## Gate 5: The "Idiot-Proof" Human Experience
- **Check:** Can a human novelist with zero coding experience use this?
- **Test:** Are the bash scripts (`ensure-context.sh`, `scaffold-from-template.sh`) thoroughly commented? Do they warn the user before running destructive actions? Are permissions handled gracefully (avoiding `root` locks)?

If ALL gates are passed, proceed to update the Meta `CHANGELOG.md` and bump the version.