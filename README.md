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
│ ~/.claude-ipc/                                   │
│ ├── api.pane        # tmux pane target           │
│ └── frontend.pane   # tmux pane target           │
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

1. `claude-sessions` creates tmux panes and writes pane targets to `~/.claude-ipc/<session-id>.pane`
2. `/ipc-trigger` reads the pane target and uses `tmux send-keys` to type into the target pane
3. That's it. No message queues, no inbox, no polling — just keystrokes.

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
ls ~/.claude-ipc/*.pane    # check registered sessions
```

**tmux session already exists**
```bash
tmux kill-session -t claude-multi
```

## Requirements

- Bash 4+
- tmux
