# tmux-ipc

A slash command that lets AI coding agents (Claude Code, OpenCode, Aider, ...) discover and trigger other tmux panes via keystrokes.

```
┌─ tmux ──────────────────────────────────────────┐
│                                                  │
│ ┌─────────────┐  ┌─────────────┐                 │
│ │ api         │  │ frontend    │                 │
│ │ ~/proj/api  │  │ ~/proj/front│                 │
│ │ Claude Code │  │ OpenCode    │                 │
│ │             │  │             │                 │
│ │ /ipc-trigger frontend ──────┼─> tmux send-keys│
│ └─────────────┘  └─────────────┘                 │
│                                                  │
│ Discovery: tmux list-panes -a (all sessions)     │
└──────────────────────────────────────────────────┘
```

## Installation

Copy the slash command to your Claude Code config:

```bash
cp commands/ipc-trigger.md ~/.claude/commands/
```

## Usage

Any tmux pane is automatically discoverable. Just open panes, start your tools, and go.

```
/ipc-trigger                                  # List all other panes
/ipc-trigger frontend Build a UserList component
/ipc-trigger api Add rate limiting to auth endpoints
```

## How it works

1. Scans all tmux panes across all sessions/windows via `tmux list-panes -a`
2. Panes are identified by the basename of their working directory
3. Sends keystrokes via `tmux send-keys`
4. No state files, no extra binaries, no polling — just a slash command and tmux

## Requirements

- tmux
