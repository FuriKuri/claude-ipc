---
name: ipc-trigger
description: Type a prompt directly into another tmux pane
tools:
  - shell
---
Type a prompt directly into another tmux pane.

Parse the user's input: first word is the target (directory basename), the rest is the prompt.

**If no arguments given**, list available panes by running:
```bash
SELF=$(tmux display-message -p '#{pane_id}' 2>/dev/null || echo "")
tmux list-panes -a -F '#{pane_id} #{pane_current_path}' | while read -r id path; do
  [ "$id" = "$SELF" ] && continue
  echo "$(basename "$path")  ->  $path  ($id)"
done
```

**If arguments given**, send prompt to the matching pane by running:
```bash
TARGET="<first word from arguments>"
PROMPT="<rest of arguments>"
SELF=$(tmux display-message -p '#{pane_id}' 2>/dev/null || echo "")
PANE_ID=$(tmux list-panes -a -F '#{pane_id} #{pane_current_path}' | while read -r id path; do
  [ "$id" = "$SELF" ] && continue
  [ "$(basename "$path")" = "$TARGET" ] && echo "$id" && break
done)
if [ -z "$PANE_ID" ]; then
  echo "Error: no pane found for '$TARGET'"
  exit 1
fi
tmux send-keys -t "$PANE_ID" "$PROMPT" Enter
```

If multiple panes match, list them all with pane IDs and ask the user which one to target.

WARNING: Only use when the target pane is idle and ready for input.
