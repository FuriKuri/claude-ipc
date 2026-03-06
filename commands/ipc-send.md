---
allowed-tools:
  - Bash
---
Send an IPC message to another Claude session.

Parse $ARGUMENTS: first word is the target session ID, the rest is the message content.

Determine the message type automatically:
- If the content starts with "result:" or references a completed task → type "result"
- If it's a question (ends with ?) → type "query"
- If it's an imperative instruction or starts with "task:" → type "task"
- Otherwise → type "message"

Run: `claude-ipc send <target> <type> <content>`

Confirm the message was sent. Tip: send file paths instead of full contents.
