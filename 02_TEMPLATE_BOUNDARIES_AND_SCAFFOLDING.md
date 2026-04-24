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

## MyLit layout note (canonical)

Two trees cooperate:

- **Book template (copy source for each title):** `../_Template_Fiction_System/` — runnable scaffold (`BOOK_MANIFEST.yaml`, `scripts/scaffold-from-template.sh`, `scripts/health-check.sh`, `canon/`, `manuscript/`, `agents/`, `assets/`, etc.).
- **Meta governance (not a book copy):** `../_Meta_Fiction_System/` — specifications and gates (`TEMPLATE_SPEC.md`, `WORKFLOWS.md`, `QUALITY_GATES.md`).

Sections below that describe **MFST** or generic shell steps are **architectural intent**. Operational commands in MyLit are `scripts/scaffold-from-template.sh` and `../install-mylit-book.sh` (see template `README.md`). Prefer **`BOOK_MANIFEST.yaml`** (`template_version`) over fictional marker files unless your fork adds them.

---

## Part 1: TEMPLATE BOUNDARIES

### 1.1 What Is the Book Template?

**Location:** `/home/whyte/.MyLit/Fiction/_Template_Fiction_System/` (sibling of `_Meta_Fiction_System/`).

**Role:** Default **copy source** for new book directories. Treat it as read-only while authoring inside a scaffolded copy.

**Version marker:** `BOOK_MANIFEST.yaml` → `template_version` (and optional `template_origin`). Validate structure with `./scripts/health-check.sh` from the book root.

**Core layout:** See that folder’s `README.md`. Includes `AGENTS.md`, `MASTER_SYSTEM_PROMPT.md`, `canon/`, `characters/`, `context/` (with `_seeds/` for automation), `manuscript/`, `prompts/`, `workflows/`, `scripts/`, `.cursor/rules/`, `skills/`, `assets/` (multi-modal prompts and media), and safety or handoff docs (`CONTENT_POLICY.md`, `HANDOFF_PROTOCOL.md`, `SELF_HEALING_AND_ADAPTATION.md`).

### 1.1b What Is the Meta System?

**Location:** `/home/whyte/.MyLit/Fiction/_Meta_Fiction_System/` (this governance tree).

**Role:** Evolve the book template safely. Meta agents implement changes under `_Template_Fiction_System/` per `WORKFLOWS.md`; they do **not** replace the book template with meta-only documents unless a human merges them deliberately.

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

### 1.3 Immutable zones (convention in a book copy)

Treat these as **locked** unless a human is upgrading from template or explicitly authorizes an edit:

- `BOOK_MANIFEST.yaml` lineage — do not falsify `template_origin` / `template_version`; bump `template_version` only when merging template releases (see `DRIFT_AND_SYNC.md`).
- `agents/*.md` shipped from the template — stable cross-tool contracts; edit only deliberately.
- `.cursor/rules/*.mdc` — safety and canon constraints; edit only with human intent.
- `CONTENT_POLICY.md` — boundaries; widen only with human approval.

**Why:** Random edits to shared contracts break multi-agent handoffs and drift tracking.

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
3. Human or showrunner runs MyLit `scaffold-from-template.sh` / `install-mylit-book.sh` (see template `README.md`)

```bash
# MyLit canonical (run from the parent of _Template_Fiction_System, e.g. Fiction/)
./_Template_Fiction_System/scripts/scaffold-from-template.sh "ProjectCodename"
# Optional: ../install-mylit-book.sh for merge-into-existing installs (see template README).
```

### 2.2 Fresh Project Scaffolding (New Project)

**Scenario:** Project directory is completely empty

**Algorithm:**

