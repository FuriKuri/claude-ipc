---
allowed-tools:
  - Bash
---
Type a prompt directly into another Claude session's tmux pane.

Parse $ARGUMENTS: first word is the target session ID, the rest is the prompt to type.

If no arguments given, list available sessions: `claude-ipc list`

To send a prompt: `claude-ipc trigger <session-id> <prompt>`

WARNING: Only use when the target pane is idle and ready for input.
