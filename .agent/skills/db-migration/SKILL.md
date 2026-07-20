---
name: db-migration
description: Instructions for modifying the database schema and generating migrations.
---

# Database Migration Skill

When the user asks you to update the database schema, follow this procedure exactly:

1. **Modify the Schema File**: Open `schema.prisma` (or the equivalent ORM file) and add the new models or columns.
2. **Generate the Migration**: Run `npx prisma migrate dev --name <descriptive_name> --create-only`. Do not apply the migration automatically.
3. **Review Migration Script**: Read the generated SQL file to ensure it doesn't accidentally drop existing columns containing data.
4. **Test Run**: Run `npx prisma migrate dev` to apply locally.
5. **Update Types**: Ensure any frontend/backend type definitions that rely on this schema are regenerated (`npx prisma generate`).
