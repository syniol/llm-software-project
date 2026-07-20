# PR Preparation — Standard Operating Procedure

> **Purpose:** Ensure every pull request meets a consistent quality bar before requesting human review. This checklist is mandatory — no step may be skipped without explicit justification documented in the PR description.

---

## Pre-Flight Checklist

### Step 1: Lint and Format

**Action:** Run the project linter and auto-formatter. Fix all violations before proceeding.

```bash
# JavaScript/TypeScript
npx eslint . --fix
npx prettier --write .

# Python
ruff check --fix .
ruff format .

# Go
gofmt -w .
golangci-lint run --fix
```

**Gate:** Zero lint errors. Zero warnings unless explicitly suppressed with an inline justification comment.

**Why:** Lint violations in PRs waste reviewer time on style issues instead of logic. Automated formatting eliminates subjective debates.

---

### Step 2: Run Full Test Suite

**Action:** Execute the complete test suite. All tests must pass.

```bash
# JavaScript/TypeScript
npm test -- --coverage

# Python
pytest --tb=short --strict-markers -q

# Go
go test ./... -race -count=1
```

**Gate:** 100% pass rate. No skipped tests unless they are marked with a tracked issue reference (e.g., `@skip("See #1234")`).

**Why:** A failing test suite means the change either broke existing behaviour or the tests themselves are unreliable. Both must be resolved before review.

**If tests fail:**
1. Fix the root cause in your code
2. If the test itself is wrong, fix the test and explain in the PR description
3. Never delete a failing test to make the suite pass

---

### Step 3: Resolve TODO / FIXME Comments

**Action:** Search for `TODO`, `FIXME`, `HACK`, and `XXX` comments in changed files.

```bash
git diff --name-only origin/main | xargs grep -n 'TODO\|FIXME\|HACK\|XXX' || echo "None found"
```

**Gate:** No unresolved TODOs in new or modified code unless they reference a tracked issue.

**Acceptable:**
```python
# TODO(#4521): Migrate to streaming API in Q3
```

**Not acceptable:**
```python
# TODO: fix this later
# FIXME: not sure why this works
```

**Why:** Untracked TODOs are promises nobody keeps. They accumulate into technical debt that becomes invisible.

---

### Step 4: Secret and Credential Scan

**Action:** Verify no secrets, API keys, tokens, passwords, or `.env` values are included in the diff.

```bash
# Using gitleaks
gitleaks detect --source . --verbose

# Manual check
git diff --cached | grep -iE '(password|secret|api_key|token|private_key|AWS_|STRIPE_)' || echo "Clean"

# Verify .env is gitignored
git ls-files --error-unmatch .env 2>/dev/null && echo "WARNING: .env is tracked!" || echo ".env is safe"
```

**Gate:** Zero secrets detected. Any flagged item must be a verified false positive with documentation.

**If a secret was committed:**
1. **Do not simply delete it from the next commit** — it's already in git history
2. Rotate the secret immediately
3. Use `git filter-branch` or `BFG Repo-Cleaner` to purge from history
4. Notify the security team

---

### Step 5: Update CHANGELOG.md

**Action:** Add an entry under the `[Unreleased]` section following [Keep a Changelog](https://keepachangelog.com/) format.

```markdown
## [Unreleased]

### Added
- User profile avatar upload with image validation (#892)

### Fixed
- Race condition in webhook delivery retry logic (#887)

### Changed
- Upgraded `axios` from 1.6.2 to 1.7.4 to resolve CVE-2024-39338
```

**Gate:** CHANGELOG.md has a new entry that accurately describes the user-facing impact of this change.

**Why:** Changelogs are for humans, not machines. Every PR that changes behaviour visible to users, operators, or API consumers must be documented.

---

### Step 6: Write PR Title (Conventional Commits)

**Action:** Write a PR title following the [Conventional Commits](https://www.conventionalcommits.org/) specification.

**Format:**
```
<type>(<scope>): <concise description>
```

**Examples:**
```
feat(auth): add TOTP-based two-factor authentication
fix(api): prevent duplicate webhook deliveries on retry
refactor(db): extract connection pool configuration to module
docs(readme): add local development setup instructions
perf(search): add composite index for full-text queries
chore(deps): upgrade Next.js from 14.1 to 14.2
ci(deploy): add staging environment smoke test step
```

**Gate:** Title follows the format. Type is accurate. Description is specific enough to understand the change without reading the diff.

---

### Step 7: Generate PR Description

**Action:** Write a PR description covering what changed, why, and how to verify.

**Required sections:**

```markdown
## Summary
One-paragraph explanation of the change.

## Motivation
Why this change is needed. Link to the issue, bug report, or product requirement.

## Changes Made
Bulleted list of specific changes:
- Added `UserAvatarUpload` component with client-side image validation
- Created `POST /api/v1/users/:id/avatar` endpoint with 5MB size limit
- Added migration `20240715_add_avatar_url_to_users`

## Testing Done
How this was verified:
- [ ] Unit tests added for image validation (JPEG, PNG, WebP)
- [ ] Integration test for upload endpoint with valid and oversized files
- [ ] Manual test: uploaded avatar appears in profile page and comment threads

## Breaking Changes
None — or describe what breaks and the migration path.
```

**Gate:** Description is complete, accurate, and a reviewer can understand the full context without asking clarifying questions.

---

## Final Verification

Before marking the PR as "Ready for Review," confirm:

- [ ] All 7 steps above are completed
- [ ] CI pipeline is green
- [ ] Branch is rebased on latest `main` (no merge conflicts)
- [ ] PR is assigned to the correct reviewers
- [ ] Labels are applied (e.g., `bug`, `feature`, `breaking-change`)
- [ ] Linked issue is referenced (e.g., `Closes #892`)
