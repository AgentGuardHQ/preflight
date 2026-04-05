<p align="center">
  <img src="docs/logo.svg" alt="Preflight" width="100">
</p>

<h1 align="center">Preflight</h1>

<p align="center">
  <strong>Think before you build.</strong> A universal protocol that makes AI coding agents design before they code.
  <br><br>
  <a href="https://agentguardhq.github.io/preflight">Website</a> &middot;
  <a href="PROTOCOL.md">Protocol Spec</a> &middot;
  <a href="https://github.com/chitinhq/preflight/releases/tag/v1.0.0">v1.0.0</a>
</p>

Preflight defines 5 mandatory phases every agent completes before writing code: **Orient, Clarify, Approach, Confirm, Execute.** It works with any AI coding agent — no runtime, no API key, one file.

## Why

AI coding agents jump straight to implementation. They write code before reading the codebase, skip exploring alternatives, and don't confirm intent. This wastes tokens, produces wrong solutions, and creates rework.

Preflight fixes this with a lightweight prompt-based protocol that works across every major agent driver.

## Quick Start

### Auto-detect and install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/chitinhq/preflight/main/install.sh)
```

The installer detects which AI agent drivers you use and copies the appropriate config file.

### Install for a specific driver

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/chitinhq/preflight/main/install.sh) --driver claude-code
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

## Part of the Governed Swarm Platform

| Repo | Role |
|------|------|
| [AgentGuard](https://github.com/chitinhq/agentguard) | Governance — policy enforcement, telemetry, invariants |
| [Octi Pulpo](https://github.com/chitinhq/octi-pulpo) | Coordination — pipeline controller, model routing |
| [ShellForge](https://github.com/chitinhq/shellforge) | Orchestration — multi-runtime agent execution |
| **Preflight** | **Protocol — universal design-before-you-build standard** |
| [Extensions](https://github.com/chitinhq/agentguard-extensions) | Drivers, integrations, policies, example swarms |

## License

MIT — see [LICENSE](LICENSE).

---

Created by the [AgentGuard](https://github.com/chitinhq) team.
