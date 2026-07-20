# Contributing Guidelines

Welcome! This repository uses a **Universal AI Context Architecture** (`.agent/`) to govern both human engineering and AI-assisted development.

## How We Work with AI Agents

1. **Single Source of Truth**: All coding standards, architectural patterns, security rules, and workflows live in `.agent/`.
2. **Local Environment Setup**: Run `make setup-ai` upon cloning to link your local AI tool (Cursor, Antigravity, Claude Code, Copilot) to the repository rules.
3. **Pre-Commit Checks**: Run `make ai-lint` and `make ai-test` before committing.
4. **Pull Requests**: Follow `.agent/workflows/PR-PREPARATION.md` when preparing a PR. Use `.agent/templates/pull-request.md` for PR descriptions.

## Language Convention
All documentation, comments, and commit messages in this repository follow **British English (en-GB)** spelling conventions.
