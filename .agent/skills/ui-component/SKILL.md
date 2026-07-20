---
name: ui-component
description: Instructions for creating UI components following the design system, accessibility standards, and file structure conventions.
---

# UI Component Creation Skill

When creating a new UI component, follow this procedure exactly:

## 1. File Structure
Every component must produce these files:
```
components/
└── MyComponent/
    ├── MyComponent.tsx          # Component implementation
    ├── MyComponent.test.tsx     # Unit tests (React Testing Library)
    ├── MyComponent.stories.tsx  # Storybook stories
    └── index.ts                 # Barrel export
```

## 2. Props Interface
- Define a `Props` interface with JSDoc on every prop.
- Export the interface for consumer use.
```typescript
/** Props for the MyComponent component. */
export interface MyComponentProps {
  /** The primary label displayed to the user. */
  label: string;
  /** Optional click handler. */
  onClick?: () => void;
  /** Visual variant. Defaults to 'primary'. */
  variant?: 'primary' | 'secondary' | 'ghost';
}
```

## 3. Accessibility (WCAG 2.1 AA)
- All interactive elements must have `aria-label` or visible label text.
- Colour contrast ratio must be at least **4.5:1** for normal text, **3:1** for large text.
- Support keyboard navigation (`Tab`, `Enter`, `Escape`).
- Include `role` attributes where semantic HTML is insufficient.

## 4. Design System Tokens
- Use design tokens for all colours, spacing, typography, and radii. Never hardcode values.
- Example: `var(--color-primary)`, `var(--spacing-md)`, `var(--radius-lg)`.

## 5. Responsive Breakpoints
| Breakpoint | Min Width | Target         |
|------------|-----------|----------------|
| `sm`       | 640px     | Mobile         |
| `md`       | 768px     | Tablet         |
| `lg`       | 1024px    | Small Desktop  |
| `xl`       | 1280px    | Large Desktop  |
