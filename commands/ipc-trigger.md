---
allowed-tools:
  - Bash
---
Type a prompt directly into another Claude session's tmux pane.

Parse $ARGUMENTS: first word is the target session ID, the rest is the prompt to type.

If no arguments given, list available sessions by running:
```bash
SELF=$(tmux display-message -p '#{pane_id}')
tmux list-panes -F '#{pane_id} #{pane_current_path}' | while read id path; do
  [ "$id" = "$SELF" ] && continue
  echo "$(basename "$path")  ->  $path"
done
```

Steps:
1. Discover panes in the current tmux window (excluding own pane):
   ```bash
   SELF=$(tmux display-message -p '#{pane_id}')
   tmux list-panes -F '#{pane_id} #{pane_current_path}'
   ```
2. Match the target session ID against `basename` of each pane's current path.
3. Send the keystrokes: `tmux send-keys -t <pane_id> "<prompt>" Enter`

WARNING: Only use when the target pane is idle and ready for input.
