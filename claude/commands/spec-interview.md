---
description: Interview me about a spec file to refine requirements
argument-hint: [spec-file-path]
allowed-tools: AskUserQuestion, Read, Write, Edit, Bash(mkdir:*)
---

## Task

Read the spec file at `$ARGUMENTS` and conduct an in-depth interview to refine the requirements.

Note: `$ARGUMENTS` can be either a file path or raw text. If it's a file path, read the file. If it's text, treat it as the initial requirements.

## Interview Guidelines

1. First, read and understand the current spec
2. Ask probing questions about:
   - Technical implementation details
   - UI/UX considerations
   - Edge cases and error handling
   - Security concerns
   - Performance tradeoffs
   - Integration points
   - Testing strategy

3. Avoid obvious questions - focus on:
   - Ambiguities in the spec
   - Unstated assumptions
   - Potential conflicts
   - Missing acceptance criteria

4. Use AskUserQuestion with 2-4 focused options per question

## Completion

Continue interviewing until all major areas are covered, then:
1. Summarize what was clarified
2. Ensure `./ai-docs/` directory exists: `mkdir -p ./ai-docs`
3. Write the refined spec to `./ai-docs/spec.md`
4. Report completion with the output file path
