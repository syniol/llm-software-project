# Testing Standards

## Coverage Requirements
- **Minimum 80% line coverage** for all packages. PRs that drop coverage below this threshold will be rejected.
- **100% coverage** on critical paths: authentication, payment processing, data mutations.

## Naming Convention
Use the `should_X_when_Y` pattern for test names:
```typescript
it('should_return_403_when_user_is_not_authenticated')
it('should_create_order_when_cart_is_valid')
it('should_throw_when_email_format_is_invalid')
```

## Mocking Strategy
- **Prefer dependency injection** over monkey-patching or module mocking.
- Inject interfaces/abstractions into constructors, then pass test doubles in tests.
- **Never mock what you don't own.** Wrap third-party libraries in thin adapters and mock the adapter.

## E2E Test Isolation
- Each E2E test must run inside a **database transaction that rolls back** at the end.
- Tests must not depend on execution order. Every test sets up its own fixtures.
- Use factories (e.g., `createTestUser()`) instead of shared seed data.

## Required Test Types Per PR
| Change Type         | Required Tests                          |
|---------------------|-----------------------------------------|
| New API endpoint    | Unit + integration + contract test      |
| Bug fix             | Regression test proving the fix         |
| UI component        | Unit + Storybook visual snapshot        |
| Database migration  | Migration up + migration down test      |
| Refactor (no behavior change) | Existing tests must still pass |
