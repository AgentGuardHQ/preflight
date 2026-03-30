# The Preflight Protocol

> A universal design-before-you-build standard for AI coding agents.

## What Is Preflight?

Preflight is a protocol that requires AI coding agents to think before they code. Before writing any code, the agent completes 5 mandatory phases that ensure it understands the context, clarifies intent, considers alternatives, and confirms its plan.

Preflight is:
- **Driver-agnostic** — works with any AI coding agent (Claude Code, Codex, Gemini, Goose, Copilot, Cursor, and more)
- **Zero dependency** — no runtime, no API key, no install required beyond a single instruction file
- **Prompt-based** — implemented as native instructions for each driver, not as a tool or service

## The 5 Phases

Every task triggers a fresh Preflight pass. All 5 phases are mandatory. They scale with task complexity but are never skipped.

### Phase 1: Orient

**Read before you write.** Examine relevant files, documentation, recent changes, and existing patterns. Build a mental model of the current state before proposing anything.

What to read depends on the task:
- For a bug fix: the failing code, related tests, recent commits to the area
- For a new feature: architecture docs, similar existing features, the module you'll modify
- For a refactor: all code that will change, all code that depends on it

**Output:** The agent can describe what exists and how the current system works.

### Phase 2: Clarify

**Understand intent before acting.** Ask questions until the purpose, constraints, and success criteria are clear.

For **supervised agents** (human in the loop):
- Ask one question at a time
- Prefer multiple choice when possible
- Focus on: purpose, constraints, success criteria, edge cases
- Skip this phase only if the task is fully specified with no ambiguity

For **autonomous agents** (no human in the loop):
- Check the ticket/issue spec for completeness
- Verify all acceptance criteria are present
- If the spec is underspecified, label the ticket `needs-spec` and stop — do not guess

**Output:** Shared understanding of what success looks like.

### Phase 3: Approach

**Consider alternatives before committing.** Propose 2-3 different approaches with trade-offs and a recommendation.

For complex tasks:
- Present approaches with architectural trade-offs
- Explain why you recommend one over the others
- Consider: maintainability, performance, simplicity, risk

For trivial tasks:
- One approach with a brief rationale is sufficient
- "I'll fix the null check in `handler.go:42` because that's where the panic originates" is a valid Phase 3

**Output:** A chosen approach with reasoning.

### Phase 4: Confirm

**Get a go-ahead before writing code.** Present the plan and wait for approval.

For **supervised agents:**
- Present the plan to the human
- Wait for explicit approval before proceeding
- If the human suggests changes, revise and re-confirm

For **autonomous agents:**
- Self-confirm against the ticket's acceptance criteria
- Log the plan in the PR body or commit message
- Proceed only if all acceptance criteria will be met by the chosen approach

**Output:** Explicit go-ahead (human approval or self-confirmation logged).

### Phase 5: Execute

**Now write the code.** This is the first phase where files are created or modified.

**Output:** Working implementation.

## Core Rules

1. **Phases 1-4 produce zero code changes.** No files are created, modified, or deleted until Phase 5. Reading files is encouraged — writing files is not.

2. **Task-scoped, not session-scoped.** Each new task triggers a fresh Preflight pass. Continuing work on the same task (e.g., fixing a test failure from your implementation) does not re-trigger Preflight.

3. **Scales down, never off.** Even a one-line fix goes through all 5 phases. For trivial tasks, each phase can be a single sentence — but it happens. The point is to make thinking explicit, not to make it heavy.

## Scaling by Agent Tier

Not all agents operate at the same level of autonomy or responsibility. Preflight adapts to the agent's role.

### Tier A — Architect / Principal

| Phase | Depth |
|-------|-------|
| Orient | Deep — reads architecture docs, strategy, cross-system dependencies |
| Clarify | Interactive — challenges assumptions, asks "should we even do this?" |
| Approach | 2-3 approaches with architectural trade-offs |
| Confirm | Presents design to human for approval |
| Execute | Writes specs and plans (rarely writes code directly) |

### Tier B — Senior Engineer

| Phase | Depth |
|-------|-------|
| Orient | Moderate — reads affected files, tests, and immediate dependencies |
| Clarify | Interactive — focused on implementation ambiguity |
| Approach | 2-3 approaches focused on implementation strategy |
| Confirm | Presents plan to human or Tier A for approval |
| Execute | Writes code |

### Tier C — Execution Workforce

| Phase | Depth |
|-------|-------|
| Orient | Light — reads the ticket and directly referenced files |
| Clarify | Non-interactive — checks ticket spec completeness. Stops if underspecified. |
| Approach | 1 approach with brief rationale (ticket already chose the direction) |
| Confirm | Self-confirms against acceptance criteria. Logs plan in PR body. |
| Execute | Writes code |

### Minimum Viable Preflight

A Tier C agent on a well-specified ticket:

1. **Orient:** "I read the ticket and the 3 files it references."
2. **Clarify:** "The spec covers all acceptance criteria — no gaps."
3. **Approach:** "I'll add the handler in `api/foo.go` and test in `api/foo_test.go`."
4. **Confirm:** "Plan logged. Proceeding."
5. **Execute:** *writes code*

This takes seconds, not minutes. But it forces the agent to read before writing and state its approach before coding.

## Compliance

An agent is Preflight-compliant if:

1. It completes all 5 phases for every new task
2. It produces no code changes during Phases 1-4
3. It scales phase depth to match its tier and task complexity
4. It stops and requests clarification (supervised) or labels `needs-spec` (autonomous) when a task is underspecified

## Versioning

This protocol follows semantic versioning. The current version is **1.0.0**.

- **Patch** (1.0.x): Clarifications, typo fixes, examples
- **Minor** (1.x.0): New optional phases, new tier definitions
- **Major** (x.0.0): Breaking changes to mandatory phases or core rules
