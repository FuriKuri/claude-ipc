---
allowed-tools:
  - Bash
---
Show IPC status overview.

Run these commands and present the output:
1. `echo "Session: $CLAUDE_IPC_SESSION"`
2. `claude-ipc sessions`
3. `claude-ipc peek "$CLAUDE_IPC_SESSION"`
4. `claude-ipc list`

Available commands: `/ipc-send`, `/ipc-read`, `/ipc-ask`, `/ipc-trigger`.
