# CONTEXT AUTOMATION — META SYSTEM

This document outlines the automation rules for ensuring every book project remains grounded in its established canon while providing AI agents with fresh, actionable data.

## 1. The Core Automation Hook
Every book project must run `./scripts/ensure-context.sh` at the start of every session. This script is responsible for:
- Seeding the `context/book/` directory with necessary summaries.
- Validating the presence of `HANDOFF_BRIEF.md`.
- Updating the `context/.last-context-refresh` timestamp.

## 2. Dynamic Summary Refresh
For large series, the context should be automatically summarized every 5-10 chapters to prevent context-window overflow.
- **Rule:** When the `manuscript/chapters/` count exceeds 10, the "Auditor" agent (DeepSeek) must trigger a `canon/timeline.md` and `canon/SERIES_BIBLE.md` synchronization pass.

## 3. Automated Context Indexing
The `CONTEXT_INDEX.md` in the template serves as the routing table. Any new file type added to the system (e.g., `assets/audio/`) must be added to the Index so that agents know how to ingest it.

## 4. MCP-Driven Memory Graphing
For advanced users (Cursor/Windsurf), context automation is handled by the `mcp/mcp-server-config.json`. This automates the ingestion of the filesystem into a searchable memory graph.

---
*Meta Context Automation v2.1*