# 00_SYSTEM_OVERVIEW.md
## The Meta Fiction System Template — Complete System Architecture

**Version**: 1.0.0-alpha  
**Last Updated**: 2026-04-23  
**Status**: Foundational Architecture  
**Audience**: AI Agents + Human Architects

---

## Executive Summary

The **Meta Fiction System Template (MFST)** is an agentic, self-healing platform for orchestrating multi-agent collaboration to produce **world-class multi-series fiction**.

It is **not** a book-writing tool. It is a **system builder**. Every project that uses MFST inherits a sophisticated, proven framework for managing:
- Canon and continuity across multiple volumes
- Character psychology and multi-book arcs
- Plot escalation and series structure
- Agent coordination and quality control
- Self-correction and error recovery

**Core Principles:**
1. **Template Isolation** — MFST itself is never modified during project execution
2. **Agentic** — Multi-agent workflows with formal contracts and error recovery
3. **Self-Healing** — Detects and corrects errors automatically
4. **Scalable** — Can produce 50+ multi-series novels with consistent quality
5. **Measurable** — All success criteria are explicit and trackable

---

## System Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     MFST MASTER CONTROL LAYER                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  SHOWRUNNER (Executive Producer)                                           │
│  ├─ Project bootstrap and intake                                           │
│  ├─ Phase coordination                                                      │
│  ├─ Quality gate decisions                                                 │
│  └─ Error escalation                                                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↓
                         ┌──────────────────────┐
                         │  PROJECT STATE       │
                         ├──────────────────────┤
                         │ • PROJECT_BRIEF.md   │
                         │ • SERIES_BIBLE.md    │
                         │ • CANON_LEDGER.md    │
                         │ • CHARACTER_REGISTRY │
                         │ • TIMELINE.md        │
                         │ • Drafts & Edits     │
                         └──────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                      PIPELINE PHASE ORCHESTRATION                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Phase 0: PROJECT INTAKE        → Architect      → PROJECT_BRIEF           │
│  Phase 1: SERIES ARCHITECTURE   → Architect      → SERIES_BIBLE            │
│  Phase 2: WORLD & CANON         → Canon Keeper   → WORLD_BIBLE             │
│  Phase 3: CHARACTER DEVELOPMENT → Psychologist   → CHARACTER_REGISTRY      │
│  Phase 4: PLOT ARCHITECTURE     → Plot Engineer  → PLOT_MAP                │
│  Phase 5: SCENE DRAFTING        → Scene Drafter  → Draft Manuscript        │
│  Phase 6: PROSE POLISH          → Prose Team     → Final Manuscript        │
│  Phase 7: QUALITY AUDIT         → Continuity Ed. → Release Checklist       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SUPPORTING AGENT NETWORK                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Continuity Team:                                                          │
│  ├─ Continuity Editor     (finds contradictions)                           │
│  ├─ Contradiction Hunter  (systematic detection)                           │
│  └─ Canon Reconciliation  (resolves retcons)                               │
│                                                                             │
│  Quality Assurance Team:                                                   │
│  ├─ Line Editor           (grammar, flow, style)                           │
│  ├─ Developmental Editor  (structure, pacing, impact)                      │
│  ├─ Prose Stylist         (voice consistency)                              │
│  └─ Reader Impact Analyst (emotional resonance)                            │
│                                                                             │
│  Research & Context Team:                                                  │
│  ├─ Research Librarian    (fact-checking, sources)                         │
│  ├─ Lore Master           (thematic consistency)                           │
│  └─ Series Bible Curator  (long-arc tracking)                              │
│                                                                             │
│  Meta-System Team:                                                         │
│  └─ Meta System Architect (MFST self-improvement)                          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                     QUALITY GATES & VALIDATION LAYER                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Phase Gate Validation:                                                    │
│  ├─ Acceptance criteria met                                                │
│  ├─ No blocking issues (red flags)                                         │
│  └─ Readiness for next phase                                               │
│                                                                             │
│  Continuous Audit:                                                         │
│  ├─ Contradiction detection (automatic)                                    │
│  ├─ Canon integrity checks                                                 │
│  ├─ Character consistency                                                  │
│  └─ Prose quality baseline                                                 │
│                                                                             │
│  Release Validation:                                                       │
│  ├─ Reader impact assessment                                               │
│  ├─ Sensitivity review                                                     │
│  ├─ Final continuity audit                                                 │
│  └─ Release checklist completion                                           │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↓
                    ┌────────────────────────────┐
                    │  PUBLISHED NOVEL / SERIES  │
                    │  (Ready for readers)       │
                    └────────────────────────────┘
