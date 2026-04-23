# SYSTEM ORCHESTRATION ARCHITECTURE

The Ultimate Fiction System is not a static folder; it is a dynamic state machine where different AI models (Agents) pass the context baton. 

## The Multi-Agent Swarm

The system is designed to use **Specialized Agents** rather than relying on a single Omni-Model.

### 1. The Creator (Claude 3 Opus / Sonnet)
- **Role:** Prose generation, emotional depth, psychological character writing.
- **Workflow:** Reads `canon/` -> Reads `outline/` -> Drafts chapter in `manuscript/drafts/`.

### 2. The Director (Google Gemini Pro / Flash)
- **Role:** Action sequencing, pacing, and multi-modal asset generation (Midjourney prompts).
- **Workflow:** Reviews drafts -> Injects cinematic action beats -> Generates `/assets/prompts/` for the chapter's key visual moments.

### 3. The Auditor (DeepSeek / Grok)
- **Role:** Continuity red-teaming, timeline math, and structural formatting.
- **Workflow:** Runs the `red-team-continuity.md` pass on the draft -> Flags errors -> If clean, promotes from `drafts/` to `chapters/`.

### 4. The Scaffolder (Agent Zero / Windsurf / Cursor)
- **Role:** Codebase execution, MCP server integration, bash scripting.
- **Workflow:** Runs `ensure-context.sh`, updates YAML manifests, manages file permissions, and fetches real-world physics/history data via Web MCP.

## The Context Baton (`HANDOFF_BRIEF.md`)

Because AI context windows are finite, agents communicate through `context/HANDOFF_BRIEF.md`.
When an agent finishes its turn, it MUST write:
1. **State:** "Chapter 4 is 50% done. The characters are currently in the tavern."
2. **Emotion:** "The POV character is currently suppressing a panic attack."
3. **Blockers:** "I stopped because I don't know the name of the tavern owner. DeepSeek, please generate this in the canon."
4. **Next Steps:** "Claude, pick up from line 45 and finish the dialogue."

This architecture ensures infinite scale without context degradation.