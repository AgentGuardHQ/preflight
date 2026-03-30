# Preflight

**Think before you build.** A universal protocol that makes AI coding agents design before they code.

Preflight defines 5 mandatory phases every agent completes before writing code: **Orient, Clarify, Approach, Confirm, Execute.** It works with any AI coding agent — no runtime, no API key, one file.

## Why

AI coding agents jump straight to implementation. They write code before reading the codebase, skip exploring alternatives, and don't confirm intent. This wastes tokens, produces wrong solutions, and creates rework.

Preflight fixes this with a lightweight prompt-based protocol that works across every major agent driver.

## Quick Start

### Auto-detect and install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AgentGuardHQ/preflight/main/install.sh)
```

The installer detects which AI agent drivers you use and copies the appropriate config file.

### Install for a specific driver

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AgentGuardHQ/preflight/main/install.sh) --driver claude-code
```

### Manual install

Copy the driver file for your agent into your project:

| Driver | Copy this file | To this location |
|--------|----------------|------------------|
| Claude Code | `drivers/claude-code/preflight.md` | `.claude/commands/preflight.md` |
| Codex (OpenAI) | `drivers/codex/AGENTS.md` | Append to `AGENTS.md` |
| Gemini CLI | `drivers/gemini/GEMINI.md` | Append to `GEMINI.md` |
| Goose | `drivers/goose/.goosehints` | Append to `.goosehints` |
| GitHub Copilot | `drivers/copilot/.github/copilot-instructions.md` | Append to `.github/copilot-instructions.md` |
| Cursor | `drivers/cursor/.cursor/rules/preflight.mdc` | `.cursor/rules/preflight.mdc` |

## The Protocol

See [PROTOCOL.md](PROTOCOL.md) for the full specification.

### The 5 Phases

| Phase | What the agent does |
|-------|---------------------|
| **1. Orient** | Read relevant files, docs, recent changes. Understand what exists. |
| **2. Clarify** | Ask questions until purpose, constraints, and success criteria are clear. |
| **3. Approach** | Propose 2-3 approaches with trade-offs and a recommendation. |
| **4. Confirm** | Present the plan. No code until approved. |
| **5. Execute** | Write the code. |

### Core Rules

- **Phases 1-4 produce zero code changes.** Reading is encouraged, writing is not.
- **Task-scoped.** Each new task triggers a fresh pass. Continuing the same task doesn't re-trigger.
- **Scales down, never off.** Even a one-line fix runs all 5 phases — each can be one sentence.

## Examples

- [Simple task](examples/simple-task.md) — bug fix with minimal Preflight (~30 seconds)
- [Complex task](examples/complex-task.md) — feature with full design flow
- [Autonomous agent](examples/autonomous-agent.md) — Tier C agent self-confirming against a ticket

## Adding a New Driver

See [CONTRIBUTING.md](.github/CONTRIBUTING.md) for how to add support for additional AI coding agents.

## License

MIT — see [LICENSE](LICENSE).

---

Created by the [AgentGuard](https://github.com/AgentGuardHQ) team.