```

---

## Agent Hierarchy

### Tier 1: Executive (1 agent)
- **Showrunner** — Overall project orchestration, phase sequencing, quality escalation

### Tier 2: Architecture (5 agents)
- **Architect** — Series/trilogy structure, macro arcs
- **Canon Keeper** — World bible, historical consistency
- **Character Psychologist** — Multi-book character growth
- **Plot Engineer** — Narrative architecture, escalation
- **Scene Drafter** — Individual scene design and pacing

### Tier 3: Prose & Polish (3 agents)
- **Prose Stylist** — Voice consistency, prose quality
- **Line Editor** — Grammar, flow, word choice
- **Developmental Editor** — Big-picture feedback, pacing

### Tier 4: Quality Assurance (4 agents)
- **Continuity Editor** — Identifies contradictions in context
- **Contradiction Hunter** — Systematic logical inconsistency detection
- **Lore Master** — Thematic coherence, resonance
- **Sensitivity & Reader Impact** — Emotional resonance, potential harms

### Tier 5: Support (3 agents)
- **Research Librarian** — Fact-checking, source integration
- **Series Bible Curator** — Long-arc tracking, series coherence
- **Meta System Architect** — MFST improvement and evolution

---

## Data Flow Architecture

### INPUT VECTORS

**Project Initialization:**
```
User Brief
  ↓
Showrunner Input Queue
  ↓
Phase 0: Intake Processing
  ├─ Genre + Audience Analysis
  ├─ Comparable Works Assessment
  ├─ Creative North Star Definition
  └─ Success Criteria Establishment
```

**Per-Phase Processing:**
```
Previous Phase Outputs
  ↓
Quality Gate Validation
  ├─ Acceptance Criteria Check
  ├─ Blocking Issues Resolution
  └─ Phase Readiness Assessment
  ↓
Current Phase Agent Dispatch
  ├─ Agent-Specific Context Injection
  ├─ IO Contract Enforcement
  └─ Work Unit Assignment
```

### PROCESSING PIPELINE

**Standard Phase Flow:**
```
1. Context Packing
   ├─ Load project state (immutable references)
   ├─ Load phase-specific context
   ├─ Load agent-specific briefing
   └─ Inject safety rules & constraints

2. Agent Execution
   ├─ Primary agent performs work
   ├─ Continuous error monitoring
   ├─ Mid-work validation checkpoints
   └─ Auto-correction on detected issues

3. Delivery & Validation
   ├─ Output format validation (IO contract)
   ├─ Content quality baseline checks
   ├─ Canon consistency audit
   └─ Readiness assessment

4. Integration
   ├─ Merge into project state
   ├─ Update canon/continuity logs
   ├─ Record metadata + provenance
   └─ Trigger dependent agents (if async)
```

### OUTPUT VECTORS

**Deliverables (Per Phase):**
- Phase 0 → PROJECT_BRIEF.md
- Phase 1 → SERIES_BIBLE.md + SERIES_ARC.md
- Phase 2 → WORLD_BIBLE.md + CANON_LEDGER.md + TIMELINE.md
- Phase 3 → CHARACTER_REGISTRY.md + CHARACTER_ARCS.md
- Phase 4 → PLOT_ARCHITECTURE.md + CHAPTER_OUTLINE.md
- Phase 5 → Draft Manuscript (chapters + scenes)
- Phase 6 → Revised Manuscript (6 polish passes)
- Phase 7 → RELEASE_CHECKLIST.md + publishable artifact

**Quality Outputs (Continuous):**
- Continuity Audit Report
- Canon Change Log
- Character Consistency Report
- Prose Quality Metrics
- Reader Impact Assessment

---

## Key Mechanisms

### 1. CANON-FIRST PRINCIPLE
**Rule:** Canon is immutable. New writing never overwrites established facts.

**Implementation:**
- CANON_LEDGER is append-only (edits go to RETCONS section)
- All retcons require explicit approval + rationale
- Contradiction detection runs on every update
- Agents receive canon as read-only reference

**Example:**
```
❌ WRONG: Agent changes a character's birthplace without recording it
✅ RIGHT: Agent proposes new birthplace → retcon recorded with rationale
          → continuity editor approves → new timeline synced
