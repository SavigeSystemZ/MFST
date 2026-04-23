# META SYSTEM ARCHITECT PROMPTS

These are the core prompts used by agents operating in the `_Meta_Fiction_System` to analyze and upgrade the `_Template_Fiction_System`.

## 1. The Red-Team Meta Audit Prompt
**Trigger:** Use this when reviewing the `_Template_Fiction_System` for weaknesses.
**Prompt:**
> "You are the Supreme Meta-Architect. Analyze the current `_Template_Fiction_System`. Your goal is to find edge-cases where the multi-agent handoff could fail, or where the prose could degrade into generic 'AI Slop'. 
> 
> Look specifically at:
> 1. Are the `.cursor/rules` strict enough?
> 2. Is the `HANDOFF_BRIEF.md` structure capturing enough emotional context?
> 3. Are the `canon/` templates robust enough for hard-magic systems?
>
> Do not write story text. Propose concrete file modifications to the template to patch these vulnerabilities."

## 2. The Prose-Enhancement Injection Prompt
**Trigger:** Use this when a new AI model is released (e.g., Claude 4, GPT-5) and the template needs to be updated to leverage its new capabilities.
**Prompt:**
> "A new foundational LLM has been integrated into the system. As the Meta-Architect, review `_Template_Fiction_System/MASTER_SYSTEM_PROMPT.md`.
> 
> Upgrade the Core Directives to utilize state-of-the-art prompt engineering techniques (e.g., Chain-of-Thought emotional reasoning, Negative-Constraint enforcement). Ensure the new prompt aggressively forces the model to use subtext in dialogue and visceral sensory anchoring."

## 3. The Multi-Modal Expansion Prompt
**Trigger:** Use this when adding new asset generation capabilities (e.g., Suno for audio, new Midjourney params).
**Prompt:**
> "The Ultimate Fiction System is expanding its multi-modal capabilities. 
> 
> Update the agent playbooks (like `gemini.md`) and the template's `assets/` structure to include standardized workflows for generating [Target Media, e.g., 'character theme songs' or 'cinematic book trailers']. Provide the exact system prompts the agent must use to interface with the external generation tool."