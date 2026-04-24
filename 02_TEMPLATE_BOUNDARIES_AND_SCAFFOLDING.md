# 02_TEMPLATE_BOUNDARIES_AND_SCAFFOLDING.md
## Template Isolation, Project Scaffolding, & Version Management

**Version**: 1.0.0-alpha  
**Last Updated**: 2026-04-23  
**Status**: Project Lifecycle Management  
**Audience**: Showrunner, Scaffolding Agents, Project Managers

---

## Executive Summary

MFST is a **template**, not a direct tool. It is **copied** (scaffolded) into project-specific directories where projects evolve independently. This document defines:

1. **Boundary Rules** — What is template vs. project-specific
2. **Scaffolding Algorithm** — How projects are created from the template
3. **Version Management** — How templates and projects track versions
4. **Upgrade Path** — How template improvements propagate to existing projects
5. **Safety Guardrails** — How to prevent corruption and maintain isolation

**Core Principle:** The template is **read-only** during project execution. Only copies (projects) are modified.

---

## Part 1: TEMPLATE BOUNDARIES

### 1.1 What Is the Template?

**Location:** `/home/whyte/.MyLit/Fiction/_Meta_Fiction_System/`

**Contents:**
- `.template-root` — Marker file (empty, just signals "this is a template")
- `.fiction-template-version` — File containing semantic version (e.g., "1.0.0")
- All 20 core system documents (00_SYSTEM_OVERVIEW.md through 20_COPILOT_PLAN_MODE_RUNBOOK.md)
- `agents/` directory (16 agent profiles)
- `prompts/` directory (master + specialized prompts)
- `contracts/` directory (IO contracts, validation schemas)
- `contexts/` directory (context packing rules)
- `templates/` directory (starter templates for projects)
- `rules/` directory (safety rules)
- `skills/` directory (reusable expertise)
- `hooks/` directory (automation hooks)
- `scripts/` directory (utility scripts)
- `meta/` directory (meta-system documentation)
- `tests/` directory (acceptance test specifications)
- `architecture/` directory (system design docs)

**NOT a template:**
- `git/` directory (project-specific VCS)
- `.env` files (project-specific config)
- `_staging/` directory (if present; project-specific workspace)

### 1.2 What Is a Project (Scaffolded Copy)?

**Location:** `[ARBITRARY_PROJECT_ROOT]/`

**Created from:** Template via scaffolding algorithm

**Contents (Initially):**
- Exact copy of all template files
- `.fiction-template-origin` — Reference to original template version
- `.fiction-project-version` — Project's own version (initially matches template)
- Project-specific configuration files

**Contents (After Execution):**
- All template files (unmodified)
- PROJECT_BRIEF.md (newly written)
- SERIES_BIBLE.md (newly written)
- WORLD_BIBLE.md (newly written)
- Drafts, edits, revision notes
- Project-specific agent logs
- CONTRADICTIONS.md (new issues found)
- RETCONS.md (approved world-state changes)

**Isolation Key:** Project can MODIFY its copies but CANNOT modify the template.

### 1.3 Immutable Zones (In Template)

These files **CANNOT** be modified by project agents:

- `.template-root` — Presence confirms this is a template
- `.fiction-template-version` — Semantic version marker (append-only log)
- All `agents/*.agent.md` files — Agent contracts don't change mid-execution
- All documents in `rules/` directory — Safety rules are non-negotiable
- `skills/` directory — Best practices are immutable
- `contracts/` directory — IO contracts don't break mid-stream

**Why immutable:** If template files changed during project execution, every running project would break.

### 1.4 Mutable Zones (In Project Copy)

Project agents CAN modify these:

- PROJECT-specific files (PROJECT_BRIEF.md, SERIES_BIBLE.md, etc.)
- Draft manuscripts
- Revision notes
- CONTRADICTIONS.md (logging new issues)
- RETCONS.md (recording approved changes)
- Project-specific logs and metadata

**Why mutable:** Projects evolve. The template must not.

### 1.5 Read-Only Context (In Project Copy)

These files are technically mutable in the project copy, but agents treat them as **immutable**:

