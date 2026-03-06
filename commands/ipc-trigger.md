---
allowed-tools:
  - Bash
---
Type a prompt directly into another tmux pane.

Parse $ARGUMENTS: first word is the target session ID (directory basename), the rest is the prompt to type.

If no arguments given, list available sessions: `tmux-ipc list`

To send a prompt: `tmux-ipc trigger <session-id> <prompt>`

If multiple panes match, `tmux-ipc` will show them. Use `tmux-ipc trigger-pane <pane_id> <prompt>` to target a specific one.

Discovers all panes across all tmux sessions and windows automatically.

WARNING: Only use when the target pane is idle and ready for input.
