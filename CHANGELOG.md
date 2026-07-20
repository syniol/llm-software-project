# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.0.0] - 2026-07-20

### 🚀 Initial Release: Universal Enterprise AI Context Architecture

Initial public release of the **Universal `.agent/` Hub Pattern** — a centralized, tool-agnostic AI governance, execution, and architectural mesh designed for multi-agent software engineering.

#### 🏛️ Governance & Multi-Agent Mesh (`.agent/`)
- **Global Rules (`.agent/rules/`)**: Established mandatory, context-lean guidelines covering Architecture, Code Style, Testing (80% minimum coverage gate), and Security (OWASP Top 10, Zod input validation, JWT rotation).
- **Execution Skills (`.agent/skills/`)**: Added on-demand task execution packs for `api-endpoint`, `ui-component` (WCAG 2.1 AA compliant), `db-migration`, and structured `code-review`.
- **Specialised Personas (`.agent/personas/`)**: Introduced role definitions for autonomous subagents: `security-auditor` (AppSec), `code-reviewer` (Staff Engineer), and `db-specialist` (DBRE).
- **Security Boundaries (`.agent/boundaries/`)**: Defined strict human approval gates (`REQUIRED_APPROVALS.md`) for destructive actions and auth modifications, along with `.env`/keys protection (`SECRETS_DO_NOT_TOUCH.md`).
- **Standard Operating Procedures (`.agent/workflows/`)**: Created 7-step pre-flight checklists for PR preparation (`PR-PREPARATION.md`) and release verification (`RELEASE-CHECK.md`).
- **MCP Integration (`.agent/mcp/`)**: Added Model Context Protocol server configuration (`servers.json`) and API specification schema ingestion framework.

#### 🧠 Knowledge Base & Persistent Memory
- **Codebase Mapping (`.agent/context/CODEBASE-MAP.md`)**: Implemented a living architectural index of the source tree for instant agent orientation.
- **Architectural Memory (`.agent/context/adr/`)**: Included Architectural Decision Records (ADRs) for PostgreSQL selection and Zustand state management.
- **System Diagrams (`.agent/context/system-diagrams.md`)**: Provided Mermaid C4 context and sequence diagrams for end-to-end request flows.
- **Domain Glossary (`.agent/context/domain-glossary.md`)**: Added unambiguous business term definitions for AI agents.
- **Cross-Session Memory (`.agent/memory/session-log.md`)**: Created persistent log for tracking architectural decisions, constraints, and lessons learned across agent sessions.

#### ⚙️ Automation, Tooling & Token Economics
- **Agentic Task Runner (`Makefile`)**: Implemented 1-click targets for environment setup (`setup-ai`), teardown (`clean-ai`), formatting (`ai-format`), linting (`ai-lint`), testing (`ai-test`), and local reviews (`ai-review`).
- **Token Optimisation (`.aignore`)**: Added global context ignore rules to block lockfiles, dist outputs, and assets from wasting agent context windows.
- **Tool Interoperability**: Created symlinks connecting Cursor (`.cursor/rules`), Gemini/Antigravity (`.gemini/skills`), Claude Code (`CLAUDE.md`, `.claudesignore`), and Copilot (`copilot-instructions.md`) to the central `.agent/` hub.
- **CI/CD Pipeline (`.github/workflows/`)**: Added automated GitHub Action (`ai-pr-reviewer.yml`) for local/remote PR audits.

#### 📝 Templates & Human Engineering Docs
- **Templates (`.agent/templates/`)**: Added Conventional Commits specification, GitHub PR description template (linked natively via `.github/pull_request_template.md`), and pre-coding `implementation-plan.md` template.
- **Documentation (`docs/`)**: Added human developer onboarding guides (`CONTRIBUTING.md` and `ARCHITECTURE.md`) symlinked to the project root.
- **Prompt Evaluations (`.agent/evals/`)**: Created evaluation suite directory structure for testing LLM regression against architectural rules.

#### ⚖️ Compliance & Licensing
- **Language Standard**: Enforced **British English (en-GB)** spelling across all documentation, workflows, and rules.
- **Licence**: Published under the **BSD 3-Clause Licence** with copyright held by **Syniol Limited** (2026).
