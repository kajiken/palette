---
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git push:*), Bash(gh pr create:*), Bash(cat:*), AskUserQuestion
description: Push branch and create a Pull Request
---

## Context

- Current git status: !`git status`
- Current branch: !`git branch --show-current`
- Commits ahead of main: !`git log origin/main..HEAD --oneline 2>/dev/null || git log origin/master..HEAD --oneline 2>/dev/null || echo "No commits ahead of main/master"`
- Changes summary: !`git diff origin/main..HEAD --stat 2>/dev/null || git diff origin/master..HEAD --stat 2>/dev/null || echo "No diff from main/master"`
- PR template: !`cat .github/pull_request_template.md 2>/dev/null || echo "No PR template found"`

## Your Task

Based on the above information, push the branch and create a Pull Request. Follow these steps:

### Step 1: Pre-checks

1. If currently on `main` or `master` branch, display an error message and stop (nothing to create PR for).
2. If there are no commits ahead of origin/main (or origin/master), display an error message and stop.
3. If there are uncommitted changes, warn the user and ask if they want to proceed anyway.

### Step 2: Analyze Changes

1. Review all commits since branching from main/master
2. Auto-generate an appropriate PR title based on the commits and changes
3. Generate PR description:
   - If `.github/pull_request_template.md` exists, use it as a base and fill in relevant sections
   - Otherwise, create a simple description summarizing the changes

### Step 3: Confirmation Phase

Before executing, display to the user:
1. The PR title
2. The PR description preview
3. The list of commits that will be included

Use AskUserQuestion to get user confirmation before proceeding.

### Step 4: Execute

After user approval:
1. Push the branch to origin with `-u` flag
2. Create a pull request using `gh pr create`:
   - Use HEREDOC for the PR body to ensure correct formatting
   - Add the Claude Code signature at the end of the body

### Step 5: Result Display

After successful completion, display:
1. The PR URL
2. A summary of included commits

## PR Description Format

If no template exists, use this format:
```
## Summary
<Brief description of what this PR does>

## Changes
<Bullet points of main changes>

## Test Plan
<How to test these changes>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## Important Notes

- Use HEREDOC format for PR body to ensure proper formatting
- Never skip the confirmation phase
- If any step fails, display a clear error message
- The `gh pr create` command will automatically use the PR template if it exists in `.github/pull_request_template.md`
