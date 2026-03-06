#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Claude IPC Install ==="
echo ""

# Install launcher
mkdir -p "${HOME}/.local/bin"
cp "${SCRIPT_DIR}/bin/claude-sessions" "${HOME}/.local/bin/claude-sessions"
cp "${SCRIPT_DIR}/bin/claude-ipc" "${HOME}/.local/bin/claude-ipc"
chmod +x "${HOME}/.local/bin/claude-sessions" "${HOME}/.local/bin/claude-ipc"
echo "[ok] claude-sessions and claude-ipc installed to ~/.local/bin"

# Install slash command
mkdir -p "${HOME}/.claude/commands"
cp "${SCRIPT_DIR}/commands/ipc-trigger.md" "${HOME}/.claude/commands/"
echo "[ok] /ipc-trigger installed to ~/.claude/commands"

if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
  echo ""
  echo "[!] ~/.local/bin is not in your PATH. Add to your shell profile:"
  echo "    export PATH=\"\${HOME}/.local/bin:\${PATH}\""
fi

echo ""
echo "Usage:"
echo "  claude-sessions ~/Projects/api ~/Projects/frontend"
echo "  Then inside Claude: /ipc-trigger frontend Write tests for auth module"
echo ""
echo "Done."
