---
name: api-endpoint
description: Instructions for creating REST API endpoints following conventions, validation, and documentation standards.
---

# API Endpoint Creation Skill

When creating a new API endpoint, follow this procedure exactly:

## 1. REST Conventions
| Action           | HTTP Verb | Route Pattern          | Success Code |
|------------------|-----------|------------------------|--------------|
| List resources   | `GET`     | `/api/v1/resources`    | `200`        |
| Get single       | `GET`     | `/api/v1/resources/:id`| `200`        |
| Create resource  | `POST`    | `/api/v1/resources`    | `201`        |
| Update resource  | `PATCH`   | `/api/v1/resources/:id`| `200`        |
| Replace resource | `PUT`     | `/api/v1/resources/:id`| `200`        |
| Delete resource  | `DELETE`  | `/api/v1/resources/:id`| `204`        |

## 2. Request/Response Validation
- Define **Zod schemas** for both request body and response body.
- Validate at the middleware layer, before the handler executes.
```typescript
const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
  role: z.enum(['admin', 'member', 'viewer']),
});
```

## 3. Standardised Error Response
All errors must return this shape:
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email format is invalid.",
    "details": [{ "field": "email", "issue": "Invalid email format" }]
  }
}
```

## 4. Middleware Chain
Every endpoint must pass through this middleware chain in order:
1. **`authenticate`** — Verify JWT, attach `req.user`.
2. **`authorize`** — Check RBAC permissions for the route.
3. **`validate`** — Run Zod schema validation on `req.body` / `req.query`.
4. **`handler`** — Execute business logic.
5. **`errorHandler`** — Catch and format any thrown errors.

## 5. OpenAPI Documentation
- Annotate every endpoint with JSDoc or decorators that generate OpenAPI 3.0 specs.
- Include request body schema, response schema, error codes, and authentication requirements.
