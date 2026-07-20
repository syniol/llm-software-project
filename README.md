# LLM Software Project Template

The **gold-standard repository layout** used by elite software engineers and AI-first engineering teams.

Designed for **multi-model interoperability** (Google Antigravity, Claude Code, Cursor, Copilot, Codex), maximum **token efficiency** (modular context loaded on-demand), and **enterprise-level automation, security, and onboarding**.

---

## Folder Structure

```text
my-project/
├── AGENTS.md                       # 🌟 Single Source of Truth: Core project guidelines & AI rules
├── CLAUDE.md                       # Symlink → AGENTS.md (Claude Code CLI compatibility)
├── Makefile                        # 🤖 Agentic task runner (ai-test, ai-lint, setup-ai, clean-ai)
├── .editorconfig                   # 📐 Universal formatting baseline for all editors & AI tools
│
├── .agent/                         # 🚀 Centralized AI Context & Multi-Agent Hub
│   │
│   ├── rules/                      # Global rules — loaded on EVERY agent turn
│   │   ├── 01-architecture.md      #   Layered arch, DI, barrel exports, circular import ban
│   │   ├── 02-code-style.md        #   TypeScript strict mode, naming, error handling
│   │   ├── 03-testing.md           #   80% coverage, naming conventions, E2E isolation
│   │   └── 04-security.md          #   OWASP Top 10, Zod validation, JWT rotation
│   │
│   ├── skills/                     # On-demand domain packs — loaded only when relevant
│   │   ├── db-migration/
│   │   │   ├── SKILL.md            #   Prisma migration workflow & safety checks
│   │   │   └── templates/          #   Migration file templates
│   │   ├── ui-component/
│   │   │   ├── SKILL.md            #   Design tokens, WCAG 2.1 AA, component structure
│   │   │   └── examples/           #   Reference implementations
│   │   └── api-endpoint/
│   │       ├── SKILL.md            #   REST conventions, Zod schemas, middleware chain
│   │       └── scripts/            #   OpenAPI generator or validation scripts
│   │
│   ├── personas/                   # Subagent role definitions for multi-agent execution
│   │   ├── security-auditor.md     #   OWASP-focused vulnerability scanner
│   │   ├── code-reviewer.md        #   Staff Engineer PR reviewer
│   │   └── db-specialist.md        #   Database reliability & query optimizer
│   │
│   ├── workflows/                  # Standard Operating Procedures (SOPs)
│   │   ├── PR-PREPARATION.md       #   7-step pre-PR checklist
│   │   └── RELEASE-CHECK.md        #   7-step release verification
│   │
│   ├── mcp/                        # 🔌 Model Context Protocol integrations
│   │   ├── servers.json            #   MCP server definitions (PostgreSQL, GitHub, Jira)
│   │   └── api-specs/              #   OpenAPI/Swagger specs for tool ingestion
│   │
│   ├── boundaries/                 # 🛡️ Security guardrails & human-in-the-loop gates
│   │   ├── SECRETS_DO_NOT_TOUCH.md #   Files the AI is forbidden from editing
│   │   └── REQUIRED_APPROVALS.md   #   Operations requiring explicit human YES/NO
│   │
│   ├── hooks/                      # 🪝 Git hook instructions for AI-assisted validation
│   │   └── pre-commit.md           #   Lint, type-check, secret scan, test changed files
│   │
│   ├── templates/                  # 📝 Reusable prompt & message templates
│   │   ├── pull-request.md         #   PR description template (Summary, Motivation, etc.)
│   │   └── commit-message.md       #   Conventional Commits guide with examples
│   │
│   └── context/                    # 🧠 Architectural knowledge base
│       ├── adr/                    #   Architectural Decision Records
│       │   ├── 0001-use-postgresql.md
│       │   └── 0002-state-management.md
│       ├── system-diagrams.md      #   Mermaid C4 & sequence diagrams
│       └── domain-glossary.md      #   Business terms to prevent hallucination
│
├── .cursor/                        # Cursor IDE integration
│   └── rules/                      #   Symlinks → .agent/rules/
├── .gemini/                        # Google Antigravity / Gemini CLI integration
│   └── skills → ../.agent/skills   #   Symlink to universal skills directory
├── .claude/                        # Claude Code integration
│   └── settings.json               #   Tool permissions & config
├── .github/                        # CI/CD & pipeline integrations
│   ├── copilot-instructions.md     #   GitHub Copilot global instructions
│   └── workflows/
│       └── ai-pr-reviewer.yml      #   Auto-triggers code reviewer on PR creation
└── docs/                           # Project documentation for human engineers
```

