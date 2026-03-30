# Contributing to Preflight

## Adding a New Driver

Preflight welcomes community driver implementations. To add support for a new AI coding agent:

1. **Create a directory** under `drivers/` named after your driver (e.g., `drivers/aider/`)
2. **Write one file** that translates the 5 Preflight phases into your driver's native instruction format
3. **Follow the protocol exactly** — all 5 phases (Orient, Clarify, Approach, Confirm, Execute), the core rules, and tier scaling must be present
4. **Update `install.sh`** — add detection logic for your driver and a copy target
5. **Open a PR** with:
   - The driver file
   - The `install.sh` update
   - A brief note on how your driver consumes instruction files

### What makes a good driver implementation

- Uses the driver's **native** instruction format (not a generic markdown file)
- Includes all 5 phases with clear instructions for each
- Includes the tier scaling section (A/B/C)
- Includes the core rules (no code before Phase 5, task-scoped, scales down never off)
- Tested with the actual driver to confirm the agent follows the protocol

### What to avoid

- Don't add runtime dependencies — Preflight is prompt-only
- Don't modify `PROTOCOL.md` — that's the canonical spec
- Don't add features beyond the protocol — keep implementations equivalent
