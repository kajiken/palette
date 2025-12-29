---
description: Review a spec file from multiple perspectives using Codex MCP
argument-hint: [spec-file-path]
allowed-tools: Task, Read, Write, Bash(mkdir:*)
---

## Task

Review the spec file at `$ARGUMENTS` using multiple Codex MCP sessions in parallel, each focusing on a different review perspective. Generate a comprehensive review report in the `feedback/` directory.

## Workflow

### Step 1: Read the Spec File

First, read and understand the spec file content at the provided path.

### Step 2: Launch Parallel Agent Review Sessions

Launch **4 custom agent reviews in parallel** using `Task` tool. Each agent reviews the spec from a specific perspective.

**IMPORTANT**: You MUST call all 4 `Task` tools in a single message to run them in parallel.

#### Reviewer 1: Technical Feasibility Reviewer
```
Task tool parameters:
  subagent_type: spec-reviewer-technical
  prompt: Review the spec file at: $ARGUMENTS
  description: Technical feasibility review
```

#### Reviewer 2: Requirements Completeness Reviewer
```
Task tool parameters:
  subagent_type: spec-reviewer-requirements
  prompt: Review the spec file at: $ARGUMENTS
  description: Requirements completeness review
```

#### Reviewer 3: Security Reviewer
```
Task tool parameters:
  subagent_type: spec-reviewer-security
  prompt: Review the spec file at: $ARGUMENTS
  description: Security review
```

#### Reviewer 4: Testability Reviewer
```
Task tool parameters:
  subagent_type: spec-reviewer-testability
  prompt: Review the spec file at: $ARGUMENTS
  description: Testability review
```

### Step 3: Collect and Synthesize Results

After all agent reviews complete:
1. Collect feedback from each reviewer
2. Remove duplicates and consolidate similar findings
3. Sort by severity (High > Medium > Low)

### Step 4: Generate Review Report

1. Create the `feedback/` directory if it doesn't exist:
   ```
   mkdir -p feedback
   ```

2. Write the review report to `feedback/{spec-filename}-review.md` with this structure:

```markdown
# Spec Review Report: {spec-filename}

**Reviewed:** {current date}
**Spec Path:** {original spec path}

## Summary

{Brief overall assessment - 2-3 sentences highlighting the most critical findings}

## Technical Feasibility

{Findings from Technical Feasibility Reviewer}

## Requirements Completeness

{Findings from Requirements Completeness Reviewer}

## Security Concerns

{Findings from Security Reviewer}

## Testability

{Findings from Testability Reviewer}

## Recommendations

### High Priority
{List of high severity items that should be addressed before implementation}

### Medium Priority
{List of medium severity items to consider}

### Low Priority
{List of low severity items for future improvement}
```

## Completion

Report the location of the generated review file to the user.
