# claude-ipc

Run multiple Claude Code sessions in tmux and let them trigger each other via keystrokes.

```
┌──────────────────────────────────────────────────┐
│ tmux: claude-multi                               │
│                                                  │
│ ┌─────────────┐  ┌─────────────┐                 │
│ │ api         │  │ frontend    │                 │
│ │ ~/proj/api  │  │ ~/proj/front│                 │
│ │ Claude Code │  │ Claude Code │                 │
│ │             │  │             │                 │
│ │ /ipc-trigger frontend ──────┼─> tmux send-keys│
│ └─────────────┘  └─────────────┘                 │
│                                                  │
│ Discovery: tmux list-panes (no state files)      │
└──────────────────────────────────────────────────┘
```

## Installation

```bash
git clone https://github.com/FuriKuri/claude-ipc.git
cd claude-ipc
bash install.sh
```

## Usage

### Start sessions

Each directory becomes a tmux pane with Claude Code running in it. Session IDs are derived from directory names.

```bash
claude-sessions ~/Projects/api ~/Projects/frontend ~/Projects/shared

# Options
claude-sessions --layout=vertical ./backend ./frontend
claude-sessions .    # Single session
```

### Trigger another session

Inside any Claude session, use the `/ipc-trigger` slash command to type a prompt into another session's pane:

```
/ipc-trigger frontend Build a UserList component for the /users endpoint
/ipc-trigger api Add rate limiting to the auth endpoints
/ipc-trigger shared Export all types from src/index.ts
```

Without arguments, `/ipc-trigger` lists available sessions.

## How it works

1. `claude-sessions` creates tmux panes, each running Claude Code in its own directory
2. `/ipc-trigger` discovers sibling panes via `tmux list-panes`, matches by directory basename, and uses `tmux send-keys`
3. No state files, no message queues, no polling — just tmux and keystrokes

## CLI Reference

```
claude-sessions [options] <dir1> [dir2] [dir3] ...

--layout=tiled|vertical|horizontal   Pane layout (default: tiled)
--name=<name>                        tmux session name (default: claude-multi)
```

## Ghostty + tmux Tips

- **Pane navigation**: `Ctrl-b` + arrow keys
- **Pane zoom**: `Ctrl-b z` to toggle fullscreen
- **Scrollback**: `Ctrl-b [` for scroll mode

## Troubleshooting

**"command not found: claude-sessions"**
```bash
export PATH="${HOME}/.local/bin:${PATH}"  # add to .zshrc
```

**"/ipc-trigger: session not found"**
```bash
tmux list-panes -F '#{pane_current_path}'    # check panes in current window
```

**tmux session already exists**
```bash
tmux kill-session -t claude-multi
```

## Requirements

- Bash 4+
- tmux
