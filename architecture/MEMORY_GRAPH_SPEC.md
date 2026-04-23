# MEMORY GRAPH ARCHITECTURE & MCP SPECIFICATION

When constructing a sprawling, 10-book epic, linear text files eventually break an LLM's context window. The Ultimate Fiction System relies on **Model Context Protocol (MCP)** to build a dynamic Knowledge Graph.

## 1. The Node Structure (The Entities)
Every element in the story is a node. 
- **Characters:** `Node Type: Character` (Attributes: Trait, Motivation, Current Location)
- **Locations:** `Node Type: Setting` (Attributes: Faction Control, Danger Level, Sensory Anchor)
- **Lore Objects:** `Node Type: Artifact/Magic` (Attributes: Rules, Owners, Danger)

## 2. The Edge Structure (The Relationships)
Nodes are connected by relational edges that track the *current state* of the story.
- `[Character: Protagonist]` --HAS_SECRET_AGENDA_AGAINST--> `[Character: Mentor]`
- `[Faction: Empire]` --CURRENTLY_OCCUPYING--> `[Location: The Slums]`

## 3. MCP Integration Strategy
- **File System Server:** Mount the `canon/` and `characters/` directories via the MCP Filesystem server. This allows the logic agent (DeepSeek/Grok) to read ONLY the specific node files requested, saving context.
- **Memory Server:** Utilize `@modelcontextprotocol/server-memory`. When a major event happens in the manuscript, the agent must execute an MCP tool call to update the graph.
  - *Example:* If the Protagonist discovers the Mentor's betrayal, the agent calls `update_memory_graph(subject="Protagonist", relation="KNOWS_BETRAYAL", object="Mentor")`.

## 4. Querying the Graph
Before writing a scene, the Prose Agent (Claude) will query the graph:
`get_graph_state(entities=["Protagonist", "Mentor"])`
This instantly returns the precise, up-to-the-minute emotional dynamic between the characters without requiring the agent to read 50 pages of previous chapters.

*This architecture guarantees zero continuity drift across millions of words.*