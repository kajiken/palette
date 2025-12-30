# Review Criteria: Minor vs Major Issues

Determine whether to auto-fix or ask user for confirmation.

## Minor Issues (Auto-Fix)

Fix these automatically without user confirmation:

### Code Style
- Indentation fixes
- Whitespace adjustments
- Line length formatting
- Trailing whitespace removal
- Consistent quote style

### Imports
- Import ordering
- Removing unused imports
- Adding missing imports (obvious cases)

### Naming (Cosmetic)
- Typo fixes in variable names
- Consistent naming convention (camelCase, snake_case)

### Comments
- Typo fixes in comments
- Minor wording improvements
- Adding obvious documentation

### Cleanup
- Removing unused variables
- Removing dead code (clearly unreachable)
- Removing debug statements (console.log, print)

## Major Issues (User Confirmation Required)

Ask user before fixing:

### Logic Changes
- Algorithm modifications
- Control flow changes
- Business logic adjustments
- Error handling changes

### API/Interface Changes
- Function signature changes
- Return type modifications
- Adding/removing parameters
- Changing public interfaces

### Architecture
- File/module restructuring
- Adding new dependencies
- Changing design patterns
- Database schema changes

### Security
- Authentication/authorization changes
- Input validation modifications
- Encryption/hashing changes
- Permission changes

### Tests
- Adding new test cases (may expand scope)
- Removing test cases → **REFUSE** (tests are safety net in TDD)
- Changing test assertions
- Modifying test fixtures

### Performance
- Algorithm complexity changes
- Caching modifications
- Database query changes
- Resource allocation changes

## Confirmation Template

When asking user about major issues:

```markdown
## Review Found Major Issue

### Issue
[Description of the issue]

### Suggested Fix
[Proposed solution]

### Impact
[What this change affects]

### Alternatives
[Other approaches if applicable]

Proceed with this fix? [Y/N]
```

## Decision Flow

```
Is it code style/formatting? -> Auto-fix
Is it import organization? -> Auto-fix
Is it a typo fix? -> Auto-fix
Is it removing clearly unused code? -> Auto-fix

Does it change behavior? -> Ask user
Does it affect API/interface? -> Ask user
Is it security-related? -> Ask user
Does it add new tests? -> Ask user
Does it remove tests? -> REFUSE (tests are safety net)
Does it change test assertions? -> Ask user
```

## Max Iterations

- Auto-fix loop: max 5 iterations
- If issues persist after 5 iterations, escalate to user
