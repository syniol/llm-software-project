# Release Verification — Standard Operating Procedure

> **Purpose:** Ensure every release to production is safe, documented, and reversible. No release may proceed unless every step is verified and signed off.

---

## Release Checklist

### Step 1: Verify All CI Checks Pass on `main`

**Action:** Confirm the latest commit on `main` has a fully green CI pipeline.

```bash
# GitHub CLI
gh run list --branch main --limit 5
gh run view <run-id>

# Or check the commit status
gh api repos/{owner}/{repo}/commits/main/status
```

**Verification:**
- [ ] All required status checks are passing (lint, test, build, security scan)
- [ ] No checks are in "pending" or "queued" state
- [ ] The commit being released matches the HEAD of `main` — no unreleased commits are ahead

**Blocker:** If any required check is failing, the release is halted. No exceptions.

---

### Step 2: Confirm CHANGELOG.md Is Updated

**Action:** Review `CHANGELOG.md` to ensure all changes since the last release are documented.

```bash
# Compare changes since last tag
git log $(git describe --tags --abbrev=0)..HEAD --oneline

# Verify CHANGELOG has matching entries
head -50 CHANGELOG.md
```

**Verification:**
- [ ] `[Unreleased]` section contains entries for every merged PR since the last release
- [ ] Entries are categorised correctly: Added, Changed, Deprecated, Removed, Fixed, Security
- [ ] Breaking changes are explicitly called out with migration instructions
- [ ] The version number and date are filled in (replacing `[Unreleased]`)

**Format:**
```markdown
## [2.4.0] - 2026-07-20

### Added
- TOTP-based two-factor authentication for all user accounts (#892)
- Rate limiting on authentication endpoints (5 req/min per IP) (#901)

### Fixed
- Race condition in webhook delivery causing duplicate events (#887)

### Security
- Upgraded `jsonwebtoken` to 9.0.3 to resolve CVE-2024-XXXXX (#910)
```

---

### Step 3: Run Smoke Tests Against Staging

**Action:** Deploy the release candidate to the staging environment and run smoke tests.

```bash
# Deploy to staging
./scripts/deploy.sh --env staging --tag v2.4.0-rc.1

# Run smoke test suite
npm run test:smoke -- --env staging
# or
pytest tests/smoke/ --base-url https://staging.example.com
```

**Verification:**
- [ ] Application starts without errors — health check endpoint returns `200 OK`
- [ ] Authentication flow works end-to-end (login, token refresh, logout)
- [ ] Core CRUD operations function correctly
- [ ] API versioned endpoints return expected responses
- [ ] Background job processing is functional (verify with a test job)
- [ ] Third-party integrations respond correctly (payment, email, etc.)
- [ ] No new errors appear in application logs or error tracking (Sentry, Datadog, etc.)

**Minimum soak time:** Staging must run the release candidate for at least **30 minutes** under representative traffic before proceeding.

---

### Step 4: Verify Database Migrations Are Backward-Compatible

**Action:** Confirm schema changes are compatible with the currently running application version (N-1 compatibility).

**Verification:**
- [ ] New columns have `DEFAULT` values or are `NULLABLE` — the old application version will not crash
- [ ] No columns were renamed — only new columns added alongside old ones
- [ ] No columns were dropped — column removal is scheduled for the *next* release after code stops reading them
- [ ] New indexes are created `CONCURRENTLY` (PostgreSQL) to avoid table locks
- [ ] Migration execution time is estimated and acceptable for production table sizes
- [ ] Rollback migration (`down`) has been tested against a staging database copy

```bash
# Test migration forward and back
./manage.py migrate --plan
./manage.py migrate
./manage.py migrate <app> <previous_migration>
```

**Blocker:** Any migration that acquires `ACCESS EXCLUSIVE` lock on a table with > 1M rows during peak traffic is rejected.

---

### Step 5: Confirm Rollback Procedure Is Documented

**Action:** Document and verify the rollback plan before deploying to production.

**Required documentation:**

```markdown
## Rollback Plan for v2.4.0

### Application Rollback
1. Revert deployment to previous version: `./scripts/deploy.sh --env production --tag v2.3.1`
2. Estimated rollback time: < 5 minutes
3. Rollback does NOT require database changes

### Database Rollback (if needed)
1. Run: `./manage.py migrate app_name 0042_previous_migration`
2. Affected tables: `users` (removes `totp_secret` column)
3. Data loss: Yes — TOTP secrets added during v2.4.0 window will be lost
4. Estimated execution time: < 30 seconds for current table size (2.1M rows)

### Rollback Decision Criteria
- Error rate exceeds 1% of requests (baseline: 0.02%)
- P99 latency exceeds 2x baseline (baseline: 450ms)
- Any Critical severity alert fires
- Payment processing failure rate exceeds 0.1%
```

**Verification:**
- [ ] Rollback procedure is written and reviewed by at least one other engineer
- [ ] Rollback has been tested in staging
- [ ] Data loss implications are documented
- [ ] Rollback decision criteria are defined with specific thresholds
- [ ] On-call engineer has acknowledged the release and rollback plan

---

### Step 6: Tag the Release with Semantic Version

**Action:** Create an annotated git tag following [Semantic Versioning](https://semver.org/).

```bash
# Create annotated tag
git tag -a v2.4.0 -m "Release v2.4.0: TOTP 2FA, rate limiting, webhook fix"

# Push tag to remote
git push origin v2.4.0
```

**Versioning rules:**
- **MAJOR** (`X.0.0`): Breaking API changes, incompatible schema changes, removed features
- **MINOR** (`x.Y.0`): New features, backward-compatible additions
- **PATCH** (`x.y.Z`): Bug fixes, security patches, dependency updates

**Verification:**
- [ ] Tag follows semver format: `vMAJOR.MINOR.PATCH`
- [ ] Tag message summarises the release contents
- [ ] Tag points to the exact commit that was tested on staging
- [ ] GitHub Release / GitLab Release is created with changelog contents

---

### Step 7: Notify Stakeholders

**Action:** Send release notification to all relevant parties.

**Notification channels:**
- [ ] Engineering team (Slack `#releases` or equivalent)
- [ ] Product/PM team (for feature releases)
- [ ] Support/CS team (for user-facing changes)
- [ ] On-call engineer (confirm awareness of the release)
- [ ] External API consumers (for breaking changes — with advance notice per SLA)

**Notification template:**

```
🚀 Release v2.4.0 deployed to production

**Highlights:**
- TOTP-based two-factor authentication (#892)
- Rate limiting on auth endpoints (#901)
- Fixed webhook duplicate delivery (#887)

**Breaking Changes:** None

**Rollback Contact:** @oncall-engineer
**Monitoring Dashboard:** https://grafana.internal/d/release-v2.4.0
**Full Changelog:** https://github.com/org/repo/blob/main/CHANGELOG.md
```

---

## Post-Release Monitoring

After deployment, monitor for **at least 30 minutes** (or one full traffic cycle):

- [ ] Error rate is within baseline (< 0.05%)
- [ ] P50 and P99 latency are within baseline
- [ ] No new error signatures in Sentry/Datadog/PagerDuty
- [ ] Database connection pool utilization is normal
- [ ] Background job queue depth is not growing unexpectedly
- [ ] Memory and CPU utilization are within expected range

**If any metric exceeds the rollback threshold:** Execute the rollback plan immediately. Post-mortem after, not during.
