# THE ULTIMATE TEMPLATE SPECIFICATION (v2.0)

**Mandate:** The `_Template_Fiction_System` must adhere strictly to these architectural requirements. If it deviates, it is considered broken.

## 1. Zero-Lore Rule
The template must remain completely agnostic. It cannot contain character names, specific magic systems, or plot beats. It is the blank canvas for a masterpiece. Use `[BRACKETED_VARIABLES]` for all examples.

## 2. The Psychological Baseline
The template must include advanced psychological profiling structures. Flat characters are the death of fiction. The `characters/` folder must include templates that mandate Enneagrams, Trauma Wounds, and Micro-Expressions.

## 3. Anti-Slop Safeguards
The template must aggressively combat AI-generated generic prose.
- `.cursor/rules` must explicitly ban cliché words ("tapestry", "testament").
- `MASTER_SYSTEM_PROMPT.md` must mandate sensory anchoring and subtextual dialogue.

## 4. Multi-Modal Readiness
Fiction is no longer just text. The template must have directories (`assets/`, `assets/prompts/`) and agent instructions specifically tailored to generating high-fidelity prompts for Midjourney, DALL-E, and Suno (for audio).

## 5. Continuity Failsafes
The template must include a "Red Team" system. A specialized prompt or agent mandate whose sole job is to destroy the draft by finding plot holes, timeline errors, and canon contradictions.

## 6. MCP Integration
The template must include `mcp-server-config.json` scaffolding to allow advanced IDEs (Cursor/Windsurf) to mount filesystem memory graphs and web-search capabilities directly into the AI's context.