- CANON_LEDGER.md — Only appended to via RETCONS.md (never overwritten)
- WORLD_BIBLE.md — Can only change via approved retcons
- CHARACTER_REGISTRY.md — Base definitions frozen; new characters ok, existing characters locked
- TIMELINE.md — Immutable except via approved retcons

**Mechanism:** Agents are explicitly forbidden from modifying these via `rules/canon_first.rules.md`.

---

## Part 2: SCAFFOLDING ALGORITHM

### 2.1 Scaffolding Trigger

Scaffolding happens when:
1. New project is requested
2. Project root directory is empty OR only contains `.git/` and `.gitignore`
3. Showrunner issues `scaffold_fiction_project.sh` command

```bash
./scripts/scaffold_fiction_project.sh \
  --template-path /home/whyte/.MyLit/Fiction/_Meta_Fiction_System/ \
  --project-path /path/to/new/project/ \
  --project-name "ProjectCodename" \
  --author-name "Author Name"
```

### 2.2 Fresh Project Scaffolding (New Project)

**Scenario:** Project directory is completely empty

**Algorithm:**

```
STEP 1: Validate Inputs
  ├─ Template path exists and contains .template-root
  ├─ Project path is writable
  ├─ Project name is valid (alphanumeric + underscore)
  ├─ Author name is non-empty
  └─ If ANY check fails: STOP with error message

STEP 2: Create Project Directory Structure
  ├─ Create project root
  ├─ Create project/agents/
  ├─ Create project/prompts/
  ├─ Create project/contracts/
  └─ ... (all subdirectories)

STEP 3: Copy Template Files (Recursive)
  ├─ Copy all files from template/
  ├─ Exclude: .git/, .gitignore, git-specific files
  ├─ Preserve directory structure exactly
  ├─ Verify each file copied successfully (checksum match)
  └─ If ANY file fails to copy: ROLLBACK entire scaffolding

STEP 4: Create Project Metadata Files
  ├─ .fiction-template-origin = "[TEMPLATE_PATH]"
  ├─ .fiction-project-version = read(.template-version from template)
  ├─ .fiction-template-origin-version = read(.template-version from template)
  ├─ .fiction-project-metadata.json = {
  │    "created_at": ISO8601,
  │    "author": "Author Name",
  │    "project_name": "ProjectCodename",
  │    "template_version": "1.0.0",
  │    "first_phase_date": ISO8601
  │  }
  └─ Create PROJECT_STATUS.md (initialized, Phase 0 pending)

STEP 5: Initialize Version Control
  ├─ git init (if not already initialized)
  ├─ git add all files
  ├─ git commit -m "Initial scaffolding from MFST template v[VERSION]"
  └─ Create branch: refs/tags/scaffolded-v[VERSION]

STEP 6: Post-Scaffolding Validation
  ├─ Verify all template files exist in project
  ├─ Verify .template-root exists
  ├─ Verify .fiction-template-version readable
  ├─ Verify all .agent.md files present
  ├─ Verify directory structure intact
  ├─ Run smoke_test_template.sh against project copy
  └─ If ANY validation fails: Flag for human review

STEP 7: Success Signal
  ├─ Return scaffolding manifest:
  │  {
  │    "status": "success",
  │    "project_path": "/path/to/project",
  │    "template_version": "1.0.0",
  │    "first_agent_to_dispatch": "showrunner",
  │    "first_task": "project_intake",
  │    "timestamp": ISO8601
  │  }
  └─ Log to AUDIT_TRAIL.md
```

**Checksum Verification:**
For every file copied, compute:
```
SHA256(source_file) == SHA256(copied_file)
```

If mismatch detected: Stop, rollback, report error.

### 2.3 Existing Project Upgrade (Template Update)

**Scenario:** Project already exists, template has been improved (version bump)

**Setup:**
- `template_v0` — Project was scaffolded from this version
- `template_v1` — New template version available
- `project_v0` — Current state of project

**Goal:** Merge template improvements into project WITHOUT corrupting project-specific content

**Algorithm (3-Way Merge):**

