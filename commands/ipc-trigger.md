---
allowed-tools:
  - Bash
---
Type a prompt directly into another Claude session's tmux pane.

WARNING: This sends keystrokes directly. Only use when the target pane is idle and ready for input.

Parse $ARGUMENTS: first word is the target session ID, the rest is the prompt to type.

1. Look up the target's tmux pane from `cat ~/.claude-ipc/sessions/<target>.json`
2. Extract the `tmux_pane` value
3. Send the IPC record: `claude-ipc send <target> message "[trigger] Sent prompt via keystroke injection"`
4. Inject keystrokes: `tmux send-keys -t <tmux_pane> <prompt> Enter`