```

### 2. MULTI-AGENT LOCKING
**Rule:** Prevent simultaneous writes to the same resource.

**Implementation:**
- Critical resources (CANON_LEDGER, CHARACTER_REGISTRY) require checkout
- Lock held for duration of modification
- Failed locks trigger escalation to Showrunner
- Timeout rules prevent deadlocks

### 3. ERROR RECOVERY
**Rule:** Agents detect and fix errors automatically; escalate only when necessary.

**Implementation:**
- Pre-work validation (context integrity, IO contract readiness)
- Mid-work checkpoints (story consistency, prose quality)
- Post-work validation (deliverable format, acceptance criteria)
- Error categories determine action:
  - **Auto-fix:** Typos, formatting, minor inconsistencies
  - **Re-attempt:** Incomplete work, context overflow
  - **Escalate:** Logical contradictions, creative disagreements, safety issues

### 4. CONTINUITY ENGINE
**Rule:** Detect and flag contradictions in real-time; resolve systematically.

**Implementation:**
- Contradiction Hunter: Systematic logical checks (character ages, timeline gaps, location descriptions)
- Continuity Editor: Contextual checks (does this scene fit the established tone?)
- Canon Reconciliation: Multi-book continuity (does this book honor prior series promises?)
- CONTRADICTIONS.md: Tracks known issues + planned resolutions

### 5. SELF-HEALING
**Rule:** The system detects drift and applies fixes autonomously.

**Implementation:**
- Drift Detection: Regular audits check template vs. project consistency
- Auto-Repair: Known drift patterns have established fixes (no human needed)
- Escalation: Unknown patterns + edge cases flagged for human review
- Learning: Each issue + resolution recorded for future reference

---

## Phase Architecture

### Phase 0: PROJECT INTAKE (5 days)
**Goal:** Define what the story is fundamentally about.

**Agent:** Architect (with Showrunner oversight)  
**Inputs:** User brief, genre expectations, comparable works  
**Outputs:** PROJECT_BRIEF.md

**Acceptance Criteria:**
- ✅ One-sentence story premise
- ✅ Target genre with subgenre specifics
- ✅ Target audience with demographic details
- ✅ 3-5 comparable works analyzed
- ✅ Creative north star (one-paragraph manifesto)
- ✅ Success criteria (what does "done" mean?)
- ✅ Constraints identified (budget, POV restrictions, content warnings)

### Phase 1: SERIES ARCHITECTURE (8 days)
**Goal:** Plan the multi-book structure and escalation.

**Agent:** Architect  
**Inputs:** PROJECT_BRIEF.md  
**Outputs:** SERIES_BIBLE.md, SERIES_ARC.md, BOOK_SEQUENCE.md

**Acceptance Criteria:**
- ✅ Book count + volume structure decided
- ✅ Book-specific promises and payoffs documented
- ✅ Series-level dramatic question identified
- ✅ Escalation rules defined (how stakes rise per book)
- ✅ Endgame mapped (how does the series conclude?)
- ✅ Long-arc mysteries + reveal schedule
- ✅ Power level progression rules

### Phase 2: WORLD & CANON (10 days)
**Goal:** Establish the immutable facts of the story world.

**Agent:** Canon Keeper  
**Inputs:** SERIES_BIBLE.md  
**Outputs:** WORLD_BIBLE.md, CANON_LEDGER.md, TIMELINE.md, LOCATION_REGISTRY.md

**Acceptance Criteria:**
- ✅ WORLD_BIBLE complete (magic, tech, history, rules)
- ✅ CANON_LEDGER initialized (v0 snapshot of world state)
- ✅ TIMELINE complete (chronological reference)
- ✅ CHARACTER_REGISTRY initialized (basic bio for every named character)
- ✅ LOCATION_REGISTRY complete (geography + descriptions)

### Phase 3: CHARACTER DEVELOPMENT (10 days)
**Goal:** Define character psychology and multi-book arcs.

**Agent:** Character Psychologist  
**Inputs:** SERIES_BIBLE.md, WORLD_BIBLE.md, CANON_LEDGER.md  
**Outputs:** CHARACTER_ARCS.md, CHARACTER_RELATIONSHIP_MATRIX.md

**Acceptance Criteria:**
- ✅ Protagonist(s) psychological profile complete
- ✅ Main antagonist(s) motivation + arc
- ✅ Supporting cast relationships mapped
- ✅ Multi-book character growth arcs
- ✅ Emotional crescendo moments identified per book
- ✅ Character-to-plot binding (how characters drive narrative)

### Phase 4: PLOT ARCHITECTURE (12 days)
**Goal:** Design the narrative structure and pacing.

**Agent:** Plot Engineer  
**Inputs:** CHARACTER_ARCS.md, SERIES_BIBLE.md  
**Outputs:** PLOT_ARCHITECTURE.md, CHAPTER_OUTLINE.md, SCENE_LIST.md

**Acceptance Criteria:**
- ✅ Per-book three-act structure
- ✅ Midpoint + climax for each book
- ✅ Setup/payoff across volumes
- ✅ Chapter count + breakdown
- ✅ Scene pacing rules (average scenes per chapter)
- ✅ Subplot integration

### Phase 5: SCENE DRAFTING (20 days)
**Goal:** Write the manuscript with full continuity tracking.

**Agent:** Scene Drafter (+ Continuity Editor overseeing)  
**Inputs:** All prior outputs  
**Outputs:** Draft manuscript, SCENE_CONTINUITY_CHECKS.md

**Acceptance Criteria:**
- ✅ All chapters drafted
- ✅ Scene continuity issues flagged (resolved or recorded)
- ✅ POV consistency maintained
- ✅ Pacing meets design targets
- ✅ Canon adhered to (no untracked retcons)

### Phase 6: PROSE POLISH (18 days)
**Goal:** Revise and refine the manuscript.

**Agent:** Prose Team (Stylist → Line Editor → Developmental Editor)  
**Inputs:** Draft manuscript  
**Outputs:** Revised manuscript (6 passes)

**Acceptance Criteria:**
- ✅ Pass 1: Macro (structure, pacing, arc completion)
- ✅ Pass 2: Scene (coherence, beat execution, transitions)
- ✅ Pass 3: Prose (rhythm, voice, style consistency)
- ✅ Pass 4: Line (grammar, word choice, flow)
- ✅ Pass 5: Copy (typos, formatting, consistency)
- ✅ Pass 6: Final read (emotional impact, gut check)

### Phase 7: QUALITY AUDIT & RELEASE (5 days)
**Goal:** Final validation before publication.

**Agent:** Continuity Editor (+ full audit team)  
**Inputs:** Final manuscript  
**Outputs:** RELEASE_CHECKLIST.md, publishable artifact

**Acceptance Criteria:**
- ✅ Continuity audit 100% pass
- ✅ Canon reconciliation complete
- ✅ Character consistency validated
- ✅ Reader impact assessment positive
- ✅ Sensitivity review cleared
- ✅ Release checklist signed off

---

## Feedback Loops

### Loop 1: REAL-TIME CORRECTION
```
Agent Execution
  ↓
