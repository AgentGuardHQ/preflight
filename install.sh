#!/usr/bin/env bash
# install.sh — Install Preflight protocol for detected (or specified) AI agent drivers
# Usage:
#   bash install.sh                       # Auto-detect drivers
#   bash install.sh --driver claude-code  # Install for specific driver
#   bash install.sh --all                 # Install all drivers
set -euo pipefail

PREFLIGHT_REPO="https://raw.githubusercontent.com/AgentGuardHQ/preflight/main"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# If running from a cloned repo, use local files. Otherwise, fetch from GitHub.
use_local() { [ -f "$SCRIPT_DIR/PROTOCOL.md" ]; }

copy_driver() {
  local driver="$1"
  local src_path="$2"
  local dst_path="$3"
  local dst_dir
  dst_dir="$(dirname "$dst_path")"

  mkdir -p "$dst_dir"

  if use_local; then
    cp "$SCRIPT_DIR/$src_path" "$dst_path"
  else
    curl -fsSL "$PREFLIGHT_REPO/$src_path" -o "$dst_path"
  fi

  echo "  installed: $dst_path"
}

append_driver() {
  local driver="$1"
  local src_path="$2"
  local dst_path="$3"

  echo "  $dst_path exists — appending Preflight section"
  echo "" >> "$dst_path"
  if use_local; then
    cat "$SCRIPT_DIR/$src_path" >> "$dst_path"
  else
    curl -fsSL "$PREFLIGHT_REPO/$src_path" >> "$dst_path"
  fi
  echo "  installed: $dst_path (appended)"
}

install_driver() {
  local driver="$1"
  case "$driver" in
    claude-code)
      mkdir -p .claude/commands
      copy_driver "$driver" "drivers/claude-code/preflight.md" ".claude/commands/preflight.md"
      ;;
    codex)
      if [ -f "AGENTS.md" ]; then
        append_driver "$driver" "drivers/codex/AGENTS.md" "AGENTS.md"
      else
        copy_driver "$driver" "drivers/codex/AGENTS.md" "AGENTS.md"
      fi
      ;;
    gemini)
      if [ -f "GEMINI.md" ]; then
        append_driver "$driver" "drivers/gemini/GEMINI.md" "GEMINI.md"
      else
        copy_driver "$driver" "drivers/gemini/GEMINI.md" "GEMINI.md"
      fi
      ;;
    goose)
      if [ -f ".goosehints" ]; then
        append_driver "$driver" "drivers/goose/.goosehints" ".goosehints"
      else
        copy_driver "$driver" "drivers/goose/.goosehints" ".goosehints"
      fi
      ;;
    copilot)
      if [ -f ".github/copilot-instructions.md" ]; then
        append_driver "$driver" "drivers/copilot/.github/copilot-instructions.md" ".github/copilot-instructions.md"
      else
        copy_driver "$driver" "drivers/copilot/.github/copilot-instructions.md" ".github/copilot-instructions.md"
      fi
      ;;
    cursor)
      mkdir -p .cursor/rules
      copy_driver "$driver" "drivers/cursor/.cursor/rules/preflight.mdc" ".cursor/rules/preflight.mdc"
      ;;
    *)
      echo "  unknown driver: $driver (skipped)"
      return 1
      ;;
  esac
}

detect_and_install() {
  local found=0
  echo "Detecting AI agent drivers..."
  echo ""

  if [ -d ".claude" ] || [ -f "CLAUDE.md" ]; then
    echo "[claude-code] detected"
    install_driver "claude-code"
    found=$((found + 1))
  fi

  if [ -d ".codex" ] || [ -f "AGENTS.md" ]; then
    echo "[codex] detected"
    install_driver "codex"
    found=$((found + 1))
  fi

  if [ -d ".gemini" ] || [ -f "GEMINI.md" ]; then
    echo "[gemini] detected"
    install_driver "gemini"
    found=$((found + 1))
  fi

  if [ -f ".goosehints" ] || command -v goose &>/dev/null; then
    echo "[goose] detected"
    install_driver "goose"
    found=$((found + 1))
  fi

  if [ -f ".github/copilot-instructions.md" ]; then
    echo "[copilot] detected"
    install_driver "copilot"
    found=$((found + 1))
  fi

  if [ -d ".cursor" ]; then
    echo "[cursor] detected"
    install_driver "cursor"
    found=$((found + 1))
  fi

  echo ""
  if [ "$found" -eq 0 ]; then
    echo "No drivers detected. Use --driver <name> to install for a specific driver."
    echo "Supported: claude-code, codex, gemini, goose, copilot, cursor"
    exit 1
  else
    echo "Preflight installed for $found driver(s)."
  fi
}

# Parse arguments
DRIVER=""
ALL=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --driver) DRIVER="$2"; shift 2 ;;
    --all) ALL=true; shift ;;
    -h|--help)
      echo "Usage: bash install.sh [--driver <name>] [--all]"
      echo ""
      echo "Options:"
      echo "  --driver <name>  Install for a specific driver"
      echo "  --all            Install for all supported drivers"
      echo "  (no args)        Auto-detect and install"
      echo ""
      echo "Supported drivers: claude-code, codex, gemini, goose, copilot, cursor"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

echo ""
echo "=== Preflight Protocol Installer ==="
echo ""

if [ -n "$DRIVER" ]; then
  echo "Installing for driver: $DRIVER"
  install_driver "$DRIVER"
  echo ""
  echo "Preflight installed."
elif [ "$ALL" = true ]; then
  echo "Installing for all drivers..."
  for d in claude-code codex gemini goose copilot cursor; do
    echo "[$d]"
    install_driver "$d"
  done
  echo ""
  echo "Preflight installed for all drivers."
else
  detect_and_install
fi
