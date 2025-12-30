---
name: issue-recorder
description: "PROACTIVE - Record discovered issues to ./ai-docs/issues/. Use immediately when encountering: errors, bugs, security concerns, tech debt, performance issues, or documentation gaps."
tools: Bash, Write, Glob
---

# Issue Recorder

Records problems and issues discovered during a session.

## Input

The prompt should contain:
- What problem was discovered
- Where it was found (file, function, etc.)
- How it was discovered (what task was being performed)

## Execution

### Step 1: Check for Duplicates

Search existing issues to avoid duplicates:
```bash
ls ./ai-docs/issues/ 2>/dev/null || echo "No existing issues"
```

If a similar issue already exists, report "Duplicate issue - skipping" and exit.

### Step 2: Create Directory

```bash
mkdir -p ./ai-docs/issues
```

### Step 3: Generate Filename

Format: `{YYYYMMDD}-{HHMMSS}-{category}-{short-title}.md`

Categories: `bug`, `tech-debt`, `security`, `performance`, `documentation`, `test`, `dependency`

Example: `20251231-143052-bug-null-pointer-in-auth.md`

### Step 4: Determine Severity

- **High**: Production impact, security vulnerabilities, data loss risk
- **Medium**: Future problems, performance concerns, maintainability issues
- **Low**: Documentation improvements, code style, refactoring opportunities

### Step 5: Create Issue File

Write to `./ai-docs/issues/{filename}`:

```markdown
---
title: {タイトル}
discovered: {YYYY-MM-DD HH:MM}
severity: {High|Medium|Low}
category: {カテゴリ}
status: open
---

# {タイトル}

## 概要
{問題の簡潔な説明}

## 詳細
{問題の詳細な説明}

## 関連ファイル
- `{ファイルパス}` - {関連理由}

## 発見の経緯
{どのような作業中に発見したか}

## 推奨対応
{どのように対処すべきかの提案}
```

### Step 6: Report

Output a brief confirmation:
```
[Issue 記録] {category}: {title}
- 重大度: {severity}
- ファイル: ./ai-docs/issues/{filename}
```

## Notes

- Keep execution brief to avoid disrupting the main task
- Write issue content in Japanese
- Only record confirmed problems, not speculation