```
STEP 1: Identify Differences
  ├─ Read template_v0 (original template project was based on)
  ├─ Read template_v1 (new template)
  ├─ Read project_v0 (current project state)
  ├─ Compute diff_A = template_v0 → template_v1 (what changed in template)
  ├─ Compute diff_B = template_v0 → project_v0 (what changed in project)
  └─ Identify conflicts = files changed in BOTH template and project

STEP 2: Auto-Merge Categories
  ├─ Category A: Only template changed
  │  └─ → Apply template change to project (project keeps it)
  │
  ├─ Category B: Only project changed
  │  └─ → Keep project version (no conflict)
  │
  ├─ Category C: Both changed (CONFLICT)
  │  ├─ If project file is mutable (PROJECT_BRIEF.md, drafts, etc.)
  │  │   → Keep project version (project's customizations take priority)
  │  │
  │  └─ If project file is immutable copy (agents/, rules/, contracts/)
  │      └─ Insert conflict markers:
  │          <<<<<<< PROJECT_v0
  │          [project version]
  │          =======
  │          [template_v1 version]
  │          >>>>>>> TEMPLATE_v1

STEP 3: Handle Immutable Zones
  ├─ agents/ directory
  │  └─ If template has new agents: Add them (project won't have them)
  │  └─ If template updated existing agent: Conflict marker (project keeps old)
  │
  ├─ rules/ directory
  │  └─ If template added rules: Add them
  │  └─ If template modified existing rule: Conflict marker (keep old for safety)
  │
  ├─ contracts/ directory
  │  └─ Apply all template updates (these are infrastructure)

STEP 4: Handle Project-Specific Files
  ├─ Any file with project metadata in filename (e.g., "PROJECT_BRIEF.md")
  │  └─ Keep project version (never overwrite project work)
  │
  ├─ Any file in .gitignore (e.g., .env, _staging/)
  │  └─ Skip (not part of template anyway)

STEP 5: Create Merge Report
  ├─ files_auto_merged: [list of non-conflicting changes]
  ├─ conflicts_found: [list of files with conflicts]
  ├─ new_features_available: [new agents, new rules, new skills]
  ├─ breaking_changes: [deprecated features, renamed contracts]
  └─ manual_review_needed: [files requiring human decision]

STEP 6: Commit Merge
  ├─ git add all merged files
  ├─ git commit -m "Merge template v0 → v1 (3-way merge)"
  ├─ Create tag: refs/tags/template-upgrade-to-v[VERSION]
  ├─ If conflicts present:
  │  └─ Create conflict resolution branch
  │  └─ Flag for human review
  │  └─ Do NOT proceed until conflicts resolved
  └─ If no conflicts:
       └─ Proceed normally

STEP 7: Post-Merge Validation
  ├─ Verify all immutable zones intact (agents/, rules/, contracts/)
  ├─ Verify project-specific files unchanged
  ├─ Run smoke_test_template.sh against merged project
  ├─ If validation fails:
  │  └─ Rollback merge
  │  └─ Report error
  │  └─ Flag for manual investigation
  └─ If validation passes:
       └─ Update .fiction-template-origin-version = template_v1
       └─ Create .template-upgrade-log.md with summary
```

### 2.4 Scaffolding Safety Checks

Before any scaffolding, the system verifies:

```
✓ Template has .template-root marker
✓ Template has .fiction-template-version file
✓ Template version is readable (valid semantic version)
✓ All required agent profiles present in agents/
✓ All required prompts present in prompts/
✓ All required contracts present in contracts/
✓ Directory structure is complete
✓ No corrupted or truncated files

If ANY check fails:
  → Do NOT scaffold
  → Report error to Showrunner
  → Suggest template repair
```

---

## Part 3: VERSION MANAGEMENT

### 3.1 Semantic Versioning

Both template and projects use **semantic versioning**: `MAJOR.MINOR.PATCH`

**Template Version (`/template/.fiction-template-version`):**
```
1.0.0
├─ MAJOR = 1: Architecture (core pipeline, agents, contracts)
├─ MINOR = 0: Features (new skills, new rules, new agents)
└─ PATCH = 0: Bugfixes (corrected docs, fixed scripts)
```

**Rules:**
- `MAJOR` bump → Breaking changes (agent contracts modified, phase structure changed)
- `MINOR` bump → Backward-compatible additions (new agent, new skill, new rule)
- `PATCH` bump → Bugfixes only (no new features, no breaking changes)

**Project Version (`/project/.fiction-project-version`):**
```
1.0.0-project.1
├─ 1.0.0 = Template version it was scaffolded from
└─ project.1 = Project-specific version increment
```

