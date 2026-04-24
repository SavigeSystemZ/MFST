# 01_AGENT_OPERATING_CONTRACT.md
## Formal Agent IO Specification & Handoff Protocol

**Version**: 1.0.0-alpha  
**Last Updated**: 2026-04-23  
**Status**: Agent Coordination Layer  
**Audience**: All AI Agents + Showrunner

---

## Purpose

This document defines the **universal contract** by which all agents receive work, perform it, and deliver results. It ensures:
- ✅ Predictable inputs (no surprises)
- ✅ Explicit outputs (measured against criteria)
- ✅ Clear error handling (what to do when things go wrong)
- ✅ Formal handoffs (ready for next agent)
- ✅ Auditability (every interaction is traceable)

**Violating this contract is a critical system failure.** Agents must not proceed if the contract is not satisfied.

---

## Part 1: INPUT CONTRACT

### 1.1 Standard Input Format

Every agent receives work in a **standard JSON envelope**:

```json
{
  "work_id": "string (unique identifier)",
  "agent_role": "string (showrunner | architect | scene_drafter | etc.)",
  "phase": "integer (0-7, which phase of the pipeline)",
  "task_type": "string (design | draft | edit | audit | etc.)",
  "task_priority": "enum (critical | high | normal | low)",
  "task_deadline": "ISO8601 timestamp",
  
  "context": {
    "project_state": "object (immutable reference to current project)",
    "project_brief": "string (path to PROJECT_BRIEF.md)",
    "series_bible": "string (path to SERIES_BIBLE.md)",
    "world_bible": "string (path to WORLD_BIBLE.md)",
    "canon_ledger": "string (path to CANON_LEDGER.md)",
    "character_registry": "string (path to CHARACTER_REGISTRY.md)",
    "plot_architecture": "string (path to PLOT_ARCHITECTURE.md)",
    "additional_context": "array of string paths (task-specific files)"
  },
  
  "agent_briefing": {
    "role_definition": "string (what this agent is responsible for)",
    "specific_task": "string (exactly what to do)",
    "success_criteria": "array of string (explicit pass/fail criteria)",
    "constraints": "array of string (safety rules, style rules, canon rules)",
    "fallback_instructions": "object (what to do if primary approach fails)"
  },
  
  "io_contract": {
    "input_format_version": "semantic version",
    "output_format_version": "semantic version",
    "required_output_fields": "array of field names",
    "optional_output_fields": "array of field names",
    "validation_schema": "JSON Schema for output validation"
  },
  
  "resource_limits": {
    "max_context_tokens": "integer (hard budget)",
    "max_output_tokens": "integer (hard limit)",
    "max_execution_time_seconds": "integer",
    "estimated_cost_usd": "float"
  },
  
  "error_handling": {
    "retry_count": "integer (how many attempts allowed)",
    "retry_backoff_seconds": "integer (exponential backoff)",
    "escalation_trigger": "enum (after N failures, escalate to Showrunner)",
    "timeout_action": "enum (retry | escalate | use_fallback)"
  }
}
```

### 1.2 Validation Checklist (Agent Must Verify Before Starting)

Before beginning work, agent checks:

```
✓ work_id is unique and non-empty
✓ agent_role matches this agent's role
✓ phase is 0-7 and valid for this agent
✓ All required context files exist and are readable
✓ All required context files are non-empty
✓ Canon ledger is accessible and current
✓ Character registry is accessible and current
✓ Project state JSON is valid
✓ Success criteria are clear and measurable
✓ Constraints are understood (canon-first, no lazy prose, etc.)
✓ Resource limits allow execution
✓ Output schema is understood
```

**If ANY check fails:** Agent MUST NOT proceed. Instead:
1. Return error status (see Part 3)
2. Flag for Showrunner review
3. Wait for corrected input

### 1.3 Context Injection Rules

**Immutable Context (read-only):**
- CANON_LEDGER.md — Cannot be modified (append only via RETCONS.md)
- PROJECT_BRIEF.md — Cannot be modified (locked by Showrunner)
- SERIES_BIBLE.md — Cannot be modified after Phase 1 completion
- WORLD_BIBLE.md — Cannot be modified except via approved retcons

