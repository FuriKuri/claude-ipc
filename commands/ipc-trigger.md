---
allowed-tools:
  - Bash
---
Type a prompt directly into another Claude session's tmux pane.

Parse $ARGUMENTS: first word is the target session ID (directory basename), the rest is the prompt to type.

If no arguments given, list available sessions: `claude-ipc list`

To send a prompt: `claude-ipc trigger <session-id> <prompt>`

If multiple panes match, `claude-ipc` will show them. Use `claude-ipc trigger-pane <pane_id> <prompt>` to target a specific one.

Discovers all Claude panes across all tmux sessions and windows automatically. No launcher required — any Claude running in tmux is discoverable.

WARNING: Only use when the target pane is idle and ready for input.
