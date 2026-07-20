# Conventional Commits Guide

All commit messages must follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

## Format
```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

## Types
| Type       | When to Use                                              |
|------------|----------------------------------------------------------|
| `feat`     | A new feature for the user                               |
| `fix`      | A bug fix                                                |
| `refactor` | Code change that neither fixes a bug nor adds a feature  |
| `docs`     | Documentation-only changes                               |
| `test`     | Adding or updating tests                                 |
| `chore`    | Maintenance tasks (deps, CI config, tooling)             |
| `perf`     | Performance improvement                                  |
| `style`    | Formatting, whitespace, semicolons (no logic change)     |
| `ci`       | CI/CD pipeline changes                                   |

## Scope Examples
- `api`, `auth`, `db`, `ui`, `config`, `deps`, `infra`

## Examples
```
feat(api): add user registration endpoint
fix(auth): prevent token refresh race condition
refactor(db): extract query builder into shared utility
docs(readme): update setup instructions for Node 20
test(orders): add edge case for zero-quantity line items
chore(deps): upgrade prisma to v6.2.0
perf(api): cache tenant lookup to reduce DB queries by 40%
```

## Breaking Changes
Add `BREAKING CHANGE:` in the footer (or `!` after the type) to signal breaking changes:
```
feat(api)!: change /users response shape to paginated format

BREAKING CHANGE: The /users endpoint now returns { data: User[], meta: Pagination }
instead of User[]. All clients must update their response parsing.
```