Mid-Work Validation
  ├─ Passes → Continue
  └─ Fails → Auto-correct OR Re-attempt OR Escalate
```

### Loop 2: PHASE COMPLETION LOOP
```
Phase Deliverable Complete
  ↓
Quality Gate Assessment
  ├─ Passes → Proceed to next phase
  └─ Fails → Rework OR escalate to Showrunner
```

### Loop 3: CONTINUITY AUDIT LOOP
```
New content written
  ↓
Contradiction Detection (automatic)
  ├─ No contradictions → Continue
  ├─ Minor (auto-fixable) → Auto-fix + log
  └─ Major → Flag for Continuity Editor
```

### Loop 4: POST-PUBLICATION FEEDBACK LOOP
```
Manuscript Released
  ↓
Reader Feedback + Errata Collection
  ↓
Retcon Proposal (if needed)
  ├─ Minor corrections → RETCONS.md update
  └─ Major changes → New project iteration
```

---

## Safety & Guardrails

### Immutability Zones
- **Template itself:** Cannot be modified during project execution
- **Version markers:** `.fiction-template-version` (append-only)
- **Agent contracts:** IO format changes require version bump
- **Core rules:** 8 safety rules are non-negotiable

### Conflict Prevention
- **Multi-agent locking:** Critical resources checkout before modification
- **Role-based access:** Agents only receive context they need
- **Audit trail:** All changes logged with timestamp + agent ID + rationale
- **Rollback capability:** Every major change is revertible

### Error Boundaries
- **Cascading failure prevention:** If one agent fails, Showrunner notified before others proceed
- **Resource limits:** Context budget enforced per model + agent type
- **Timeout rules:** Long-running tasks auto-escalate after threshold
- **Human escape hatches:** Critical decisions require human confirmation

---

## Success Metrics

| Category | Metric | Target |
|----------|--------|--------|
| **System Quality** | All 20 core documents created | 100% |
| | All agent profiles complete | 100% |
| | Acceptance tests pass | 100% |
| **Project Execution** | Average project setup time | <2 hours |
| | Average chapter turnaround | <3 days (all 6 passes) |
| | Contradiction detection runtime | <10 min |
| **Quality Outcomes** | Agent error rate | <2% |
| | Continuity issues post-publication | 0 |
| | Reader satisfaction score | 8+/10 |
| **Operational** | Multi-agent coordination success | 99%+ |
| | Automated error recovery rate | >80% |

---

## System State Diagram

```
┌──────────────┐
│   TEMPLATE   │ ← MFST (never modified during project execution)
│  (Immutable) │
└──────┬───────┘
       │
       │ (scaffold on project creation)
       ↓
