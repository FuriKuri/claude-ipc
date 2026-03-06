---
allowed-tools:
  - Bash
---
Ask another Claude session a question and wait for the answer.

Parse $ARGUMENTS: first word is the target session ID, the rest is the question.

1. Run: `claude-ipc send <target> query <question>`
2. Then wait: `claude-ipc read "$CLAUDE_IPC_SESSION" --wait --timeout=60`

Note: The other session must actively run `/ipc-read` to see and answer the question.
