---
description: Refine a spec file through interview and Codex review loops (user)
argument-hint: [spec-file-path]
allowed-tools: AskUserQuestion, Read, Write, Edit, Task, Bash(mkdir:*)
---

## Task

Read the spec file at `$ARGUMENTS`, conduct an in-depth interview to refine requirements, and iteratively improve the spec using Codex MCP reviews until it reaches a complete state.

Note: `$ARGUMENTS` can be either a file path or raw text. If it's a file path, read the file. If it's text, treat it as the initial requirements.

## Workflow Overview

```
Phase 1: Initial Interview
    ↓
Phase 2: Requirement Conformance Review (max 5 loops)
    ↓
Phase 3: Technical Review Loop (max 5 loops)
    ↓
Phase 4: Final Confirmation
```

---

## Phase 1: Initial Interview

### Step 1: Read and Understand
Read the spec file at `$ARGUMENTS` and analyze its current state.
- If `$ARGUMENTS` is a file path, read the file content
- If `$ARGUMENTS` is text, treat it as initial requirements

### Step 2: Conduct Interview
Ask probing questions about:
- Technical implementation details
- UI/UX considerations
- Edge cases and error handling
- Security concerns
- Performance tradeoffs
- Integration points
- Testing strategy

### Interview Guidelines
- Avoid obvious questions - focus on:
  - Ambiguities in the spec
  - Unstated assumptions
  - Potential conflicts
  - Missing acceptance criteria
- Use AskUserQuestion with 2-4 focused options per question
- Continue until major gaps are addressed

### Step 3: Update Spec
Incorporate user responses into the spec file.

---

## Phase 2: Requirement Conformance Review

### Step 1: Launch Requirement Review

Launch the requirement conformance review using `Task` tool.

```
Task tool parameters:
  subagent_type: spec-reviewer-requirement
  prompt: Review the spec file at: $ARGUMENTS
  description: Requirement conformance review
```

### Step 2: Analyze Review Results

Collect and categorize all findings:

**If Blocker or Major severity issues exist:**
- Requirements mismatch → Ask user via AskUserQuestion with specific options
- User story issues → Present alternatives via AskUserQuestion
- Scope ambiguity → Clarify with user and document decision

Then update the spec and **return to Step 1** (max 5 iterations).

**If only Minor issues or Questions:**
- Add findings to a "Considerations" section in the spec
- Proceed to Phase 3

### Step 3: Update Spec
Incorporate review findings and user decisions into the spec file.

---

## Phase 3: Technical Review Loop

### Step 1: Launch Parallel Technical Reviews

Launch **3 technical reviews in parallel** using `Task` tool.

**IMPORTANT**: You MUST call all 3 Task tools in a single message for parallel execution.

#### Reviewer 1: Architecture (Software Architect)
```
Task tool parameters:
  subagent_type: spec-reviewer-architecture
  prompt: Review the spec file at: $ARGUMENTS
  description: Architecture review
```

#### Reviewer 2: Data (Data Architect)
```
Task tool parameters:
  subagent_type: spec-reviewer-data
  prompt: Review the spec file at: $ARGUMENTS
  description: Data architecture review
```

#### Reviewer 3: Testability (Software in Test Architect)
```
Task tool parameters:
  subagent_type: spec-reviewer-test
  prompt: Review the spec file at: $ARGUMENTS
  description: Testability review
```

### Step 2: Analyze Review Results

Collect and categorize all findings from the 3 reviewers:

**If Blocker or Major severity issues exist:**
- Architecture issues → Present structural alternatives via AskUserQuestion
- Data design issues → Ask user about data model decisions
- Testability issues → Propose design modifications for testability

Then update the spec and **return to Step 1** (max 5 iterations).

**If only Minor issues or Questions:**
- Add findings to "Technical Considerations" section in the spec
- Proceed to Phase 4

### Step 3: Update Spec
Incorporate review findings and user decisions into the spec file.

---

## Phase 4: Final Confirmation

### Step 1: Summarize Changes
Present to the user in the session:
- What was clarified during interviews
- Key improvements made
- Remaining considerations (Minor severity)

### Step 2: Ask for Final Approval
Use AskUserQuestion:
- "Complete" → Finish the session
- "Continue refining" → Return to Phase 1

### Step 3: Completion
When user approves:
1. Ensure `./ai-docs/` directory exists: `mkdir -p ./ai-docs`
2. Write the final spec to `./ai-docs/spec.md`
3. Report completion with the output file path: `./ai-docs/spec.md`

---

## Loop Control

- **Maximum iterations per phase**: 5 (prevent infinite loops)
- **Exit condition**: No Blocker/Major severity issues AND user approval
- **On max iterations**: Present remaining issues and ask user to approve or defer

### Iteration Tracking
Track the current iteration count for each phase:
- Phase 2: `requirement_review_iteration` (1-5)
- Phase 3: `technical_review_iteration` (1-5)

When max iterations reached:
1. List all remaining Blocker/Major issues
2. Ask user via AskUserQuestion:
   - "Approve with known issues" → Document and proceed
   - "Defer to next session" → Save current state and end
