---
allowed-tools:
  - Bash
---
Type a prompt directly into another Claude session's tmux pane.

Parse $ARGUMENTS: first word is the target session ID, the rest is the prompt to type.

If no arguments given, list available sessions: `ls ~/.claude-ipc/*.pane | xargs -I{} basename {} .pane`

Steps:
1. Read the tmux pane target: `cat ~/.claude-ipc/<target>.pane`
2. Send the keystrokes: `tmux send-keys -t <pane_target> "<prompt>" Enter`

WARNING: Only use when the target pane is idle and ready for input.
