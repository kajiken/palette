# Issue Parsing Patterns

Extract structured information from GitHub Issue content.

## Information to Extract

### Required

| Field | Description | Look For |
|-------|-------------|----------|
| Title | Issue summary | Issue title |
| Goal | What to achieve | "Goal:", "Objective:", first paragraph |
| Requirements | What to build | "Requirements:", bullet lists, numbered lists |
| Acceptance Criteria | Definition of done | "Acceptance Criteria:", "AC:", checkboxes |

### Optional

| Field | Description | Look For |
|-------|-------------|----------|
| Technical Details | Implementation hints | "Technical:", code blocks, API specs |
| Constraints | Limitations | "Constraints:", "Must not:", "Avoid:" |
| Related Issues | Dependencies | "#123", "Depends on:", "Blocks:" |
| Priority | Urgency | Labels (P0, P1, critical, high) |

## Common Issue Formats

### Feature Request

```markdown
## Summary
[Brief description]

## Requirements
- Requirement 1
- Requirement 2

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
```

### Bug Report

```markdown
## Description
[Bug description]

## Steps to Reproduce
1. Step 1
2. Step 2

## Expected Behavior
[What should happen]

## Actual Behavior
[What happens instead]
```

### Task/Implementation

```markdown
## Goal
[What to implement]

## Technical Approach
[How to implement]

## Subtasks
- [ ] Subtask 1
- [ ] Subtask 2
```

## Handling Ambiguity

### Missing Requirements

If requirements are unclear:

1. List what's understood
2. List specific questions
3. Ask user for clarification before proceeding

```markdown
## Understood Requirements
- [Clear requirement 1]
- [Clear requirement 2]

## Questions
- [Specific question about unclear aspect]
- [Question about edge case]
```

### Missing Acceptance Criteria

If no explicit criteria:

1. Derive from requirements
2. Propose criteria to user
3. Get confirmation before implementing

### Conflicting Information

If issue contains conflicts:

1. Identify the conflict
2. Present both interpretations
3. Ask user which is correct

## Extraction Checklist

Before starting implementation:

- [ ] Goal/objective is clear
- [ ] All functional requirements identified
- [ ] Acceptance criteria defined (explicit or derived)
- [ ] Technical constraints noted
- [ ] Ambiguities resolved with user
- [ ] Dependencies identified
