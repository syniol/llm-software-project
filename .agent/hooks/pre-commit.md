# Pre-Commit Hook — Agent Instructions

> **Purpose:** Define the checks an AI agent should run (or recommend running) before every commit. These checks catch issues early — before they enter the git history, CI pipeline, or code review.

---

## Overview

The pre-commit hook enforces four gates, executed in order. If any gate fails, the commit is blocked until the issue is resolved.

```
┌─────────────┐    ┌────────────┐    ┌─────────────┐    ┌──────────────┐
│  Lint Check  │───▶│ Type Check │───▶│ Secret Scan │───▶│ Test Changed │
└─────────────┘    └────────────┘    └─────────────┘    └──────────────┘
     Gate 1             Gate 2            Gate 3             Gate 4
```

---

## Gate 1: Lint Check

**Purpose:** Enforce code style and catch common errors in staged files only.

### JavaScript / TypeScript

```bash
# Lint only staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(js|jsx|ts|tsx)$')

if [ -n "$STAGED_FILES" ]; then
  npx eslint $STAGED_FILES --max-warnings 0
  npx prettier --check $STAGED_FILES
fi
```

### Python

```bash
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.py$')

if [ -n "$STAGED_FILES" ]; then
  ruff check $STAGED_FILES
  ruff format --check $STAGED_FILES
fi
```

### Go

```bash
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.go$')

if [ -n "$STAGED_FILES" ]; then
  gofmt -l $STAGED_FILES | grep -q . && echo "Files need formatting" && exit 1
  golangci-lint run --new-from-rev=HEAD $STAGED_FILES
fi
```

**Pass criteria:** Zero errors, zero warnings (unless explicitly suppressed with justification).

---

## Gate 2: Type Check

**Purpose:** Verify type safety across the project. Type errors that pass lint can still cause runtime failures.

### TypeScript

```bash
npx tsc --noEmit
```

### Python (with type annotations)

```bash
# Type check only changed files for speed
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.py$')

if [ -n "$STAGED_FILES" ]; then
  mypy $STAGED_FILES --ignore-missing-imports --no-error-summary
  # Or with pyright for stricter checking:
  # npx pyright $STAGED_FILES
fi
```

**Pass criteria:** Zero type errors. Type errors in dependencies or unrelated files may be excluded via configuration, not by skipping the check.

**Note:** For TypeScript, `tsc --noEmit` checks the entire project because types flow across files. This is intentional — a change in one file can cause a type error in another.

---

## Gate 3: Secret Scan

**Purpose:** Prevent secrets, API keys, tokens, and credentials from being committed to the repository.

### Using gitleaks (Recommended)

```bash
# Install: brew install gitleaks / go install github.com/gitleaks/gitleaks/v8@latest

# Scan only staged changes (pre-commit mode)
gitleaks protect --staged --verbose --redact
```

### Using detect-secrets (Alternative)

```bash
# Install: pip install detect-secrets

# Scan staged diff
git diff --cached | detect-secrets-hook --baseline .secrets.baseline
```

### Using truffleHog (Alternative)

```bash
# Install: brew install trufflehog / pip install trufflehog

# Scan staged changes
trufflehog git file://. --since-commit HEAD --only-verified
```

### Custom Pattern Check (Fallback)

If no tool is installed, perform a basic regex scan:

```bash
STAGED_DIFF=$(git diff --cached)

# Check for common secret patterns
echo "$STAGED_DIFF" | grep -iE \
  '(AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z\-_]{35}|sk-[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{36}|xox[bprs]-[a-zA-Z0-9\-]+)' \
  && echo "BLOCKED: Potential secret detected in staged changes" && exit 1

# Check for hardcoded credentials
echo "$STAGED_DIFF" | grep -iE \
  '(password|secret|api_key|apikey|token|private_key)\s*[:=]\s*["\x27][^\s"'\'']{8,}' \
  && echo "BLOCKED: Potential hardcoded credential detected" && exit 1
```

**Pass criteria:** Zero findings. False positives must be added to the tool's allowlist (e.g., `.gitleaksignore`) with a comment explaining why.

**If a secret is detected:**
1. **Do not commit.** Remove the secret from the staged files.
2. If the secret was already committed in a previous commit, it must be rotated immediately.
3. Store secrets in a vault (AWS Secrets Manager, HashiCorp Vault, 1Password) and reference via environment variables.

---

## Gate 4: Run Tests for Changed Files

**Purpose:** Run targeted tests for modified code to provide fast feedback without running the full suite.

### JavaScript / TypeScript (Jest)

```bash
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(js|jsx|ts|tsx)$')

if [ -n "$STAGED_FILES" ]; then
  npx jest --findRelatedTests $STAGED_FILES --passWithNoTests --bail
fi
```

### Python (pytest)

```bash
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.py$')

if [ -n "$STAGED_FILES" ]; then
  # Find and run test files related to changed source files
  TEST_FILES=""
  for f in $STAGED_FILES; do
    # Check if the file itself is a test
    if echo "$f" | grep -qE '(test_|_test\.py|tests\.py)'; then
      TEST_FILES="$TEST_FILES $f"
    else
      # Find corresponding test file
      basename=$(basename "$f" .py)
      related=$(find . -name "test_${basename}.py" -o -name "${basename}_test.py" 2>/dev/null)
      [ -n "$related" ] && TEST_FILES="$TEST_FILES $related"
    fi
  done

  if [ -n "$TEST_FILES" ]; then
    pytest $TEST_FILES --tb=short -q --no-header
  fi
fi
```

### Go

```bash
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.go$')

if [ -n "$STAGED_FILES" ]; then
  # Extract unique package directories
  PACKAGES=$(echo "$STAGED_FILES" | xargs -I{} dirname {} | sort -u | sed 's|^|./|')
  go test $PACKAGES -race -count=1 -short
fi
```

**Pass criteria:** All related tests pass. Failing tests block the commit.

---

## Installation

### Using pre-commit framework (Recommended)

Create `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: local
    hooks:
      - id: lint
        name: Lint Check
        entry: bash -c 'npm run lint:staged'
        language: system
        pass_filenames: false

      - id: typecheck
        name: Type Check
        entry: bash -c 'npx tsc --noEmit'
        language: system
        pass_filenames: false

  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.4
    hooks:
      - id: gitleaks

  - repo: local
    hooks:
      - id: test-changed
        name: Test Changed Files
        entry: bash -c 'npx jest --findRelatedTests $(git diff --cached --name-only) --passWithNoTests --bail'
        language: system
        pass_filenames: false
```

Install the hooks:

```bash
pip install pre-commit
pre-commit install
```

### Using Husky (Node.js projects)

```bash
npx husky init
echo 'npx lint-staged && npx tsc --noEmit && gitleaks protect --staged' > .husky/pre-commit
```

---

## Agent Behaviour

When an AI agent is preparing a commit:

1. **Run all four gates** before executing `git commit`
2. **Fix lint and formatting issues automatically** — do not ask the user to fix style issues
3. **Fix type errors if possible** — if the fix is non-trivial, report the error and ask for guidance
4. **Never suppress or skip the secret scan** — if gitleaks is not installed, use the fallback regex check
5. **If tests fail, diagnose and fix** — do not commit with failing tests unless explicitly instructed
