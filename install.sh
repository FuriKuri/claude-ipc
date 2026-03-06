#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Claude IPC Installer ==="
echo ""

# 1. Install CLI tools
mkdir -p "${HOME}/.local/bin"
cp "${SCRIPT_DIR}/bin/claude-ipc" "${HOME}/.local/bin/claude-ipc"
cp "${SCRIPT_DIR}/bin/claude-sessions" "${HOME}/.local/bin/claude-sessions"
chmod +x "${HOME}/.local/bin/claude-ipc" "${HOME}/.local/bin/claude-sessions"
echo "[ok] CLI tools installed to ~/.local/bin/"

# 2. Install slash commands
mkdir -p "${HOME}/.claude/commands"
cp "${SCRIPT_DIR}/commands/"*.md "${HOME}/.claude/commands/"
echo "[ok] Slash commands installed to ~/.claude/commands/"

# 3. Create IPC directories
mkdir -p "${HOME}/.claude-ipc"/{inbox,sessions,processed}
echo "[ok] IPC directories created at ~/.claude-ipc/"

# 4. PATH check
if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
  echo ""
  echo "[!] ~/.local/bin is not in your PATH. Add this to your shell profile:"
  echo "    export PATH=\"\${HOME}/.local/bin:\${PATH}\""
fi

echo ""
echo "=== Quick Start ==="
echo ""
echo "  # Sessions in verschiedenen Projekten starten:"
echo "  claude-sessions ~/Projects/api ~/Projects/frontend"
echo ""
echo "  # In jedem Pane Claude Code starten:"
echo "  claude"
echo ""
echo "  # Slash Commands zum Kommunizieren:"
echo "  /ipc-status                  # Sessions anzeigen"
echo "  /ipc-send frontend Schreib eine Login-Komponente"
echo "  /ipc-read                    # Inbox lesen"
echo "  /ipc-ask api Welche API-Endpoints gibt es?"
echo ""
echo "Done."
