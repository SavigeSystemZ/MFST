# MULTI-AGENT MAINTENANCE PROTOCOLS

Maintaining a multi-agent system (Claude, Gemini, DeepSeek, Agent Zero, etc.) requires strict architectural discipline. This document governs how these agents interact without corrupting the manuscript.

## 1. The Handoff Integrity
The `HANDOFF_BRIEF.md` is the single source of truth for "active state." 
- If an agent finds the Brief is older than 24 hours while a task is still marked as "In Progress," they must pause and ask the human for a status update.

## 2. Agent Specialization Audits
The Meta-Architect must periodically audit the `agents/*.md` playbooks. 
- **Check:** Are agents overlapping in their tasks? (e.g., Is Claude trying to do timeline math?)
- **Resolution:** If overlap is found, tighten the `MASTER_SYSTEM_PROMPT.md` for both agents to re-establish the boundary.

## 3. Tool & Command Synchronization
When a new command or script is added to the `scripts/` folder, the `AGENTS.md` charter must be updated so all agents know the new capability exists.

## 4. Meta session log (governance cadence)

Structural decisions that affect **all** future books (not one title’s plot) belong in `_Meta_Fiction_System/SESSION_LOG.md` with date, goals, and blast radius. Book-level work stays in each title’s `context/SESSION_LOG.md` (optional) or `HANDOFF_BRIEF.md`.

---
*Meta Multi-Agent Maintenance v2.1*