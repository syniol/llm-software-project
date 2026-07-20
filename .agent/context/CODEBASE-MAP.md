# Codebase Map

A living architectural index to orient AI agents instantly without filesystem exploration. Update this file whenever the top-level structure changes.

## Top-Level Structure

```
src/
├── app/                # Application entrypoints, routing, and bootstrapping
├── modules/            # Feature modules (vertical slices: user, billing, order...)
│   └── <feature>/
│       ├── controller.ts   # HTTP layer — route handlers only
│       ├── service.ts      # Business logic — no HTTP/DB knowledge
│       ├── repository.ts   # Data access — Prisma queries only
│       ├── schema.ts       # Zod validation schemas
│       └── *.test.ts       # Co-located unit tests
├── shared/             # Cross-cutting utilities (logger, config, errors, types)
├── infrastructure/     # External integrations (email, payment, storage, queues)
└── database/
    ├── migrations/     # Prisma migration files (auto-generated, do not edit manually)
    └── schema.prisma   # Source of truth for database schema
```

## Critical Path Files

| File | Purpose |
|------|---------|
| `src/app/server.ts` | Application bootstrap and middleware registration |
| `src/shared/errors.ts` | Standardised error classes used across all modules |
| `src/shared/config.ts` | Validated environment configuration (Zod-parsed) |
| `database/schema.prisma` | **Single source of truth** for all DB models |

## Key Conventions

- **Feature modules are vertical slices** — a feature owns its controller, service, and repository. Never import from another module's internals; use shared interfaces.
- **No business logic in controllers** — controllers validate input and delegate to services only.
- **No raw SQL outside repositories** — all database access goes through Prisma in `repository.ts`.
- **Environment variables are never accessed directly** — always import from `src/shared/config.ts`.