### 3.2 Version Compatibility Matrix

Projects can be scaffolded from ANY template version, but upgrade paths have rules:

```
Project Scaffolded From    Can Upgrade To
━━━━━━━━━━━━━━━━━━━━━━━━  ═════════════════════════════════
1.0.0                      1.0.1, 1.0.2, ... (PATCH safe)
                          1.1.0, 1.2.0, ... (MINOR safe)
                          2.0.0 (requires migration guide)

1.1.0                      1.1.1, 1.1.2, ... (PATCH safe)
                          1.2.0, 1.3.0, ... (MINOR safe)
                          2.0.0 (requires migration guide)

Upgrade blocked if:
  - Project is mid-execution (Phase 3+)
  - Project has unresolved contradictions
  - Project has outstanding retcons pending review
```

### 3.3 Version History File

Each project maintains `.template-upgrade-log.md`:

```markdown
## Template Upgrade Log

### Upgrade 1: v0.9.0 → v1.0.0
- **Date:** 2026-04-23
- **Triggered By:** showrunner
- **Changes:**
  - Added new agent: Meta System Architect
  - Added new skill: reader_emotion_engineering
  - Updated contract: 01_AGENT_OPERATING_CONTRACT.md v1.0.1
- **Conflicts:** 0
- **Status:** ✅ Successful

### Upgrade 2: v1.0.0 → v1.0.1
- **Date:** 2026-04-30
- **Triggered By:** automatic (PATCH bump)
- **Changes:**
  - Fixed: 07_SCENE_DRAFTING_ENGINE.md typo
  - Updated: scripts/detect_contradictions.sh (performance)
- **Conflicts:** 0
- **Status:** ✅ Successful
```

---

## Part 4: UPGRADE WORKFLOW

### 4.1 Detecting Template Improvements

Showrunner periodically checks:

```bash
TEMPLATE_VERSION=$(cat /path/to/template/.fiction-template-version)
PROJECT_ORIGIN_VERSION=$(cat /path/to/project/.fiction-template-origin-version)

if [ "$TEMPLATE_VERSION" != "$PROJECT_ORIGIN_VERSION" ]; then
  echo "Template upgrade available: $PROJECT_ORIGIN_VERSION → $TEMPLATE_VERSION"
  # Offer upgrade to project manager
fi
```

### 4.2 Blocking Upgrade Conditions

Project CANNOT be upgraded if:

1. **Phase 3 or later in progress**
   - Reason: Ongoing work + template changes = high merge conflict risk
   - Solution: Complete current phase first

2. **Contradictions unresolved in project**
   - Reason: Merge might hide issues or create more conflicts
   - Solution: Resolve contradictions first

3. **Retcons pending review**
   - Reason: Template update might affect retcon logic
   - Solution: Approve/reject all pending retcons first

4. **Uncommitted changes in project**
   - Reason: Cannot safely 3-way merge without clean state
   - Solution: Commit all changes first

### 4.3 Upgrade Request Workflow

```
Project Manager: "Upgrade my project to template v1.1.0"
          ↓
Showrunner checks blocking conditions
          ├─ If blocked: "Cannot upgrade: [reason]. Please resolve first."
          └─ If clear: Proceed
          ↓
Showrunner runs 3-way merge (2.3 algorithm)
          ↓
Result: "Found 3 conflicts in agents/ directory"
          ├─ Auto-merged 47 non-conflicting files
          ├─ Conflict markers inserted in 3 files
          ├─ Manual review needed
          └─ Create tag: template-upgrade-to-v1.1.0
          ↓
Human reviewer resolves conflicts
          ├─ For each conflict:
          │  ├─ Decide: Keep project version OR accept template version?
          │  ├─ Remove conflict markers
          │  └─ Verify correctness
          └─ Commit resolution
          ↓
Showrunner validates merged state
          ├─ Run smoke_test_template.sh
          └─ If passes: Update .fiction-template-origin-version
             If fails: Rollback, report error
          ↓
Project successfully upgraded to v1.1.0
```

---

## Part 5: SAFETY GUARDRAILS

### 5.1 Corruption Prevention

