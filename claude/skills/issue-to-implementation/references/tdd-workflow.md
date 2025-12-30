# TDD Workflow (Test-Driven Development)

Strict test-first development based on Kent Beck's "Test-Driven Development: By Example".

**Goal**: Clean code that works.

## Test List (Before Coding)

Before writing any code, create a list of all tests you need:

```markdown
## Test List
- [ ] Happy path for requirement 1
- [ ] Edge case: empty input
- [ ] Edge case: boundary values
- [ ] Error case: invalid input
- [ ] Integration: component interaction
```

Work through this list one test at a time. Add new tests as you discover them.

## The TDD Cycle

### 1. RED: Write a Failing Test First

Before writing any implementation code:

1. Pick one test from your Test List
2. Write a test that describes the expected behavior
3. **Write assert first** - start from the end result, work backwards
4. Run the test
5. **Verify it FAILS** - This is mandatory
6. **Read the failure message** - it guides your implementation

```
# Test must fail before proceeding
Run tests -> Expect FAILURE -> Continue to GREEN
Run tests -> Passes -> STOP - requirement may already be met or test is wrong
```

### 2. GREEN: Minimal Implementation

Write the minimum code to make the test pass. Choose a strategy based on confidence:

#### Strategy 1: Fake It ('Til You Make It)
When uncertain, start with hardcoded values:
```python
# Test expects: add(1, 2) == 3
def add(a, b):
    return 3  # Fake it first
```
Then generalize through more tests.

#### Strategy 2: Triangulation
When unsure how to generalize:
1. First test passes with fake implementation
2. Write second test that forces generalization
3. Only generalize when you have two or more examples

```python
# Test 1: add(1, 2) == 3 -> return 3
# Test 2: add(2, 3) == 5 -> now must generalize to: return a + b
```

#### Strategy 3: Obvious Implementation
When confident and simple:
1. Write the real implementation directly
2. If test fails unexpectedly, fall back to Fake It

**Rules**:
1. Implement only what's needed to pass the test
2. Run the test
3. **Verify it PASSES**
4. Do not add extra functionality

### 3. REFACTOR: Improve Code Quality

With passing tests as safety net, apply **Tidyings** (from Kent Beck's "Tidy First?"):

#### Tidyings Checklist

Apply as needed during refactoring:

| Tidying | When to Apply |
|---------|---------------|
| **Guard Clauses** | Nested if-statements → early returns |
| **Dead Code** | Unused/commented code → delete |
| **Normalize Symmetries** | Same logic written differently → unify |
| **Reading Order** | Code hard to follow → reorder logically |
| **Cohesion Order** | Related code scattered → move together |
| **Move Declaration & Initialization** | Separated → make adjacent |
| **Explaining Variables** | Complex expression → named variable |
| **Explaining Constants** | Magic numbers → named constants |
| **Explicit Parameters** | Dict/map params → named parameters |
| **Chunk Statements** | Wall of code → group with blank lines |
| **Extract Helper** | Repeated/complex logic → function |
| **One Pile** | Over-abstracted → temporarily inline, then restructure |
| **Explaining Comments** | Non-obvious intent → add comment |
| **Delete Redundant Comments** | Obvious comments → delete |

#### Refactoring Rules

1. Apply tidyings one at a time
2. Run tests after **each small change**
3. **All tests must still pass**
4. If tests fail, undo and take smaller steps
5. **Commit tidyings separately** from behavior changes

## Test Discovery

Detect test runner from project configuration:

| File | Test Command |
|------|--------------|
| `package.json` with jest | `npm test` or `npx jest` |
| `package.json` with vitest | `npm test` or `npx vitest` |
| `pyproject.toml` with pytest | `pytest` |
| `Makefile` with test target | `make test` |
| `.github/workflows/*.yml` | Check CI test commands |
| `go.mod` | `go test ./...` |
| `Cargo.toml` | `cargo test` |

## Test Types (Priority Order)

1. **Unit Tests** - Test individual functions/methods
2. **Integration Tests** - Test component interactions
3. **E2E Tests** - Test complete user flows

Focus on unit tests first, add integration/E2E as needed.

## Checklist Per Feature

For each requirement:

- [ ] Test written BEFORE implementation
- [ ] Test execution shows FAILURE before implementation
- [ ] Minimal code written to pass test
- [ ] Test execution shows PASS after implementation
- [ ] Code refactored with tests still passing
- [ ] Edge cases covered with additional tests

## Anti-Patterns to Avoid

- Writing implementation before test
- Writing test that passes immediately (without implementation)
- Skipping the "verify failure" step
- Adding functionality not required by tests
- Refactoring without running tests
- Taking steps too large (if stuck, take smaller steps)
- Removing tests (tests are your safety net)

## Step Size

Take steps as small as needed to feel confident:

- **Feeling confident?** → Take larger steps (Obvious Implementation)
- **Feeling uncertain?** → Take smaller steps (Fake It)
- **Test failed unexpectedly?** → Back up, take even smaller steps

Kent Beck: "How much feedback do you need? The more uncertain you are, the smaller the steps."

## Reference

Based on Kent Beck's works:

### "Test-Driven Development: By Example" (2002)
- "Clean code that works" - the goal of TDD
- Tests manage fear; fear leads to tentative, poorly thought-out code
- Work in small, verified steps
- Remove duplication as the primary driver of design

### "Tidy First?" (2023)
- Tidyings: small structural changes that don't change behavior
- Constantine's Equivalence: cost of software ≈ coupling
- Separate tidying commits from behavior change commits
- Tidying creates options for future changes