```
STEP 1: Validate Inputs
  ├─ Template path exists and contains BOOK_MANIFEST.yaml + scripts/health-check.sh
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
  ├─ Verify BOOK_MANIFEST.yaml exists and template_version is readable
  ├─ Verify agents/*.md present
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
✓ Template contains BOOK_MANIFEST.yaml with readable template_version
✓ ./scripts/health-check.sh passes when run from template root (and from a scaffolded copy)
✓ All required agent profiles present in agents/
✓ All required prompts present in prompts/
✓ Directory structure is complete (including assets/ per TEMPLATE_SPEC.md §4)
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
  ✓ BOOK_MANIFEST.yaml still present; lineage fields not corrupted
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
TEMPLATE_PATH="/home/whyte/.MyLit/Fiction/_Template_Fiction_System"

# MyLit: scaffold script resolves paths; cwd is optional (see template README)
PARENT="$(cd "$(dirname "$TEMPLATE_PATH")" && pwd)"
( cd "$PARENT" && "${TEMPLATE_PATH}/scripts/scaffold-from-template.sh" "$PROJECT_NAME" )

# Verify scaffolding succeeded (scaffold script creates ${PARENT}/${PROJECT_NAME})
if [[ -d "${PARENT}/${PROJECT_NAME}" ]]; then
  echo "✅ Project scaffolded successfully"
  echo "Next: cd ${PARENT}/${PROJECT_NAME} && edit BOOK_MANIFEST.yaml"
else
  echo "❌ Scaffolding failed"
  exit 1
fi
```

### 6.2 Upgrading Existing Project (Showrunner)

```bash
#!/bin/bash
# Showrunner command to upgrade project to new template version

PROJECT_PATH="/path/to/projects/EpicTrilogy"
TEMPLATE_PATH="/home/whyte/.MyLit/Fiction/_Template_Fiction_System"

# MyLit canonical: non-destructive merge of new template files, then self-heal.
# Set MYLIT_TEMPLATE_ROOT whenever the template is not at ${MYLIT_BOOKS_ROOT}/_Template_Fiction_System.
MYLIT_BOOKS_ROOT="$(dirname "$PROJECT_PATH")" \
MYLIT_BOOK_DIR="$PROJECT_PATH" \
MYLIT_TEMPLATE_ROOT="$TEMPLATE_PATH" \
MYLIT_INSTALL_NONINTERACTIVE=1 \
  "$(cd "${TEMPLATE_PATH}/.." && pwd)/install-mylit-book.sh"

# Then: read ../_Meta_Fiction_System/DRIFT_AND_SYNC.md for version-specific notes;
# bump template_version in BOOK_MANIFEST.yaml when the human accepts the merge.
```

---

## Part 7: TROUBLESHOOTING

### Common Issue 1: Scaffolding Fails (Corruption Detected)

**Symptom:** `scaffold-from-template.sh` or `install-mylit-book.sh` fails; `health-check.sh` reports missing paths

**Cause:** Template checkout incomplete, merge skipped directories, or disk permissions

**Resolution:**
1. From the book root: `./scripts/health-check.sh` and read any `MISSING` / `HINT` lines.
2. Re-run `./scripts/ensure-context.sh` and (for merges) `install-mylit-book.sh` with the same template root.
3. If still failing: compare against a fresh template copy per `DRIFT_AND_SYNC.md`.

### Common Issue 2: Merge Conflicts Unresolvable

**Symptom:** Merge finds contradictions it cannot auto-resolve

**Cause:** Project heavily customized template files; template has breaking changes

**Resolution:**
1. Review conflict markers in affected files
2. Decide for each: Keep project version OR accept template version
3. If unsure: Keep project version (safer) and manual merge later
4. Commit resolution
5. Verify with smoke test

### Common Issue 3: Project Cannot Be Upgraded (human gate)

**Symptom:** `health-check.sh` passes but the human refuses to merge template changes (risk to customized prompts/rules).

**Cause:** Drift between book copy and upstream template; unresolved canon conflicts noted in `context/HANDOFF_BRIEF.md` or `context/book/decisions-pending.md`.

**Resolution:**
1. Read `DRIFT_AND_SYNC.md` for the target `template_version` delta.
2. Merge with `install-mylit-book.sh` (`--ignore-existing` behavior) or selective `rsync` from `_Template_Fiction_System/`.
3. Resolve canon or voice conflicts before bumping `BOOK_MANIFEST.yaml` → `template_version`.

---

## Part 8: FILE MANIFEST

### Authoritative on-disk layout

Do **not** treat the ASCII trees in older MFST drafts as the live filesystem.

- **Book template (what authors copy):** `/home/whyte/.MyLit/Fiction/_Template_Fiction_System/README.md` plus `scripts/health-check.sh` (required paths).
- **Meta governance (specs and gates):** `/home/whyte/.MyLit/Fiction/_Meta_Fiction_System/` — Markdown specifications (`TEMPLATE_SPEC.md`, `WORKFLOWS.md`, this file, etc.); not a substitute for the book template tree.

### Template Directory Structure (Post-v1.0.0)

```
# Legacy MFST diagram — conceptual only. See README paths above.
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
