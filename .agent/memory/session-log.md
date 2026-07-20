# Persistent Agent Memory

This file is a **living document** maintained by AI agents across sessions. After completing a significant task, agents should append a dated entry summarising key decisions, discovered constraints, and lessons learned.

This prevents future agents from repeating the same exploratory work or making contradicted decisions.

---

## Format

```
### YYYY-MM-DD — <Brief Title>
**Task**: What was being accomplished.
**Decision**: What was decided and why.
**Constraints Discovered**: Any non-obvious limitations found.
**Do Not Repeat**: Mistakes or dead-ends encountered.
```

---

## Log

### 2026-07-20 — Initial Template Scaffold
**Task**: Established the universal `.agent/` multi-model AI context architecture.
**Decision**: Adopted `.agent/` as the single source of truth, with symlinks for Cursor, Claude Code, and Gemini compatibility. Chose Zustand over Redux (see ADR-0002). PostgreSQL as primary datastore (see ADR-0001).
**Constraints Discovered**: GitHub Mermaid renderer rejects unquoted `|` characters inside node labels — always quote node label text.
**Do Not Repeat**: Do not add repo-level language rules (e.g. British English) that are personal preferences; those belong in the user's global `~/.gemini/skills/` instead.
