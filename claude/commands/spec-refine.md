---
description: Refine a spec file through interview and Codex review loops (user)
argument-hint: [spec-file-path]
allowed-tools: AskUserQuestion, Read, Write, Edit, Task
---

## Task

Read the spec file at `$ARGUMENTS`, conduct an in-depth interview to refine requirements, and iteratively improve the spec using Codex MCP reviews until it reaches a complete state.

## Workflow Overview

```
Interview → Update Spec → Codex Review → Analyze Results → Repeat or Complete
```

---

## Phase 1: Initial Interview

### Step 1: Read and Understand
Read the spec file at `$ARGUMENTS` and analyze its current state.

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

## Phase 2: Codex Review Loop

### Step 1: Launch Parallel Agent Reviews

Launch **4 custom agent reviews in parallel** using `Task` tool.

**IMPORTANT**: Call all 4 Task tools in a single message for parallel execution.

#### Reviewer 1: Technical Feasibility
```
Task tool parameters:
  subagent_type: spec-reviewer-technical
  prompt: Review the spec file at: $ARGUMENTS
  description: Technical feasibility review
```

#### Reviewer 2: Requirements Completeness
```
Task tool parameters:
  subagent_type: spec-reviewer-requirements
  prompt: Review the spec file at: $ARGUMENTS
  description: Requirements completeness review
```

#### Reviewer 3: Security
```
Task tool parameters:
  subagent_type: spec-reviewer-security
  prompt: Review the spec file at: $ARGUMENTS
  description: Security review
```

#### Reviewer 4: Testability
```
Task tool parameters:
  subagent_type: spec-reviewer-testability
  prompt: Review the spec file at: $ARGUMENTS
  description: Testability review
```

### Step 2: Analyze Review Results

Collect and categorize all findings:

**If High severity issues exist:**
- Requirements ambiguity → Ask user via AskUserQuestion
- Technical problems → Present alternatives via AskUserQuestion
- Security concerns → Add notes to spec + confirm with user
- Test gaps → Propose strategy + confirm with user

Then update the spec and **return to Step 1** (max 5 iterations).

**If only Medium/Low issues:**
- Add a "Considerations" section to the spec
- Proceed to Phase 3

---

## Phase 3: Final Confirmation

### Step 1: Summarize Changes
Present to the user in the session:
- What was clarified during interviews
- Key improvements made
- Remaining considerations (Medium/Low)

### Step 2: Ask for Final Approval
Use AskUserQuestion:
- "Complete" → Finish the session
- "Continue refining" → Return to Phase 1

### Step 3: Completion
When user approves:
- Confirm the spec file has been updated with all refinements
- Report the final status in the session (no file output)

---

## Loop Control

- **Maximum iterations**: 5 (prevent infinite loops)
- **Exit condition**: No High severity issues AND user approval
- **On max iterations**: Present remaining issues and ask user to approve or defer
