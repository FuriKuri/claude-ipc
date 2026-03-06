# tmux-ipc

Discover and trigger other tmux panes via keystrokes. Built for AI coding agents (Claude Code, OpenCode, Aider, ...) but works with anything running in tmux.

```
┌─ tmux ──────────────────────────────────────────┐
│                                                  │
│ ┌─────────────┐  ┌─────────────┐                 │
│ │ api         │  │ frontend    │                 │
│ │ ~/proj/api  │  │ ~/proj/front│                 │
│ │ Claude Code │  │ OpenCode    │                 │
│ │             │  │             │                 │
│ │ tmux-ipc trigger frontend ──┼─> tmux send-keys│
│ └─────────────┘  └─────────────┘                 │
│                                                  │
│ Discovery: tmux list-panes -a (all sessions)     │
└──────────────────────────────────────────────────┘
```

## Installation

```bash
git clone https://github.com/FuriKuri/tmux-ipc.git
cd tmux-ipc
cp bin/tmux-ipc ~/.local/bin/
cp commands/ipc-trigger.md ~/.claude/commands/   # optional: Claude Code slash command
```

## Usage

Any tmux pane is automatically discoverable. Just open panes, start your tools, and go.

```bash
tmux-ipc list                          # List all other panes
tmux-ipc trigger api "add auth tests"  # Send prompt by directory basename
tmux-ipc trigger-pane %3 "run tests"   # Send prompt by tmux pane ID
```

### Claude Code slash command

With the slash command installed, use `/ipc-trigger` inside Claude Code:

```
/ipc-trigger frontend Build a UserList component
/ipc-trigger api Add rate limiting to auth endpoints
```

## How it works

1. `tmux-ipc list` scans all tmux panes across all sessions/windows via `tmux list-panes -a`
2. Panes are identified by the basename of their working directory
3. `tmux-ipc trigger` sends keystrokes via `tmux send-keys`
4. No state files, no message queues, no polling — just tmux

## Requirements

- Bash 4+
- tmux