┌──────────────────────┐
│  PROJECT INSTANCE    │ ← Fresh copy of template
│  (Mutable)           │
├──────────────────────┤
│ • PROJECT_BRIEF.md   │
│ • SERIES_BIBLE.md    │
│ • CANON_LEDGER.md    │
│ • Characters         │
│ • Plot Design        │
│ • Draft MS           │
│ • Final MS           │
└──────────────────────┘
       │
       │ (phase gates + agent workflows)
       ↓
┌──────────────────────┐
│  QUALITY GATES       │
├──────────────────────┤
│ Phase 0: Intake      │
│ Phase 1: Series Arc  │
│ Phase 2: World/Canon │
│ Phase 3: Characters  │
│ Phase 4: Plot        │
│ Phase 5: Drafting    │
│ Phase 6: Polish      │
│ Phase 7: Release     │
└──────────────────────┘
       │
       ↓
┌──────────────────────┐
│ PUBLISHED NOVEL      │
│ (Ready for readers)  │
└──────────────────────┘
```

---

## Integration Points

### With Copilot CLI
- **Plan Mode:** Use Copilot's plan mode to scaffold Phase architecture
- **SQL Tracking:** All todos tracked in session database
- **Context Packing:** Copilot loads project context intelligently

### With MCP Servers
- **File Operations:** Read/write project files via MCP
- **Git Integration:** Version control for manuscripts + canon
- **External Tools:** Spell-check, grammar analysis, plagiarism detection

### With External Agents
- **Claude, Gemini, DeepSeek:** Each agent routed to optimal model
- **Model Selection:** Task-specific routing based on cost + quality
- **Context Packing:** Adaptive trimming based on model limits

---

## Conclusion

MFST is **not a writing tool**. It is a **system builder** that orchestrates multi-agent collaboration to produce exceptional multi-series fiction with mathematical precision, full auditability, and self-healing capabilities.

Every project that uses MFST inherits:
- ✅ A proven 7-phase pipeline
- ✅ A team of 16 specialized agents
- ✅ Explicit quality gates at every step
- ✅ Automatic error detection and recovery
- ✅ Full canon continuity protection
- ✅ Multi-book character arc management
- ✅ Series escalation engineering
- ✅ Comprehensive audit trails

**The system is ready. The agents are coordinated. The quality bars are set.**

**Let's build exceptional fiction.**

---

**Document:** 00_SYSTEM_OVERVIEW.md  
**Version:** 1.0.0-alpha  
**Status:** Architecture Approved  
**Next Document:** 01_AGENT_OPERATING_CONTRACT.md
