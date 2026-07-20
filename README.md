# LLM Software Project Template

Here is the **gold-standard repository layout** used by elite software engineers and AI-first engineering teams. 

It is designed for **multi-model interoperability** (Google Antigravity, Claude Code, Cursor, Copilot, Codex) and maximum **token efficiency** (modular context loaded on-demand rather than giant monolithic prompt files).

---

### Recommended Folder Structure

```text
my-project/
├── AGENTS.md                   # 🌟 Single Source of Truth: Core project guidelines & AI rules
├── CLAUDE.md                   # Symlink to AGENTS.md or stub for Claude Code CLI compatibility
├── .agent/                     # 🚀 Centralized AI Context & Multi-Agent Hub (Universal Standard)
│   ├── rules/                  # Global rules enforced on every coding task
│   │   ├── 01-architecture.md  # Tech stack, boundary definitions, component hierarchy
│   │   ├── 02-code-style.md    # TypeScript/Python conventions, naming, error handling
│   │   ├── 03-testing.md       # Unit/E2E test patterns, coverage standards, mock rules
│   │   └── 04-security.md      # Auth rules, sanitization, secret management, OWASP
│   ├── skills/                 # On-demand, domain-specific execution packs (SKILL.md format)
│   │   ├── db-migration/
│   │   │   ├── SKILL.md        # Instructions & workflow for creating Prisma/SQL migrations
│   │   │   └── templates/      # Migration templates
│   │   ├── ui-component/
│   │   │   ├── SKILL.md        # Design system rules, accessibility (a11y), Tailwind specs
│   │   │   └── examples/       # Reference component implementations
│   │   └── api-endpoint/
│   │       ├── SKILL.md        # REST/gRPC endpoint creation checklist
│   │       └── scripts/        # OpenAPI generator or validation script
│   ├── personas/               # Specialized subagent definitions for multi-agent execution
│   │   ├── security-auditor.md # Persona for vulnerability & dependency scanning
│   │   ├── code-reviewer.md    # Persona for PR review and edge-case verification
│   │   └── db-specialist.md   # Persona for query optimization and schema design
│   ├── workflows/              # Slash commands / standard operating procedures (SOPs)
│   │   ├── PR-PREPARATION.md   # SOP for pre-PR checks (lint, test, build, changelog)
│   │   └── RELEASE-CHECK.md    # SOP for deployment verification
│   └── context/                # High-signal architectural knowledge base
│       ├── adr/                # Architectural Decision Records (ADRs)
│       │   ├── 0001-use-postgresql.md
│       │   └── 0002-state-management.md
│       ├── system-diagrams.md  # Mermaid diagrams of system & data flow
│       └── domain-glossary.md  # Business terminology to eliminate AI hallucinations
├── .cursor/                    # Cursor IDE integration
│   └── rules/                  # Symlinks pointing to ../.agent/rules/*.md
├── .gemini/                    # Google Antigravity / Gemini CLI integration
│   └── skills -> ../.agent/skills # Symlink to universal skills directory
├── .claude/                    # Claude Code integration
│   └── settings.json           # Symlink or tool-specific settings
└── docs/                       # Project documentation for human engineers
```

---

### Why Top 1% Engineers Use This Architecture

#### 1. Single Source of Truth (`.agent/` + Symlinks)
Instead of duplicating rules in `.cursorrules`, `.claude/`, and `.gemini/`, all rules reside in `.agent/`. You create symlinks or lightweight adapters so every AI tool reads from the same configuration.

#### 2. Modular "Skills" over Giant Prompts (Token Efficiency)
Top engineers don't put 5,000 lines of rules into one giant context file. 
- **Global Rules** (`.agent/rules/`): Loaded on every turn (~500–1000 tokens max).
- **Skills** (`.agent/skills/`): Loaded **on-demand** only when the AI handles that specific domain (e.g., database migration or UI design).

#### 3. Subagent Personas (`.agent/personas/`)
When running multi-agent workflows (e.g. in Antigravity or Claude Code), subagents can be initialized with explicit personas. For example:
- Spawn a `security-auditor` subagent to audit code before merging.
- Spawn a `db-specialist` subagent to review index performance.

#### 4. ADRs (Architectural Decision Records)
AI models frequently try to rewrite established patterns (e.g., replacing Redux with Zustand or changing your ORM). By storing ADRs in `.agent/context/adr/`, AI agents respect past technical decisions and understand **why** the codebase is built the way it is.

---

### Quick Setup Commands for a New Repo

```bash
# 1. Create directory structure
mkdir -p .agent/{rules,skills,personas,workflows,context/adr}

# 2. Create tool symlinks for cross-compatibility
ln -s .agent/AGENTS.md AGENTS.md
ln -s AGENTS.md CLAUDE.md
mkdir -p .gemini && ln -s ../.agent/skills .gemini/skills
mkdir -p .cursor && ln -s ../.agent/rules .cursor/rules
```

This layout gives you complete vendor neutrality, clean token management, and consistent multi-agent execution across any AI model or IDE.
