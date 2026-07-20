# Architecture Rules

## 1. Repository Structure — Monorepo (Turborepo)

This project uses a **monorepo** managed by Turborepo. All packages live under a single repository to enable:

- Atomic cross-package changes with a single PR
- Shared TypeScript configuration and tooling
- Consistent versioning across internal packages

### Package Layout

```
apps/
  web/              # Next.js frontend
  api/              # Express/Fastify backend
packages/
  shared/           # Shared types, constants, utilities
  ui/               # Shared UI component library
  config-ts/        # Shared tsconfig bases
  config-eslint/    # Shared ESLint configurations
  db/               # Drizzle/Prisma schema + migrations
```

### Rules

- **DO** keep all deployable applications under `apps/`.
- **DO** keep all shared libraries under `packages/`.
- **DO NOT** create new top-level directories without an ADR.
- **DO NOT** import directly from another app (`apps/web` must not import from `apps/api`). Use `packages/shared` for shared code.

---

## 2. Layered Architecture

Every backend feature must follow a strict layered architecture. Each layer has a single responsibility and may only call the layer directly below it.

```
┌─────────────────────────────────┐
│  Controller (Route Handler)     │  ← HTTP concerns only: parse request, send response
├─────────────────────────────────┤
│  Service (Business Logic)       │  ← Orchestrates domain logic, enforces invariants
├─────────────────────────────────┤
│  Repository (Data Access)       │  ← Talks to DB, external APIs, caches
└─────────────────────────────────┘
```

### Layer Rules

| Layer        | May Import From      | Handles                                  | Returns               |
| ------------ | -------------------- | ---------------------------------------- | ---------------------- |
| Controller   | Service              | Request parsing, response formatting     | HTTP Response          |
| Service      | Repository, other Services | Business rules, validation, orchestration | Domain objects / DTOs  |
| Repository   | DB client, external SDKs   | Data persistence, queries, caching       | Raw or mapped entities |

### Violations

- **Controllers must NOT contain business logic.** If you see an `if` statement checking a business rule in a controller, move it to the service layer.
- **Services must NOT import Express/Fastify types.** They should be framework-agnostic.
- **Repositories must NOT throw HTTP errors.** They throw domain-specific errors (e.g., `EntityNotFoundError`), which the service or error-handling middleware translates to HTTP status codes.

### File Naming Convention

```
src/
  modules/
    users/
      users.controller.ts
      users.service.ts
      users.repository.ts
      users.router.ts
      users.types.ts
      users.validation.ts
      __tests__/
        users.service.test.ts
        users.controller.test.ts
```

---

## 3. Dependency Injection

Use **constructor injection** for all service and repository dependencies. This project uses a lightweight DI container (e.g., `tsyringe` or manual composition root) — not a heavy framework.

### Pattern

```typescript
// ✅ Good — dependencies are injected
class UsersService {
  constructor(
    private readonly usersRepository: UsersRepository,
    private readonly emailService: EmailService,
    private readonly logger: Logger,
  ) {}

  async createUser(dto: CreateUserDto): Promise<User> {
    const user = await this.usersRepository.create(dto);
    await this.emailService.sendWelcome(user.email);
    this.logger.info('User created', { userId: user.id });
    return user;
  }
}
```

```typescript
// ❌ Bad — hard-coded dependency
import { usersRepository } from '../repositories/users.repository';

class UsersService {
  async createUser(dto: CreateUserDto): Promise<User> {
    return usersRepository.create(dto); // untestable without monkey-patching
  }
}
```

### Composition Root

Wire all dependencies in a single `composition-root.ts` (or `container.ts`) file at the application entry point. This is the **only** place where concrete implementations are instantiated and connected.

```typescript
// src/composition-root.ts
import { UsersRepository } from './modules/users/users.repository';
import { UsersService } from './modules/users/users.service';
import { UsersController } from './modules/users/users.controller';
import { EmailService } from './infra/email.service';
import { createLogger } from './infra/logger';

const logger = createLogger();
const emailService = new EmailService(logger);
const usersRepository = new UsersRepository(db);
const usersService = new UsersService(usersRepository, emailService, logger);
const usersController = new UsersController(usersService);

export { usersController };
```

---

## 4. Barrel Exports Policy

### Rules

- **DO** use a single `index.ts` barrel file per package in `packages/` to define the public API surface.
- **DO NOT** use barrel files (`index.ts`) inside `apps/` directories. Deep imports are preferred within apps to enable better tree-shaking and avoid circular dependency traps.
- **DO NOT** re-export everything with `export *`. Explicitly name every export to keep the public API intentional and reviewable.

### Example — Package Barrel

```typescript
// packages/shared/src/index.ts
export { ApiError, NotFoundError, ValidationError } from './errors';
export type { PaginatedResponse, ApiResponse } from './types/api';
export { ROLES, PERMISSIONS } from './constants/auth';
export { formatCurrency, formatDate } from './utils/formatters';
```

```typescript
// ❌ Bad — wildcard re-export, leaks internals
export * from './errors';
export * from './types';
export * from './utils';
export * from './internal'; // implementation detail now public
```

---

## 5. Circular Import Ban

**Circular imports are strictly prohibited.** They cause runtime issues (especially with CommonJS), make the dependency graph unpredictable, and are a strong signal of poor module boundaries.

### Prevention Strategies

1. **Depend on abstractions.** If module A and module B need each other, extract a shared interface into `packages/shared` or a local `types.ts` file that both import from.
2. **Use the Dependency Inversion Principle.** The higher-level module defines the interface; the lower-level module implements it.
3. **Events for cross-module communication.** If two modules at the same layer need to react to each other's actions, use a lightweight event emitter or message bus instead of direct imports.

### Enforcement

- ESLint rule `import/no-cycle` is enabled with `maxDepth: 5` and set to `error`.
- CI will fail on any circular import.
- Run `npx madge --circular --extensions ts src/` locally to detect cycles before pushing.

### Example — Breaking a Cycle

```typescript
// ❌ Circular: users.service.ts → orders.service.ts → users.service.ts

// ✅ Fix: Extract an event
// events/user-events.ts
export interface UserCreatedEvent {
  userId: string;
  email: string;
}

// users.service.ts — emits the event
this.eventBus.emit('user.created', { userId: user.id, email: user.email });

// orders.service.ts — listens for the event
this.eventBus.on('user.created', (event: UserCreatedEvent) => {
  this.createWelcomeOrder(event.userId);
});
```

---

## Summary Checklist

Before submitting a PR, verify:

- [ ] New code lives in the correct `apps/` or `packages/` directory
- [ ] Controller → Service → Repository layering is respected
- [ ] No business logic in controllers
- [ ] All dependencies are injected via constructor
- [ ] No `new ConcreteClass()` outside the composition root
- [ ] Barrel exports are explicit (no `export *`) and only in `packages/`
- [ ] `npx madge --circular` passes with zero cycles
- [ ] No cross-app imports (`apps/web` ↛ `apps/api`)