**Prevention 1: Checksum Verification**
- Every file copied during scaffolding is verified
- Checksum stored in `.scaffolding-manifest.json`
- Regular audits compare current state to stored checksums

**Prevention 2: Read-Only Template**
- Template directory owned by `root` (or appropriate system user)
- Project agents have no write permissions to template
- Scaffolding creates **copies**, not references/symlinks

**Prevention 3: Immutability Markers**
- Files in `agents/`, `rules/`, `contracts/` have `immutable` flag set
- Project agents receive error if attempting modification

**Prevention 4: Git Protection**
- Template in its own git repo (separate from projects)
- Projects initialized as separate git repos
- Template changes tracked independently from project changes

### 5.2 Conflict Detection

Every phase completion runs:

```
CONFLICT DETECTION CHECKLIST:
  ✓ Template files in project unchanged from scaffolding
  ✓ Project-specific files not overwritten by template copy
  ✓ .template-root marker still present (no accidental deletion)
  ✓ All agent profiles match template originals
  ✓ All safety rules still in place
  ✓ No project files written to template directory
  ✓ Canon ledger not modified by non-Showrunner agents
```

### 5.3 Rollback Procedure

If project is corrupted or merge fails:

```
STEP 1: Detect corruption
  ├─ Checksum mismatch found
  ├─ OR merge conflicts unresolvable
  ├─ OR agent modified immutable file

STEP 2: Signal Showrunner
  ├─ Send alert: "PROJECT CORRUPTION DETECTED"
  ├─ Include error details
  ├─ Stop all agent work

STEP 3: Analyze root cause
  ├─ Determine what went wrong
  ├─ Preserve error state for investigation

STEP 4: Decide rollback strategy
  ├─ Option A: Rollback to last good commit
  │   └─ git reset --hard [last_good_commit]
  │   └─ Project loses recent work (worst case)
  │
  ├─ Option B: Rollback template upgrade only
  │   └─ Revert merge commit
  │   └─ Stay on old template version
  │   └─ Project work preserved
  │
  └─ Option C: Manual repair
       └─ Human manually fixes corrupted files
       └─ Most time-consuming but most controlled

STEP 5: Validate post-rollback
  ├─ Run checksums against backups
  ├─ Run smoke_test_template.sh
  ├─ Verify project can proceed

STEP 6: Document incident
  ├─ Create incident report
  ├─ Include root cause
  ├─ Include remediation steps
  ├─ Add to .template-upgrade-log.md
```

---

## Part 6: OPERATIONAL PROCEDURES

### 6.1 Creating a New Project (Showrunner)

```bash
#!/bin/bash
# Showrunner command to scaffold new fiction project

PROJECT_NAME="EpicTrilogy"
AUTHOR="Jane Author"
TEMPLATE_PATH="/home/whyte/.MyLit/Fiction/_Meta_Fiction_System"
PROJECT_ROOT="/path/to/projects/${PROJECT_NAME}/"

# Create directory
mkdir -p "$PROJECT_ROOT"

# Run scaffolding
./scripts/scaffold_fiction_project.sh \
  --template-path "$TEMPLATE_PATH" \
  --project-path "$PROJECT_ROOT" \
  --project-name "$PROJECT_NAME" \
  --author-name "$AUTHOR"

# Verify scaffolding succeeded
if [ $? -eq 0 ]; then
  echo "✅ Project scaffolded successfully"
  echo "Next: cd $PROJECT_ROOT && open PROJECT_BRIEF.md"
else
  echo "❌ Scaffolding failed"
  rm -rf "$PROJECT_ROOT"
  exit 1
fi
```

### 6.2 Upgrading Existing Project (Showrunner)

```bash
#!/bin/bash
# Showrunner command to upgrade project to new template version

PROJECT_PATH="/path/to/projects/EpicTrilogy"
TEMPLATE_PATH="/home/whyte/.MyLit/Fiction/_Meta_Fiction_System"

# Check blocking conditions
./scripts/validate_fiction_project.sh --check-upgrade-ready "$PROJECT_PATH"

if [ $? -ne 0 ]; then
  echo "❌ Project cannot be upgraded. Resolve blocking issues first."
  exit 1
fi

# Perform 3-way merge
./scripts/update_downstream_project.sh \
  --project-path "$PROJECT_PATH" \
  --template-path "$TEMPLATE_PATH" \
  --merge-mode "3way"

# If conflicts found
if [ -f "$PROJECT_PATH/.merge-conflicts.txt" ]; then
  echo "⚠️  Conflicts found. Manual review required."
  echo "See: $PROJECT_PATH/.merge-conflicts.txt"
  exit 0
else
  echo "✅ Project upgraded successfully"
fi
```

