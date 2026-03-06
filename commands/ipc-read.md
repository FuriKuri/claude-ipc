---
allowed-tools:
  - Bash
---
Read incoming IPC messages.

First run `claude-ipc peek "$CLAUDE_IPC_SESSION"` to preview.

If messages exist, run `claude-ipc read "$CLAUDE_IPC_SESSION"` to consume them. Parse each JSON message and handle by type:
- **task**: Present the task. Offer to work on it. When done, suggest `/ipc-send <sender> result: <summary>`.
- **query**: Present the question. Formulate an answer. Suggest `/ipc-send <sender> <answer>`.
- **result**: Display results clearly.
- **message**: Present the information.

If inbox is empty, suggest: `claude-ipc read "$CLAUDE_IPC_SESSION" --wait --timeout=30`
