# Domain Glossary

Precise definitions of business terms used in this project. AI agents must use these definitions exactly — do not infer alternative meanings.

| Term | Definition |
|------|-----------|
| **Tenant** | A top-level organizational entity (typically a company or team) that owns all resources within its scope. All data is tenant-isolated; cross-tenant data access is forbidden. |
| **Workspace** | A subdivision within a Tenant. Users can belong to multiple Workspaces under the same Tenant. Each Workspace has its own settings, members, and resources. |
| **Seat Licence** | A paid user slot within a Tenant's subscription. Each active user consumes one Seat Licence. Deactivated users free their seat. |
| **Billing Cycle** | The recurring period (monthly or annual) during which subscription charges accrue. Prorated charges apply when seats are added mid-cycle. |
| **SSO Provider** | A third-party identity provider (e.g., Okta, Azure AD, Google Workspace) used for Single Sign-On authentication. Configured per Tenant. |
| **Webhook Subscription** | A registered HTTP callback URL that receives real-time event notifications (e.g., `order.created`, `user.invited`). Each subscription targets a single event type. |
| **Rate Limit Tier** | The API usage allowance assigned to a Tenant based on their subscription plan. Tiers define requests-per-minute and requests-per-day caps. |
| **Feature Flag** | A runtime toggle that enables or disables a feature for specific Tenants, Workspaces, or user segments without requiring a code deployment. |
| **Audit Trail** | An immutable, append-only log of security-relevant actions (login, permission change, data export, deletion). Required for SOC 2 compliance. Retention: 2 years minimum. |
| **Data Retention Policy** | The rules governing how long different data types are stored before automatic deletion or archival. Configured per data classification level (public, internal, confidential, restricted). |
| **Idempotency Key** | A client-generated unique identifier (UUID) sent with mutating API requests to ensure the operation executes at most once, even if the request is retried. |
| **Soft Delete** | A deletion strategy where the record's `deleted_at` timestamp is set instead of physically removing the row. All queries must filter on `deleted_at IS NULL` unless explicitly querying deleted records. |
