# tmux-ipc

A Claude Code slash command to discover and trigger other tmux panes via keystrokes.

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
curl -o ~/.claude/commands/ipc-trigger.md https://raw.githubusercontent.com/FuriKuri/tmux-ipc/main/commands/ipc-trigger.md
```

## Usage

Any tmux pane is automatically discoverable. Just open panes, start your tools, and go.

```
/ipc-trigger                                       # List all other panes
/ipc-trigger frontend Build a UserList component    # Local pane
/ipc-trigger api@devbox Add rate limiting           # Remote pane via SSH
```

### Remote triggering

Use `target@host` to reach panes on other machines. The host can be:
- An SSH hostname from `~/.ssh/config`
- A Tailscale MagicDNS name (e.g. `devbox`)
- An IP address

```
/ipc-trigger frontend@devbox Build a UserList component
/ipc-trigger api@192.168.1.50 Run the test suite
```

Requires SSH access to the remote host (Tailscale SSH works without keys).

## How it works

1. Scans all tmux panes across all sessions/windows via `tmux list-panes -a`
2. Panes are identified by the basename of their working directory
3. Sends keystrokes via `tmux send-keys`
4. For remote targets: runs the same commands over `ssh`
5. No state files, no extra binaries, no polling — just a slash command and tmux

## Requirements

- tmux
- SSH (optional, for remote triggering)
