# Security Standards (OWASP-Aligned)

## Input Validation
- **All user input must be validated** using Zod or Joi schemas at the API boundary. Never trust client-side validation alone.
- Validate type, length, format, and range. Reject anything unexpected.

## SQL Injection Prevention
- **Parameterized queries only.** Never concatenate user input into SQL strings.
- Use ORM query builders (Prisma, Drizzle, Knex). Raw SQL is only permitted via tagged template literals with automatic escaping.

## Cross-Site Scripting (XSS)
- All dynamic content rendered in HTML must be escaped by default (React handles this; for server-rendered HTML, use explicit sanitization).
- Never use `dangerouslySetInnerHTML` or equivalent without a security review.

## Authentication & Authorisation
- **JWT tokens** must have a maximum TTL of 15 minutes. Use refresh token rotation.
- Store tokens in `httpOnly`, `secure`, `sameSite=strict` cookies. Never in localStorage.
- Enforce role-based access control (RBAC) at the middleware level, not inside business logic.

## CORS Policy
- Allowlist specific origins. Never use `Access-Control-Allow-Origin: *` in production.

## Rate Limiting
- All public endpoints must enforce rate limiting (e.g., 100 req/min per IP).
- Authentication endpoints must have stricter limits (e.g., 5 req/min).

## Secrets Management
- **Never hardcode secrets.** Use environment variables loaded via `.env` files (locally) or a vault service (production).
- Rotate secrets on a quarterly schedule minimum.
- If a secret is accidentally committed, consider it compromised. Rotate immediately.

## Dependency Security
- Run `npm audit` (or equivalent) in CI. Block PRs with critical/high vulnerabilities.
- Pin dependency versions. Avoid `^` or `~` ranges in production dependencies.
