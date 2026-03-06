# claude-ipc

Let Claude Code sessions in tmux discover and trigger each other — no launcher required.

```
┌─ tmux ──────────────────────────────────────────┐
│                                                  │
│ ┌─────────────┐  ┌─────────────┐                 │
│ │ api         │  │ frontend    │                 │
│ │ ~/proj/api  │  │ ~/proj/front│                 │
│ │ Claude Code │  │ Claude Code │                 │
│ │             │  │             │                 │
│ │ /ipc-trigger frontend ──────┼─> tmux send-keys│
│ └─────────────┘  └─────────────┘                 │
│                                                  │
│ Discovery: tmux list-panes -a (all sessions)     │
└──────────────────────────────────────────────────┘
```

## Installation

```bash
git clone https://github.com/FuriKuri/claude-ipc.git
cd claude-ipc
bash install.sh
```

## Usage

Any Claude Code session running inside tmux is automatically discoverable. No special launcher needed — just open tmux panes, start `claude`, and go.

### Trigger another session

Inside any Claude session, use `/ipc-trigger` to send a prompt to another session's pane:

```
/ipc-trigger frontend Build a UserList component for the /users endpoint
/ipc-trigger api Add rate limiting to the auth endpoints
```

Without arguments, `/ipc-trigger` lists all discoverable sessions.

### Optional: Batch launcher

`claude-sessions` is a convenience script to create multiple panes at once:

```bash
claude-sessions ~/Projects/api ~/Projects/frontend ~/Projects/shared

# Options
claude-sessions --layout=vertical ./backend ./frontend
```

### CLI

```
claude-ipc list                      # List all other Claude panes
claude-ipc trigger <id> <prompt>     # Send prompt by directory basename
claude-ipc trigger-pane <id> <prompt> # Send prompt by tmux pane ID
```

## How it works

1. `claude-ipc list` scans all tmux panes across all sessions/windows via `tmux list-panes -a`
2. Filters for panes running Claude, identifies them by directory basename
3. `claude-ipc trigger` sends keystrokes via `tmux send-keys`
4. No state files, no message queues, no polling — just tmux

## Troubleshooting

**"no tmux server found"**
Claude sessions must run inside tmux.

**"no Claude pane found"**
```bash
claude-ipc list    # check what's discoverable
```

**Multiple panes with same directory name**
`claude-ipc` will list them with pane IDs. Use `trigger-pane` with the specific ID.

## Requirements

- Bash 4+
- tmux
