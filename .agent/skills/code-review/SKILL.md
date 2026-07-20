---
name: code-review
description: Step-by-step instructions for performing a structured code review, including the exact checklist, severity classification, and required output format.
---

# Code Review Skill

Use this skill when asked to review a diff, PR, or set of changed files. Follow every step in order. Do not skip sections.

## Step 1: Establish Context

Before reviewing any code, read the following in order:
1. The PR description (or task description if reviewing locally).
2. `.agent/context/CODEBASE-MAP.md` to understand where the changed files fit.
3. Any referenced ADRs in `.agent/context/adr/` if the change touches architecture.

## Step 2: Run the Checklist

For every changed file, evaluate each category below. Log every finding with a severity level.

### Security (`persona: security-auditor`)
- [ ] No hardcoded secrets, tokens, or credentials.
- [ ] All user input validated at the boundary (Zod schema present).
- [ ] No raw SQL string concatenation.
- [ ] No `dangerouslySetInnerHTML` or equivalent without justification.
- [ ] Auth/authorisation middleware applied to all new routes.

### Correctness
- [ ] Does the logic match the stated intent of the PR?
- [ ] Are edge cases handled (empty arrays, null values, concurrent requests)?
- [ ] Are errors caught and handled, not silently swallowed?

### Architecture
- [ ] Does the change respect layer boundaries (controller → service → repository)?
- [ ] Is there any circular dependency introduced?
- [ ] Does it contradict any accepted ADR?

### Testing
- [ ] Are new behaviours covered by unit tests?
- [ ] Do tests follow the `should_X_when_Y` naming convention?
- [ ] Is coverage maintained above 80%?

### Code Style
- [ ] Does the code follow `.agent/rules/02-code-style.md`?
- [ ] Are there any TODO/FIXME comments without a ticket reference?

## Step 3: Classify & Report Findings

Use this exact output format:

```
## Code Review Summary

**Files Reviewed:** <count>
**Overall Assessment:** APPROVED | APPROVED WITH COMMENTS | CHANGES REQUESTED

### Findings

| Severity | File | Line | Issue | Recommendation |
|----------|------|------|-------|----------------|
| 🔴 Critical | auth/service.ts | 42 | JWT not validated before use | Add `verifyToken()` call before accessing `req.user` |
| 🟡 Warning  | user/controller.ts | 18 | Missing input validation | Add Zod schema for `req.body` |
| 🔵 Note     | shared/utils.ts | 7 | Minor naming inconsistency | Rename `getData` to `fetchUserById` for clarity |
```

## Severity Definitions

| Severity | Meaning | Blocks Merge? |
|----------|---------|---------------|
| 🔴 Critical | Security vulnerability or data loss risk | Yes |
| 🟠 High | Logic bug or significant architecture violation | Yes |
| 🟡 Warning | Code smell, missing test, style issue | Recommended fix |
| 🔵 Note | Suggestion or minor improvement | No |
