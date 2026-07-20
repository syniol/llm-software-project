.PHONY: ai-format ai-lint ai-test ai-review

# Makefiles abstract complex CLI commands into simple targets for AI agents

ai-format:
	@echo "Running standard formatting tasks..."
	# TODO: Insert formatting tool (e.g. prettier, black)

ai-lint:
	@echo "Running linting rules defined in .agent/rules/02-code-style.md..."
	# TODO: Insert linter (e.g. eslint, ruff)

ai-test:
	@echo "Running test suite to verify agent logic..."
	# TODO: Insert test runner (e.g. jest, pytest)

ai-review:
	@echo "Running local pre-commit AI code review..."
	# TODO: Insert AI local reviewer invocation here

setup-ai:
	@echo "Setting up AI cross-compatibility symlinks..."
	@mkdir -p .cursor/rules .gemini .claude
	@ln -sf .agent/AGENTS.md AGENTS.md || true
	@ln -sf AGENTS.md CLAUDE.md || true
	@ln -sf ../.agent/skills .gemini/skills || true
	@ln -sf ../../.agent/rules .cursor/rules/agent-rules || true
	@echo "✅ AI environment symlinks established!"

clean-ai:
	@echo "Removing AI cross-compatibility symlinks..."
	@rm -f AGENTS.md CLAUDE.md
	@rm -f .gemini/skills
	@rm -f .cursor/rules/agent-rules
	@echo "🧹 AI environment symlinks removed!"
