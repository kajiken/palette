---
name: issue-to-implementation
description: Implements GitHub Issues using TDD and creates PRs. Use when user provides a GitHub Issue URL, says "implement issue #123", "fix issue", or wants to start feature/bug work from GitHub Issues. Runs tests first, reviews code, and opens PR automatically.
metadata:
  short-description: Implement GitHub Issue with TDD and create PR
---

# Issue to Implementation

Implement a GitHub Issue using strict test-first TDD, automated code review, and PR creation.

## Prerequisites

- `gh` CLI authenticated: `gh auth status`
- `/code-review` skill available
- `/commit-push-pr` skill available

## Input

- `issue_url`: GitHub Issue URL (required)
  - Example: `https://github.com/owner/repo/issues/123`

## Quick Start

```
/issue-to-implementation https://github.com/owner/repo/issues/123
```

## Workflow

### 1) Prepare Local Repository

Ensure working on latest main branch before starting:

```bash
# Switch to main branch
git checkout main

# Pull latest changes from remote
git pull origin main
```

If there are uncommitted changes, ask user how to proceed (stash, commit, or discard).

### 2) Verify gh Authentication

```bash
gh auth status
```

If not authenticated, ask user to run `gh auth login`.

### 3) Fetch Issue

```bash
gh issue view "https://github.com/owner/repo/issues/123"
# Or with structured output:
gh issue view 123 --repo owner/repo --json title,body,labels,milestone,assignees
```

Parse issue content using patterns in `references/issue-parsing.md`:
- Extract requirements and acceptance criteria
- Identify technical details and constraints
- Note ambiguities - ask user for clarification

### 4) Read Repository Guidelines

Check and read if present:
- `CLAUDE.md` - AI development guidelines
- `docs/**/*.md` - Project documentation
- `CONTRIBUTING.md` - Contribution guidelines
- `.github/PULL_REQUEST_TEMPLATE.md` - PR template

Extract coding standards, test patterns, commit conventions.

### 5) Create Implementation Plan

Present plan to user for approval:

```markdown
## Implementation Plan for Issue #123

### Requirements
- [Requirement 1]
- [Requirement 2]

### Test List
Work through one at a time using RED-GREEN-REFACTOR:
- [ ] Test: [requirement 1 - happy path]
- [ ] Test: [requirement 1 - edge case]
- [ ] Test: [requirement 2 - happy path]
- [ ] Test: [error handling]

### Implementation Steps
1. [File/component to modify]
2. [Changes to make]

### Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]

Proceed with this plan? [Y/N]
```

### 6) Verify Test Framework

Detect test runner from project configuration:

| File | Test Command |
|------|--------------|
| `package.json` with jest | `npm test` or `npx jest` |
| `package.json` with vitest | `npm test` or `npx vitest` |
| `pyproject.toml` with pytest | `pytest` |
| `go.mod` | `go test ./...` |
| `Cargo.toml` | `cargo test` |

**If no test framework detected:**

1. Ask user: "No test framework found. Which do you want to use?"
2. Suggest based on language:
   - JavaScript/TypeScript: Jest or Vitest
   - Python: pytest
   - Go: built-in `testing` package
   - Rust: built-in `#[test]`
3. Help set up minimal test configuration if needed
4. Do not proceed until tests can be run

### 7) TDD Implementation Cycle

Follow strict TDD from `references/tdd-workflow.md`:

#### For each test in Test List:

**RED** - Write failing test first:
1. Pick one test from Test List
2. Write test (start with assert, work backwards)
3. Run tests
4. **Verify test FAILS** - read the failure message
5. Do NOT proceed until test fails

**GREEN** - Minimal implementation:

Choose strategy based on confidence:
- **Fake It**: Return hardcoded value, generalize later
- **Triangulation**: Add second test to force generalization
- **Obvious**: Implement directly if confident

Rules:
1. Write minimum code to pass test
2. Run tests
3. Verify test PASSES
4. No extra functionality

**REFACTOR** - Apply Tidyings (from Kent Beck's "Tidy First?"):

Apply as needed:
- Guard Clauses, Dead Code, Normalize Symmetries
- Reading/Cohesion Order, Explaining Variables/Constants
- Extract Helper, Chunk Statements, etc.

See `references/tdd-workflow.md` for full Tidyings checklist.

Rules:
1. Apply one tidying at a time
2. Run tests after each change
3. All tests must still pass
4. **Commit tidyings separately** from behavior changes

Repeat for all tests in Test List.

### 8) Code Review Loop

Run code review:

```
/code-review
```

Handle feedback per `references/review-criteria.md`:
- **Minor issues** (style, typos, imports): Auto-fix
- **Major issues** (logic, API, security): Ask user

Repeat until review passes (max 5 iterations).

### 9) Commit Strategy

**Strictly separate tidying commits from behavior change commits:**

```
# Commit order example:
1. chore: apply tidyings (guard clauses, dead code removal)
2. test: add tests for feature X
3. feat: implement feature X
4. chore: apply tidyings (extract helper, explaining variables)
5. test: add edge case tests
6. feat: handle edge cases
```

Why separate?
- Tidying commits are low-risk, easy to review
- Behavior commits need careful review
- Easier to revert if issues arise
- Speeds up code review process

### 10) Create PR

After all tests pass and review passes:

```
/commit-push-pr
```

PR should include:
- `Closes #[issue-number]` to link and auto-close issue
- Summary of implementation
- Note which commits are tidyings vs behavior changes
- Test coverage information

## References

- `references/tdd-workflow.md` - TDD cycle with Tidyings (Kent Beck's TDD + Tidy First?)
- `references/issue-parsing.md` - Issue content extraction patterns
- `references/review-criteria.md` - Minor vs major issue classification