---

## Why Top 1% Engineers Use This Architecture

### 1. Single Source of Truth (`.agent/` + Symlinks)
All rules reside in `.agent/`. Symlinks ensure Cursor, Claude Code, Gemini, and Copilot all read from the same configuration — zero duplication, zero drift.

### 2. Modular "Skills" over Giant Prompts (Token Efficiency)
- **Global Rules** (`.agent/rules/`): Loaded on every turn (~500–1000 tokens).
- **Skills** (`.agent/skills/`): Loaded **on-demand** only when the AI handles that specific domain. An agent working on a database migration loads `db-migration/SKILL.md`; an agent building UI loads `ui-component/SKILL.md`. This keeps context lean and focused.

### 3. Enterprise Guardrails (`boundaries/` & `hooks/`)
- **Boundaries** explicitly forbid dangerous operations (DROP TABLE, editing `.env`, force-pushing to main) unless a human approves.
- **Hooks** define pre-commit validation steps (lint, type-check, secret scan) that agents should run or recommend before committing.

### 4. Subagent Personas (`.agent/personas/`)
Multi-agent workflows spawn specialized subagents with explicit roles:
- `security-auditor` — scans for OWASP Top 10 vulnerabilities before merge.
- `db-specialist` — reviews migration safety, N+1 queries, index coverage.
- `code-reviewer` — enforces testing, readability, and performance standards.

### 5. Reusable Templates (`.agent/templates/`)
Standardized PR descriptions and commit messages eliminate inconsistency. Agents produce uniform, high-quality output that matches your team's conventions.

### 6. MCP Integrations (`.agent/mcp/`)
Agents don't guess database schemas or API shapes. They connect to real tools (PostgreSQL, GitHub, Jira) via the Model Context Protocol for verified, grounded actions.

### 7. CI/CD Native (`Makefile` & `.github/`)
Agents interact locally via `make ai-test` instead of hallucinating shell commands. In CI, GitHub Actions automatically invoke the code-reviewer agent on every PR.

### 8. ADRs & Domain Context (`.agent/context/`)
- **ADRs** prevent agents from rewriting established patterns (e.g., swapping your ORM or state manager).
- **Domain glossary** eliminates business-term hallucination (e.g., "Tenant" means X, not Y).
- **System diagrams** give agents spatial awareness of the architecture.

### 9. Universal Formatting (`.editorconfig`)
A single `.editorconfig` ensures consistent indentation, line endings, and charset across every editor, terminal, and AI tool — before any linter even runs.

---

## Quick Setup

### One-Command Bootstrap
```bash
# Create full directory structure
mkdir -p .agent/{rules,skills,personas,workflows,context/adr,mcp/api-specs,boundaries,hooks,templates} \
         .github/workflows .cursor/rules .gemini .claude docs
```

### Symlink Setup (or use `make setup-ai`)
```bash
# Cross-tool compatibility symlinks
ln -sf .agent/AGENTS.md AGENTS.md
ln -sf AGENTS.md CLAUDE.md
ln -sf ../.agent/skills .gemini/skills
ln -sf ../../.agent/rules .cursor/rules/agent-rules
```

### Makefile Targets
```bash
make setup-ai    # Create all cross-tool symlinks
make clean-ai    # Remove all cross-tool symlinks
make ai-lint     # Run linter per .agent/rules/02-code-style.md
make ai-test     # Run test suite
make ai-format   # Run formatter
make ai-review   # Run local AI code review
```

### .gitignore Essentials
```gitignore
# AI agent workspace artifacts (never commit)
.agent/logs/
.agent/scratch/
.agent/memory/
```

---

## Adapting This Template

This template is **language-agnostic and stack-agnostic**. To adapt it:

1. **Update `.agent/rules/`** with your stack's conventions (Go, Python, Rust, etc.).
2. **Add skills** for your domain (e.g., `terraform/`, `k8s-deploy/`, `graphql-schema/`).
3. **Define personas** for your team's workflow (e.g., `devops-engineer.md`, `data-engineer.md`).
4. **Write ADRs** for every major technical decision so agents respect your architecture.

This layout gives you complete vendor neutrality, clean token management, enterprise security, and consistent multi-agent execution across any AI model or IDE.
