# Issue to Implementation Skill Evaluations

Evaluation scenarios for testing the issue-to-implementation skill.

## Purpose

These evaluations ensure the skill:
- Fetches and parses GitHub Issues correctly
- Follows strict TDD based on Kent Beck's "TDD By Example"
- Uses Test List, Fake It, Triangulation, and Obvious strategies
- Applies Tidyings from Kent Beck's "Tidy First?" during REFACTOR
- Strictly separates tidying commits from behavior change commits
- Integrates with /code-review skill properly
- Creates PRs with /commit-push-pr skill
- Handles minor/major review issues appropriately
- Refuses to remove tests (safety net principle)

## Evaluation Files

### basic-feature.json

Tests the complete workflow from Issue to PR.

**Scenario**: Implement a feature from GitHub Issue
**Key Behaviors**:
- Fetches Issue with gh CLI
- Reads repository guidelines
- Presents implementation plan for approval
- Writes tests BEFORE implementation
- Verifies tests fail before implementing
- Runs /code-review
- Auto-fixes minor issues, confirms major issues
- Creates PR with /commit-push-pr

### tdd-cycle.json

Tests strict TDD cycle adherence.

**Scenario**: Verify RED-GREEN-REFACTOR cycle
**Key Behaviors**:
- Each test written before implementation
- Each test verified to fail
- Minimal implementation to pass
- Refactoring with tests still passing

## Running Evaluations

1. Enable the `issue-to-implementation` skill
2. Submit the query from the evaluation file
3. Verify each expected behavior step
4. Check success criteria are met

## Success Criteria Definitions

**Good** (specific, testable):
- "Test execution shows FAILURE before implementation code is written"
- "/code-review is invoked after implementation complete"
- "PR body contains 'Closes #[number]'"

**Bad** (vague, untestable):
- "Tests are written properly"
- "TDD is followed"
- "PR is created correctly"
