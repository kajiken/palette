---
description: Save session summary for handoff to next session
allowed-tools: Bash(mkdir:*), Bash(ls:*), Write, AskUserQuestion
---

## Task

Save the current session's work to a handoff file for the next session.

## Workflow

### Step 1: Prepare Directory

Ensure `./docs/handoffs/` directory exists:

```bash
mkdir -p ./docs/handoffs
```

### Step 2: Analyze Session

Review the entire conversation and extract:

1. **Summary**: What was accomplished in this session
2. **Changes**: Files modified, created, or deleted
3. **Decisions**: Important design decisions and their rationale
4. **Open Issues**: Unresolved problems or pending tasks

### Step 3: Generate Filename

Create a descriptive filename based on the session's main topic:
- Use kebab-case (lowercase with hyphens)
- Keep it concise but descriptive
- Examples: `implement-auth-feature.md`, `fix-performance-issues.md`, `refactor-api-layer.md`

### Step 4: Confirm with User

Present the handoff content to the user via `AskUserQuestion`:
- Show the proposed filename
- Show a preview of the content
- Options: "Save", "Edit filename", "Cancel"

If user selects "Edit filename", ask for the new filename and confirm again.

### Step 5: Save File

Write the handoff file to `./docs/handoffs/{filename}.md` using this format:

```markdown
# Session Handoff: {Title}

Date: {YYYY-MM-DD}

## Summary

{Brief description of what was accomplished}

## Changes

### Files Modified
- `path/to/file` - {what changed}

### Files Created
- `path/to/file` - {purpose}

### Files Deleted
- `path/to/file` - {reason}

## Decisions

- **{Decision}**: {Rationale and context}

## Open Issues

- [ ] {Issue or pending task}

## Next Steps

- {Recommended next action}
```

### Step 6: Complete

Report:
- Saved file path
- Summary of what was captured
