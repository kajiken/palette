---
allowed-tools: Bash(git checkout:*), Bash(git branch:*), Bash(git add:*), Bash(git status:*), Bash(git push:*), Bash(git commit:*), Bash(git diff:*), Bash(git log:*), Bash(gh pr create:*), Bash(cat:*), AskUserQuestion
description: Commit, push, and open a PR
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits (for style reference): !`git log --oneline -5`
- PR template: !`cat .github/pull_request_template.md 2>/dev/null || echo "No PR template found"`

## Your Task

Based on the above changes, create commits, push, and open a pull request. Follow these steps:

### Step 1: Pre-checks

1. If there are no changes at all (no staged or unstaged changes), display an error message and stop.
2. If there are only unstaged changes (no staged changes), use AskUserQuestion to ask the user which files to add before proceeding.

### Step 2: Branch Creation (if on main/master)

If currently on `main` or `master` branch:
1. Analyze the changes and auto-generate an appropriate branch name using the format:
   - `feature/<description>` for new features
   - `fix/<description>` for bug fixes
   - `docs/<description>` for documentation
   - `refactor/<description>` for refactoring
   - `chore/<description>` for maintenance tasks
2. Check if a remote branch with the same name already exists. If it does, display an error and stop.
3. Create and checkout the new branch.

### Step 3: Analyze and Plan Commits

Analyze the changes and split them into logical units. Each commit should represent a single logical change. Use Conventional Commits format:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `style:` for formatting changes
- `refactor:` for code refactoring
- `test:` for adding/updating tests
- `chore:` for maintenance tasks

Each commit message should end with:
```

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

### Step 4: Confirmation Phase

Before executing, display to the user:
1. The list of commits to be created (with messages)
2. The PR title (auto-generated from changes)
3. The PR description preview

Use AskUserQuestion to get user confirmation before proceeding.

### Step 5: Execute

After user approval:
1. Stage the appropriate files and create commits as planned
2. Push the branch to origin with `-u` flag
3. Create a pull request using `gh pr create`:
   - If `.github/pull_request_template.md` exists, the template will be used automatically
   - Otherwise, create a simple description summarizing the changes
   - Use a HEREDOC for the PR body to ensure correct formatting

### Step 6: Result Display

After successful completion, display:
1. The PR URL
2. A summary of all commits that were created

## Important Notes

- Use HEREDOC format for commit messages and PR body to ensure proper formatting
- Never skip the confirmation phase
- If any step fails, display a clear error message
- Do not use any tools other than the ones specified in allowed-tools
