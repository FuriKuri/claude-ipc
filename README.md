# claude-ipc

Inter-process communication for multiple Claude Code sessions in tmux.
Each session works in its own project directory.

```
┌──────────────────────────────────────────────────────────┐
│ tmux session: claude-multi                               │
│                                                          │
│ ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│ │ api          │  │ frontend     │  │ shared       │    │
│ │ ~/proj/api   │  │ ~/proj/front │  │ ~/proj/shared│    │
│ │ Claude Code  │  │ Claude Code  │  │ Claude Code  │    │
│ │              │  │              │  │              │    │
│ │ /ipc-send ───┼──┼─> inbox/    │  │              │    │
│ │              │  │   frontend   │  │              │    │
│ │ <── inbox/ ──┼──┼── /ipc-send  │  │              │    │
│ │     api      │  │              │  │              │    │
│ └──────────────┘  └──────────────┘  └──────────────┘    │
│                                                          │
│ ~/.claude-ipc/                                           │
│ ├── inbox/<session-id>/   JSON messages per session      │
│ ├── sessions/             Session IDs + project + pane   │
│ └── processed/            Archived messages              │
└──────────────────────────────────────────────────────────┘
```

## Installation

```bash
git clone https://github.com/user/claude-ipc.git
cd claude-ipc
bash install.sh
```

## Quick Start

### 1. Start sessions

Each directory becomes its own pane. The session ID is derived from the directory name.

```bash
claude-sessions ~/Projects/api ~/Projects/frontend ~/Projects/shared

# Options
claude-sessions --layout=vertical --name=myproject ./backend ./frontend
claude-sessions .    # Single session in current directory
```

### 2. Start Claude Code

Run `claude` in each pane. `$CLAUDE_IPC_SESSION` is already set (e.g. `api`, `frontend`, `shared`).

### 3. Communicate

```
# In session "api":
/ipc-send frontend Build a new component for the /users endpoint

# In session "frontend":
/ipc-read
# -> Sees the task, works on it
/ipc-send api result: UserList component created in src/components/UserList.tsx

# In session "api":
/ipc-read
# -> Sees the result
```

## Slash Commands

| Command | Description |
|---------|-------------|
| `/ipc-status` | Show own session ID, all sessions, inbox status |
| `/ipc-send <id> <message>` | Send message/task/result (type auto-detected) |
| `/ipc-read` | Read and process inbox messages |
| `/ipc-ask <id> <question>` | Send question and wait for answer (60s timeout) |
| `/ipc-trigger <id> <prompt>` | Type prompt directly into another pane |

## CLI Reference

```
claude-ipc <command> [args]

register <id> [desc]                Register this session (auto-detects tmux pane)
send <to> <type> <payload>          Send a message (task|result|message|query)
read <id> [--wait] [--timeout=N]    Read & archive messages
peek <id>                           Preview inbox without consuming
list [id]                           List all inboxes or a specific one
sessions                            Show registered sessions
clear <id>                          Clear an inbox
inject <tmux-target> <text>         Send keystrokes to a tmux pane
watch <id>                          Live-watch an inbox (inotifywait or polling)
reset                               Clear all IPC state
```

```
claude-sessions [options] <dir1> [dir2] [dir3] ...

--layout=tiled|vertical|horizontal   Pane layout (default: tiled)
--name=<name>                        tmux session name (default: claude-multi)
```

### Environment Variables

| Variable | Description |
|----------|-------------|
| `CLAUDE_IPC_SESSION` | Own session ID (= directory name, set automatically) |
| `TMUX_PANE` | Used during registration for notifications |

## Communication Patterns

### Delegate a task

```
# api assigns a task to frontend:
[api]      /ipc-send frontend task: Create UserProfile component with avatar
[frontend] /ipc-read
[frontend] ... works on it ...
[frontend] /ipc-send api result: Done, see src/components/UserProfile.tsx
[api]      /ipc-read
```

### Question and answer

```
# frontend asks api:
[frontend] /ipc-ask api What fields does the /users response have?
# frontend now waits up to 60s for an answer

# api must run /ipc-read:
[api]      /ipc-read
[api]      /ipc-send frontend { id, name, email, avatar_url }

# frontend receives the answer automatically
```

### Direct trigger

```
# api types a prompt directly into shared's pane:
[api] /ipc-trigger shared Export all types from src/index.ts
```

### Parallel work

```
# api distributes tasks across projects:
[api] /ipc-send frontend task: Implement login page
[api] /ipc-send shared task: Create shared auth types
[api] ... works on auth endpoint itself ...

# Collect results later:
[api] /ipc-read
```

## Ghostty + tmux Tips

- **Pane navigation**: `Ctrl-b` + arrow keys
- **Pane zoom**: `Ctrl-b z` to toggle fullscreen
- **Scrollback**: `Ctrl-b [` for scroll mode

## Troubleshooting

**"command not found: claude-ipc"**
```bash
export PATH="${HOME}/.local/bin:${PATH}"  # add to .zshrc
```

**Messages not arriving**
```bash
claude-ipc sessions    # Sessions registered?
claude-ipc peek api    # Messages in inbox?
```

**Find session ID**
```bash
echo $CLAUDE_IPC_SESSION   # in terminal
/ipc-status                # in Claude Code
```

**tmux session already exists**
```bash
tmux kill-session -t claude-multi
```

## Requirements

- Bash 4+
- tmux
- Optional: `inotify-tools` (for `watch` with inotifywait instead of polling)
