---
description: Review uncommitted code changes using Codex /review
allowed-tools: AskUserQuestion, Task, Edit, Write
---

## Task

Review uncommitted code changes (staged, unstaged, and untracked files) using Codex `/review` command with custom review instructions.

## Workflow

### Step 1: Launch Code Review

Launch the code review using `Task` tool:

```
Task tool parameters:
  subagent_type: code-reviewer
  prompt: Review uncommitted changes
  description: Code review
```

### Step 2: Analyze Review Results

Collect findings and categorize by confidence:
- **91-100**: Blocker (must fix before commit)
- **80-90**: Major (should fix)

**If Blocker findings exist**:
- Present findings to user via AskUserQuestion
- Options: "Fix now", "Acknowledge and continue", "Defer"
- If "Fix now": Make changes and return to Step 1 (max 5 iterations)

**If only Major findings or no findings**:
- Present summary and proceed to completion

### Step 3: Completion

Present final summary:
- Issues found by category
- Issues fixed
- Remaining considerations

---

## Loop Control

- **Maximum iterations**: 5
- **Exit condition**: No Blocker issues AND user approval
- **On max iterations**: Present remaining issues and ask user to approve or defer
