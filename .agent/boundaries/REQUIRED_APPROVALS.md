# Required Approvals — Operational Boundaries

> **Purpose:** Define operations that carry irreversible or high-impact consequences and therefore **MUST** receive explicit human confirmation before execution. An AI agent must never autonomously perform these operations, regardless of context or confidence level.

---

## Guiding Principle

**When in doubt, ask.** The cost of a 30-second confirmation is negligible. The cost of an unauthorized destructive action is catastrophic. These rules exist because some operations cannot be undone with `Ctrl+Z`.

---

## Rule 1: Destructive Database Operations

### Operations Requiring Approval

- `DROP TABLE`
- `DROP DATABASE`
- `DROP SCHEMA`
- `TRUNCATE TABLE`
- `DELETE FROM <table>` without a `WHERE` clause
- `ALTER TABLE ... DROP COLUMN` on production databases
- Any migration marked as irreversible / no-rollback

### Rationale

Database destruction is permanent. Even with backups, restoring a dropped table in production causes downtime, potential data loss for transactions that occurred between the last backup and the restore, and cascading failures in dependent services. A dropped column cannot be reconstructed if the data was not backed up.

### Required Before Execution

- [ ] Confirmation of which environment (staging vs. production)
- [ ] Verification that a recent backup exists and has been tested
- [ ] Acknowledgment of data loss implications
- [ ] Approval from the database owner or on-call DBA

---

## Rule 2: Production File Deletion

### Operations Requiring Approval

- `rm -rf` on any production directory
- Deleting deployed artifacts, configuration files, or certificates
- Removing log files that have not been archived
- Clearing cache directories that affect live traffic
- Deleting uploaded user content (media, documents, exports)

### Rationale

File deletion in production environments can cause immediate service disruption. Configuration files, TLS certificates, and application binaries are load-bearing — removing them causes outages. User-uploaded content is often irreplaceable and may have legal retention requirements.

### Required Before Execution

- [ ] Confirmation of the exact file paths and their purpose
- [ ] Verification that files are not referenced by running processes
- [ ] Confirmation that backups or archives exist
- [ ] Approval from the service owner

---

## Rule 3: Authentication and Authorization Changes

### Operations Requiring Approval

- Modifying login, registration, or password reset flows
- Changing role definitions, permission matrices, or access control lists
- Altering JWT signing keys, session management, or token expiration
- Modifying OAuth/OIDC provider configuration
- Adding or removing MFA requirements
- Changing password hashing algorithms or parameters
- Modifying API key generation or validation logic

### Rationale

Authentication and authorization are the security perimeter of the application. A bug in auth logic can grant unauthorized access to every user's data, elevate privileges for unprivileged users, or lock out legitimate users. These changes have a blast radius that extends to every user of the system.

### Required Before Execution

- [ ] Security review of the proposed change
- [ ] Test coverage for both positive and negative auth scenarios
- [ ] Verification that existing sessions are handled correctly
- [ ] Approval from the security team or security-designated reviewer

---

## Rule 4: Billing and Payment Processing

### Operations Requiring Approval

- Modifying charge amounts, currency handling, or tax calculations
- Changing subscription lifecycle logic (creation, renewal, cancellation)
- Altering payment provider integration code (Stripe, PayPal, Braintree, etc.)
- Modifying refund or credit logic
- Changing invoice generation or receipt formatting
- Altering webhook handlers for payment events
- Modifying pricing tier definitions or feature gating

### Rationale

Payment processing errors have direct financial and legal consequences. Overcharging users creates liability and erodes trust. Undercharging creates revenue loss. Incorrect tax calculations can result in regulatory penalties. Payment provider integrations are notoriously stateful and difficult to test — a subtle bug can process thousands of incorrect charges before detection.

### Required Before Execution

- [ ] Financial impact analysis of the proposed change
- [ ] End-to-end testing against the payment provider's sandbox/test mode
- [ ] Verification that webhook idempotency is maintained
- [ ] Approval from the engineering lead AND a finance/billing stakeholder

---

## Rule 5: CI/CD Pipeline Configuration

### Operations Requiring Approval

- Modifying deployment scripts or pipeline definitions (`.github/workflows/`, `Jenkinsfile`, `.gitlab-ci.yml`)
- Changing environment variables in CI/CD (especially secrets and credentials)
- Altering deployment targets, regions, or infrastructure provisioning
- Modifying Docker image build processes or base images
- Changing artifact signing or verification steps
- Adding or removing pipeline stages (security scan, test, deploy)
- Modifying rollback automation

### Rationale

CI/CD pipelines are the software supply chain. A compromised or misconfigured pipeline can deploy malicious code to production, leak secrets to build logs, skip security scans, or deploy to the wrong environment. Supply chain attacks frequently target build pipelines because a single compromise affects every subsequent deployment.

### Required Before Execution

- [ ] Review of the pipeline change in a non-production branch first
- [ ] Verification that secrets are not exposed in logs or artifacts
- [ ] Confirmation that security scan steps are not bypassed
- [ ] Approval from the DevOps/Platform team or designated pipeline owner

---

## Rule 6: Force-Push to Protected Branches

### Operations Requiring Approval

- `git push --force` to `main`, `master`, `release/*`, or `production`
- `git push --force-with-lease` to protected branches
- Rewriting history on shared branches (`rebase`, `filter-branch`, `BFG`)
- Deleting remote branches that are deployment targets

### Rationale

Force-pushing to shared branches rewrites history for every collaborator. It can silently discard other engineers' commits, break CI/CD pipelines that reference specific commit SHAs, corrupt deployment tracking, and make incident investigation impossible by destroying the audit trail. Even `--force-with-lease` is not safe in all scenarios (stale references, CI bots pushing between fetches).

### Required Before Execution

- [ ] Confirmation that no other work is based on the commits being rewritten
- [ ] Notification to all contributors working on the affected branch
- [ ] Verification that CI/CD pipelines do not reference specific commit SHAs being removed
- [ ] Approval from the repository owner or team lead

---

## Enforcement

1. **These rules apply to all environments** — including staging, unless explicitly scoped to production-only.
2. **"I'm confident it's safe" is not a substitute for approval.** Confidence does not eliminate risk.
3. **Emergency exceptions** must be documented in a post-incident report within 24 hours, including who authorized the override and why.
4. **Violations are treated as incidents** — not disciplinary actions, but learning opportunities that result in process improvements.
