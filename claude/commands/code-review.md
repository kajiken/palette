---
description: Review uncommitted code changes from multiple perspectives using Codex /review
allowed-tools: AskUserQuestion, Task, Edit, Write
---

## Task

Review uncommitted code changes (staged, unstaged, and untracked files) from multiple perspectives using specialized reviewer agents. Each agent uses Codex `/review` command with custom review instructions. Findings with confidence >= 80 are reported.

## Workflow

### Step 1: Launch Parallel Code Reviews

Launch **5 specialized reviews in parallel** using `Task` tool.

Each agent will use Codex `/review` command to review uncommitted changes with its own focus area.

**IMPORTANT**: You MUST call all 5 Task tools in a single message for parallel execution.

#### Reviewer 1: Test Coverage
```
Task tool parameters:
  subagent_type: code-reviewer-test-coverage
  prompt: Review uncommitted changes for test coverage quality
  description: Test coverage review
```

#### Reviewer 2: Security
```
Task tool parameters:
  subagent_type: code-reviewer-security
  prompt: Review uncommitted changes for security issues
  description: Security review
```

#### Reviewer 3: Error Handling
```
Task tool parameters:
  subagent_type: code-reviewer-error-handling
  prompt: Review uncommitted changes for error handling quality
  description: Error handling review
```

#### Reviewer 4: Performance
```
Task tool parameters:
  subagent_type: code-reviewer-performance
  prompt: Review uncommitted changes for performance issues
  description: Performance review
```

#### Reviewer 5: Project Guidelines
```
Task tool parameters:
  subagent_type: code-reviewer-project-guidelines
  prompt: Review uncommitted changes for project guidelines compliance
  description: Project guidelines review
```

### Step 2: Analyze Review Results

Collect findings from all 5 reviewers and consolidate:

1. **Extract high-confidence findings** (confidence >= 80)
2. **Categorize by severity**:
   - Blocker (confidence 91-100): Must fix before commit
   - Major (confidence 80-90): Should fix

3. **If Blocker findings exist**:
   - Present findings to user via AskUserQuestion
   - Options: "Fix now", "Acknowledge and continue", "Defer"
   - If "Fix now": Make changes and return to Step 1 (max 5 iterations)

4. **If only Major findings or no findings**:
   - Present summary to user
   - Proceed to Step 3

### Step 3: Completion

Present final review summary:
- Number of issues found per category
- Number of issues fixed
- Remaining considerations

---

## Loop Control

- **Maximum iterations**: 5 (prevent infinite loops)
- **Exit condition**: No Blocker issues AND user approval
- **On max iterations**: Present remaining issues and ask user to approve or defer

### Iteration Tracking

Track the current iteration count:
- `review_iteration` (1-5)

When max iterations reached:
1. List all remaining Blocker/Major issues
2. Ask user via AskUserQuestion:
   - "Approve with known issues" → Document and complete
   - "Defer to next session" → Save current state and end

---

## Output Format

### Per-Reviewer Summary

For each reviewer, display:
```
## [Reviewer Name]

### Findings (Confidence >= 80)
- [Confidence: XX] Issue Title
  Location: file:line
  Impact: ...
  Recommendation: ...

### Excluded (Confidence < 80)
- (brief list)
```

### Final Consolidated Report

```
## Code Review Summary

### Statistics
- Test Coverage: X issues (Y Blocker, Z Major)
- Security: X issues (Y Blocker, Z Major)
- Error Handling: X issues (Y Blocker, Z Major)
- Performance: X issues (Y Blocker, Z Major)
- Project Guidelines: X issues (Y Blocker, Z Major)

### Blockers (Must Fix)
1. [Issue Title] - [Category]
   ...

### Major Issues (Should Fix)
1. [Issue Title] - [Category]
   ...

### Excluded Issues (Low Confidence)
- X issues excluded due to confidence < 80
```
