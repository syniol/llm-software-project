# Title: Use PostgreSQL for Primary Datastore
# Status: Accepted
# Date: 2026-07-20

## Context
We needed a relational database that supports strong transactional integrity, JSONB columns for flexible schemas, and high compatibility with our ORM (Prisma).

## Decision
We will use **PostgreSQL** (v15+) as our primary database.

## Consequences
- We cannot use MySQL specific features.
- We must ensure our CI pipelines spin up a PostgreSQL service container for integration tests.
- AI Agents must always output PostgreSQL-flavored SQL, not MySQL/SQLite.