---

## Part 7: TROUBLESHOOTING

### Common Issue 1: Scaffolding Fails (Corruption Detected)

**Symptom:** `scaffold_fiction_project.sh` stops mid-way with checksum error

**Cause:** Template corrupted or unreadable

**Resolution:**
1. Verify template integrity: `./scripts/audit_fiction_template.sh`
2. If template damaged: Restore from backup or re-scaffold template from source
3. Retry project scaffolding

### Common Issue 2: Merge Conflicts Unresolvable

**Symptom:** Merge finds contradictions it cannot auto-resolve

**Cause:** Project heavily customized template files; template has breaking changes

**Resolution:**
1. Review conflict markers in affected files
2. Decide for each: Keep project version OR accept template version
3. If unsure: Keep project version (safer) and manual merge later
4. Commit resolution
5. Verify with smoke test

### Common Issue 3: Project Cannot Be Upgraded

**Symptom:** `validate_fiction_project.sh --check-upgrade-ready` fails

**Cause:** Project has unresolved contradictions or is mid-phase

**Resolution:**
1. Check PROJECT_STATUS.md for current phase
2. If mid-phase: Complete phase first, then upgrade
3. If contradictions: Resolve in CONTRADICTIONS.md, then upgrade
4. Retry upgrade

---

## Part 8: FILE MANIFEST

### Template Directory Structure (Post-v1.0.0)

```
_Meta_Fiction_System/
├── .template-root                          (marker: empty file)
├── .fiction-template-version               (content: "1.0.0")
├── 00_SYSTEM_OVERVIEW.md
├── 01_AGENT_OPERATING_CONTRACT.md
├── 02_TEMPLATE_BOUNDARIES_AND_SCAFFOLDING.md
├── [... all 20 core documents ...]
├── agents/                                 (16 .agent.md files)
├── prompts/                                (master + 12 specialized)
├── contracts/                              (8 IO contracts)
├── contexts/                               (4 context packing docs)
├── templates/
│   ├── project/                            (20 project templates)
│   └── scene/                              (4 scene templates)
├── rules/                                  (8 safety rule files)
├── skills/                                 (10 skill documentation)
├── hooks/                                  (5 automation hooks)
├── scripts/                                (7 shell scripts)
├── meta/                                   (6 meta-system docs)
├── tests/                                  (5 test specifications)
└── architecture/                           (existing directory)
```

### Project Directory Structure (Post-Scaffolding)

```
ProjectName/
├── .fiction-template-origin                (content: "/path/to/template")
├── .fiction-project-version                (content: "1.0.0-project.1")
├── .fiction-template-origin-version        (content: "1.0.0")
├── .fiction-project-metadata.json
├── .template-upgrade-log.md                (empty initially)
├── [... entire template copied ...]
├── .git/                                   (project-specific repo)
├── PROJECT_BRIEF.md                        (new, created by Architect)
├── SERIES_BIBLE.md                         (new, created in Phase 1)
├── CONTRADICTIONS.md                       (new, populated as issues found)
├── RETCONS.md                              (new, populated as retcons approved)
└── [... drafts, revisions, project-specific files ...]
```

---

## Conclusion

This system ensures:

1. **Template Integrity** — Template never modified during project execution
2. **Project Independence** — Each project evolves separately
3. **Safe Upgrades** — 3-way merge prevents data loss
4. **Full Traceability** — Version history preserved in each project
5. **Error Recovery** — Checksums and rollback procedures available

**The boundary between template and project is airtight. The upgrade path is safe and reversible.**

---

**Document:** 02_TEMPLATE_BOUNDARIES_AND_SCAFFOLDING.md  
**Version:** 1.0.0-alpha  
**Status:** Project Lifecycle Management Approved  
**Phase Alpha Complete:** ✅ 3/3 documents created  
**Next Phase:** Beta (Multi-Series Pipeline + Engines)