**Mutable Context (can modify):**
- Draft manuscript sections (assigned to this agent)
- SCENE_CONTINUITY_CHECKS.md (this agent's scene)
- REVISION_NOTES.md (this agent's pass)
- CONTRADICTIONS.md (flagging new contradictions only)

**Newly Created Context (this agent owns):**
- Deliverables (whatever artifact this agent is responsible for)
- Metadata + provenance logs

---

## Part 2: WORK EXECUTION CONTRACT

### 2.1 Work Phases & Checkpoints

Every work unit follows this structure:

```
PHASE 1: INITIALIZATION
  ├─ Load context
  ├─ Validate input contract
  ├─ Initialize work log
  └─ Set up error recovery state

PHASE 2: PRE-WORK VALIDATION
  ├─ Check dependencies (other agents' work available?)
  ├─ Verify context consistency (no contradictions in input?)
  ├─ Confirm resource availability (budget not exceeded?)
  └─ Estimate execution time

PHASE 3: MAIN WORK (with mid-work checkpoints)
  ├─ Checkpoint 1 (25% complete): Validate approach
  ├─ Checkpoint 2 (50% complete): Validate intermediate output
  ├─ Checkpoint 3 (75% complete): Validate near-final work
  └─ DELIVERY: Final output assembly

PHASE 4: POST-WORK VALIDATION
  ├─ Validate output format (matches IO contract)
  ├─ Validate output content (meets success criteria)
  ├─ Validate canon adherence (no untracked retcons)
  ├─ Validate prose quality baseline (if applicable)
  └─ Validate continuity (no new contradictions)

PHASE 5: DELIVERY & INTEGRATION
  ├─ Package output per IO contract
  ├─ Record metadata (agent ID, timestamp, version)
  ├─ Update project state
  ├─ Log deliverable to audit trail
  └─ Signal readiness for next agent
```

### 2.2 Mid-Work Error Handling

If **any** mid-work checkpoint fails:

1. **Identify error category:**
   - Auto-fixable (typo, formatting issue) → Fix it
   - Clarifiable (ambiguous instruction) → Ask Showrunner (blocking)
   - Re-attemptable (random error) → Retry with backoff
   - Critical (logic error, canon violation) → Escalate

2. **Execute recovery:**
   ```
   Auto-Fixable → Fix immediately → Continue
   Clarifiable → Request clarification → Wait
   Re-attemptable → Sleep(backoff) → Retry
   Critical → Log error → Signal Showrunner → STOP
   ```

3. **Track recovery:**
   - Log what went wrong
   - Log what was attempted
   - Log outcome
   - Include in deliverable metadata

### 2.3 Continuity Checkpoints (For Writing Agents)

If agent is **writing** or **editing** content (Scene Drafter, Prose Stylist, etc.):

At **every 500 words** OR **every 30 minutes** (whichever comes first):

```
MICRO-CHECKPOINT:
  ✓ Does this text match the established voice/tone?
  ✓ Are character names spelled consistently?
  ✓ Are locations named correctly?
  ✓ Does the timeline make sense?
  ✓ Do character behaviors align with psychology?
  ✓ Is there any hint of contradiction with canon?
```

If **ANY** check fails: Flag for later, continue work, include in delivery metadata.

---

## Part 3: OUTPUT CONTRACT

### 3.1 Standard Output Format

Every agent delivers work in a **standard JSON envelope**:

```json
{
  "work_id": "string (must match input work_id)",
  "agent_role": "string (which agent produced this)",
  "timestamp": "ISO8601 timestamp (when work completed)",
  "status": "enum (success | partial | failed)",
  
  "deliverable": {
    "artifact_type": "enum (design_doc | draft_text | edited_text | report | metadata)",
    "artifact_format": "enum (markdown | json | plain_text | binary)",
    "artifact_path": "string (where to find the deliverable)",
    "artifact_size_bytes": "integer",
    "content_hash": "SHA256 hash of deliverable"
  },
  
  "validation": {
    "success_criteria": "object (map of criteria -> pass/fail/partial)",
    "all_criteria_met": "boolean (true if ALL criteria pass)",
    "issues_found": "array of string (what went wrong, if anything)",
    "canon_violations": "array of string (any retcons? any contradictions?)",
    "continuity_flags": "array of object (potential issues for downstream agents)"
  },
  
  "metadata": {
    "execution_time_seconds": "float",
    "tokens_used": "object {input: int, output: int, total: int}",
    "cost_usd": "float",
    "model_used": "string (GPT-5-mini, Claude-Haiku, etc.)",
    "attempt_number": "integer (which retry attempt was this)",
    "error_recovery_applied": "array of string (auto-fixes used)"
  },
  
  "handoff": {
    "ready_for_next_phase": "boolean (true if no blocking issues)",
    "dependent_agents": "array of string (which agents should be notified)",
    "blocking_issues": "array of string (what must be fixed before proceeding)",
    "recommendations": "array of string (suggestions for next agent)"
  },
  
  "audit_trail": {
    "decision_log": "string (why decisions were made)",
    "assumptions": "array of string (what was assumed)",
    "fallbacks_used": "array of string (which fallback instructions were used)",
    "human_review_needed": "boolean (does this need human eyes?)",
    "human_review_reason": "string (if true, why)"
  }
}
```

### 3.2 Validation Rules for Output

**Format Validation:**
- JSON must be valid and well-formed
- All required fields must be present
- Status must be one of: success, partial, failed

**Content Validation:**
- all_criteria_met must match success_criteria assessment
- Artifact must exist at artifact_path
- Content_hash must match actual file
- Ready_for_next_phase cannot be true if blocking_issues exist

**Audit Validation:**
- Decision log must explain any deviations from brief
- Assumptions must be explicitly stated
- Human review reason must match human_review_needed

**If ANY validation fails:** Output is rejected, returned to agent with error message, agent must fix and resubmit.

### 3.3 Success Criteria Examples

**For Architect (Project Intake):**
```
✓ PROJECT_BRIEF.md exists and is non-empty
✓ One-sentence premise is clear and compelling
✓ Genre + subgenre explicitly stated
✓ Target audience demographics specified
✓ 3-5 comparable works analyzed with specifics
✓ Creative north star is one coherent paragraph
✓ Success criteria are measurable (not vague)
✓ Constraints list any content warnings or POV limits
✓ No grammatical errors or typos
```

**For Scene Drafter:**
```
✓ Scene is between [MIN_WORDS] and [MAX_WORDS]
✓ All character names match CHARACTER_REGISTRY.md
✓ All locations match LOCATION_REGISTRY.md
✓ All timeline references match TIMELINE.md
✓ Scene beat sequence matches SCENE_CARD.md
✓ POV is consistent (same character throughout OR explicit shifts)
✓ Voice matches established STYLE_GUIDE.md
✓ Emotional beat lands (reader should feel [EMOTION])
✓ Scene advances plot as specified in PLOT_ARCHITECTURE.md
✓ No continuity contradictions with adjacent scenes
✓ No untracked retcons (any world-state change is logged)
```

**For Continuity Editor:**
```
✓ CONTRADICTIONS.md reviewed for all entries
✓ Timeline checked for logical gaps
✓ Character ages consistent with TIMELINE.md
✓ Locations described consistently
✓ Historical events match CANON_LEDGER.md
✓ Power levels follow escalation rules from PLOT_ARCHITECTURE.md
✓ All retcons recorded in RETCONS.md
✓ Continuity audit report generated with findings
✓ No false alarms (all flagged issues are real problems)
✓ Recommendations clear and actionable
```

---

## Part 4: ERROR STATES & RECOVERY

### 4.1 Error Categories

**Category 1: INPUT ERRORS (fix source, not output)**
- Missing required context file
- Invalid context JSON
- Ambiguous task instructions
- Resource limits too tight

→ **Action:** Return error → Wait for Showrunner fix → Do not proceed

**Category 2: AUTO-FIXABLE ERRORS (agent fixes, continues)**
- Typo in output
- Formatting inconsistency
- Missing metadata field
- Wrong file extension

→ **Action:** Auto-fix → Log fix → Include in metadata → Continue

**Category 3: RE-ATTEMPTABLE ERRORS (retry with backoff)**
- Temporary resource unavailable
- Rate limit hit
- Network timeout (if external API call)
- Random transient failure

→ **Action:** Sleep(backoff) → Retry up to N times → If all fail, escalate

**Category 4: CRITICAL ERRORS (escalate immediately)**
- Canon contradiction detected
- Success criteria cannot be met
- Logical impossibility in task
- Safety rule violation
- Output schema violation

→ **Action:** Log error → Signal Showrunner → STOP (do not proceed)

### 4.2 Retry Strategy

```
Attempt 1: Initial work
  ├─ Fails (re-attemptable) → Sleep(1 sec) → Retry

Attempt 2: First retry
  ├─ Fails (re-attemptable) → Sleep(2 sec) → Retry

Attempt 3: Second retry
  ├─ Fails (re-attemptable) → Sleep(4 sec) → Retry

Attempt 4: Final attempt
  ├─ Fails → Escalate to Showrunner with full error log

Attempt N: Human correction received
  ├─ Resume from corrected state
```

### 4.3 Error Response Format

If agent encounters an error it cannot recover from:

```json
{
  "work_id": "string (original work_id)",
  "agent_role": "string (which agent encountered error)",
  "status": "failed",
  "error": {
    "category": "enum (input_error | auto_fixable | re_attemptable | critical)",
    "code": "string (ERROR_CANON_VIOLATION, ERROR_MISSING_CONTEXT, etc.)",
    "message": "string (human-readable description)",
    "details": "object (error-specific data)"
  },
  "recovery_attempted": {
    "attempts": "integer (how many retries)",
    "last_error_log": "string (latest error details)",
    "recovery_strategy_exhausted": "boolean"
  },
  "escalation": {
    "requires_human_review": "boolean",
    "recommended_action": "string (what Showrunner should do)",
    "timestamp": "ISO8601 (when escalation triggered)"
  }
}
```

### 4.4 Fallback Strategies

Every agent receives **fallback instructions** for the most common failure modes:

```json
"fallback_instructions": {
  "if_context_file_missing": "Use cached version from previous phase",
  "if_character_undefined": "Mark as [CHARACTER_TBD] and continue, flag for resolution",
  "if_timeline_gap_detected": "Assume realistic time jump, log assumption",
  "if_voice_inconsistent": "Revert to STYLE_GUIDE.md baseline",
  "if_budget_exceeded": "Trim less critical sections, prioritize main plot",
  "if_deadline_tight": "Use summary mode instead of full prose",
  "if_contradiction_detected": "Do not write, flag for Continuity Editor"
}
```

Agent should follow fallback **only if primary approach fails**. Must log fallback use in output metadata.

---

## Part 5: HANDOFF PROTOCOL

### 5.1 Ready for Next Phase

After successful completion, agent signals readiness:

```json
"handoff": {
  "ready_for_next_phase": true,  // Can only be true if no blocking_issues
  "dependent_agents": ["scene_drafter", "continuity_editor"],
  "blocking_issues": [],
  "recommendations": [
    "Scene drafter should pay attention to character psychology from Phase 3",
    "Continuity editor should flag any timeline references to verify against TIMELINE.md"
  ]
}
```

**Showrunner receives this handoff and decides:**
1. **Approve & Proceed** → Dispatch dependent agents
2. **Request Clarification** → Send back to agent with questions
3. **Request Rework** → Send back to agent with specific fixes
4. **Escalate** → Human review needed before proceeding

### 5.2 Dependent Agent Dispatch

When Phase N completes:

1. Showrunner validates handoff
2. If approved, Showrunner queries dependencies:
   ```sql
   SELECT depends_on FROM todo_deps WHERE todo_id = 'phase_N_complete';
   ```
3. For each dependent agent, Showrunner prepares input:
   - Load completed artifact from Phase N
   - Inject as context for Phase N+1 agent
   - Dispatch new work unit
   - Track in AUDIT_TRAIL.md

### 5.3 Parallel Execution

Some agents can run **in parallel** if they don't conflict:

```
Phase 4: PLOT ARCHITECTURE (can only run after Phase 3)
Phase 5: SCENE DRAFTING (depends on Phase 4)
         + CONTINUITY EDITOR (depends on Phase 4, can start immediately after)

OK: Scene Drafter and Continuity Editor run in parallel
    (Continuity Editor audits completed scenes as Scene Drafter writes new ones)

NOT OK: Scene Drafter and Canon Keeper cannot run in parallel
        (writing new scenes affects canon, creating conflicts)
```

Dependency graph in `mfst_dependencies` table defines what's safe to parallelize.

---

## Part 6: QUALITY METRICS

### 6.1 Per-Agent Success Rate

For each agent, track:
- Total work units assigned
- Successful completions (all criteria met)
- Partial completions (some criteria met)
- Failed completions (zero/few criteria met)
- Auto-recovery rate (% of errors self-fixed)
- Escalation rate (% requiring Showrunner intervention)

**Target:** <2% escalation rate, >80% auto-recovery rate

### 6.2 Handoff Quality

For each phase completion:
- % handoffs with zero blocking issues
- % handoffs with zero recommendations needed
- Average time from completion to next phase dispatch
- % of dependent agents able to proceed without clarification

**Target:** >95% of handoffs ready to proceed, <2 hour average dispatch time

### 6.3 Canon Integrity

- Contradictions detected per 10K words written: <0.5
- Retcons per book: <2 (ideally zero)
- Post-publication errata: 0 (goal)

---

## Appendix: IO Contract Version History

### v1.0.0 (2026-04-23)
- Initial specification
- 5-phase work execution model
- Standard JSON input/output format
- Error recovery strategies
- Fallback instructions

### v1.0.1 (TBD)
- Add model-specific context limits
- Add language/genre-specific constraints
- Add resource scheduling for multi-agent parallel execution

---

## Conclusion

This contract ensures that:
1. Every agent knows exactly what it will receive (no surprises)
2. Every agent knows exactly what it must produce (clear success criteria)
3. Every agent knows how to handle errors (systematic recovery)
4. Every handoff is explicit and auditible (full traceability)
5. The system degrades gracefully (fallback instructions prevent catastrophic failure)

**Agents must not violate this contract. The Showrunner must enforce it.**

**This is how a world-class system operates: with precision, clarity, and zero ambiguity.**

---

**Document:** 01_AGENT_OPERATING_CONTRACT.md  
**Version:** 1.0.0-alpha  
**Status:** Agent Coordination Layer Approved  
**Next Document:** 02_TEMPLATE_BOUNDARIES_AND_SCAFFOLDING.md
