# Code Style: TypeScript & Node.js

- **TypeScript Strict Mode**: All code must compile with `strict: true`. Avoid using `any`; use `unknown` if the type is truly dynamic.
- **Naming Conventions**: 
  - Interfaces: `IUser` (Prefix with I)
  - Types: `UserType`
  - Variables/Functions: `camelCase`
  - Classes: `PascalCase`
- **Error Handling**: Do not swallow errors. Always use `try/catch` and wrap API responses in standard error formats: `{ error: string, code: number }`.
- **Imports**: Use absolute imports over relative imports where the bundler supports it.
