---
name: ipc-trigger
description: Type a prompt directly into another tmux pane — locally or remote via SSH
tools:
  - shell
---
Type a prompt directly into another tmux pane — locally or on a remote host.

Parse the user's input: first word is the target, the rest is the prompt.

The target can be:
- `frontend` — local pane matched by directory basename
- `frontend@devbox` — remote pane on host `devbox` (SSH hostname, IP, or Tailscale MagicDNS name)

**If no arguments given**, list available local panes by running:
```bash
SELF=$(tmux display-message -p '#{pane_id}' 2>/dev/null || echo "")
tmux list-panes -a -F '#{pane_id} #{pane_current_path}' | while read -r id path; do
  [ "$id" = "$SELF" ] && continue
  echo "$(basename "$path")  ->  $path  ($id)"
done
```

**If target contains `@`** (remote), split into target name and host:
```bash
TARGET="<part before @>"
HOST="<part after @>"
PROMPT="<rest of arguments>"
PANE_ID=$(ssh "$HOST" tmux list-panes -a -F '#{pane_id} #{pane_current_path}' | while read -r id path; do
  [ "$(basename "$path")" = "$TARGET" ] && echo "$id" && break
done)
if [ -z "$PANE_ID" ]; then
  echo "Error: no pane '$TARGET' found on $HOST"
  exit 1
fi
ssh "$HOST" tmux send-keys -t "$PANE_ID" "$PROMPT" Enter
```

**If target is local** (no `@`):
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
