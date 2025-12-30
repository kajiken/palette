---
name: issue-discovery
description: Records discovered problems as issue files. Use proactively when: (1) encountering errors during command execution, (2) finding bugs or security concerns, (3) discovering technical debt or deprecated APIs, (4) noticing performance issues or documentation gaps. Do NOT wait for user request - record issues immediately when problems are detected.
---

# Issue Discovery

Records problems and issues discovered during a session to `./thoughts/issues/`.

## When to Use

- Found a bug or potential problem
- Discovered technical debt (duplicated code, deprecated APIs, design issues)
- Found security concerns
- Discovered performance issues
- Found documentation gaps
- Found insufficient test coverage

## Issue File Creation Steps

### Step 1: Directory Check
Create `./thoughts/issues/` if it doesn't exist.

### Step 2: Determine Filename
```
{YYYYMMDD}-{HHMMSS}-{category}-{short-title}.md
```
Example: `20251230-143052-bug-null-pointer-in-auth.md`

**Categories**: bug, tech-debt, security, performance, documentation, test, dependency

### Step 3: Create Issue File

Use the following template (in Japanese):

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

## 再現手順
{該当する場合のみ記載}

## 推奨対応
{どのように対処すべきかの提案}
```

### Step 4: Report to User
```
[Issue 記録] {category}: {title}
- 重大度: {severity}
- ファイル: ./thoughts/issues/{filename}
```

## Severity Criteria

- **High**: Production impact, security vulnerabilities, data loss risk
- **Medium**: Future problems, performance concerns, maintainability issues
- **Low**: Documentation improvements, code style, refactoring opportunities

## Notes

- Keep it brief to avoid disrupting the main task
- Avoid duplicate entries by checking existing issues
- Only record confirmed problems, not speculation
- Write issue content in Japanese
