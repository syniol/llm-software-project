# AI Evaluations (Evals)

This directory contains test cases and evaluation scripts used to verify that the AI agents operating in this repository adhere to the rules defined in `.agent/rules/` and `.agent/boundaries/`.

## Why Evals?
Just like application code needs unit tests, prompt engineering requires evaluations. When we update our architectural rules or security boundaries, we run these evals to ensure the AI hasn't regressed in its understanding.

## Structure
- `prompts/`: Contains benchmark prompts (e.g., "Generate a user service").
- `expected/`: Contains the expected structural output.
- `scripts/`: LLM-as-a-judge scripts that run the prompt and grade the output against the expected criteria.
