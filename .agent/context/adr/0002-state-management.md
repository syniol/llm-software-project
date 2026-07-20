# Title: Use Zustand for Client-Side State Management
# Status: Accepted
# Date: 2026-07-20

## Context
We evaluated Redux, MobX, Jotai, and Zustand for global client-side state management in our React application. Key evaluation criteria:
- **Bundle size**: Our app targets mobile-first; every KB matters.
- **Boilerplate**: Developer velocity is critical; we cannot afford verbose action/reducer/saga ceremony for every state slice.
- **TypeScript ergonomics**: The solution must provide first-class TypeScript inference without manual type wiring.

## Decision
We will use **Zustand** as our client-side state management library.

## Rationale
- **Bundle size**: Zustand is ~1KB gzipped vs Redux Toolkit at ~11KB + React-Redux.
- **Boilerplate**: A Zustand store is a single function. No providers, no action creators, no reducers.
- **TypeScript**: Full type inference out of the box. No need for `RootState`, `AppDispatch`, or typed hooks boilerplate.
- **React 18+ compatibility**: Works seamlessly with concurrent features and `useSyncExternalStore`.

## Consequences
- AI Agents must **never** suggest migrating to Redux or introducing Redux middleware (saga, thunk) unless this ADR is superseded.
- All global client state must live in Zustand stores under `src/stores/`.
- Local component state (useState, useReducer) is still preferred for UI-only state that doesn't need to be shared.
