# claude-ipc

Inter-Process Communication fuer mehrere Claude Code Sessions in tmux.
Jede Session arbeitet in ihrem eigenen Projektverzeichnis.

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
│ ├── inbox/<session-id>/   JSON-Nachrichten pro Session   │
│ ├── sessions/             Session-IDs + Projekt + Pane   │
│ └── processed/            Archivierte Nachrichten        │
└──────────────────────────────────────────────────────────┘
```

## Installation

```bash
git clone https://github.com/user/claude-ipc.git
cd claude-ipc
bash install.sh
```

## Quick Start

### 1. Sessions starten

Jedes Verzeichnis wird ein eigenes Pane. Die Session-ID wird vom Verzeichnisnamen abgeleitet.

```bash
claude-sessions ~/Projects/api ~/Projects/frontend ~/Projects/shared

# Optionen
claude-sessions --layout=vertical --name=myproject ./backend ./frontend
claude-sessions .    # Eine Session im aktuellen Verzeichnis
```

### 2. Claude Code starten

In jedem Pane `claude` ausfuehren. `$CLAUDE_IPC_SESSION` ist bereits gesetzt (z.B. `api`, `frontend`, `shared`).

### 3. Kommunizieren

```
# In Session "api":
/ipc-send frontend Bau eine neue Komponente fuer den /users Endpoint

# In Session "frontend":
/ipc-read
# -> Sieht die Aufgabe, arbeitet daran
/ipc-send api result: UserList-Komponente erstellt in src/components/UserList.tsx

# In Session "api":
/ipc-read
# -> Sieht das Ergebnis
```

## Slash Commands

| Command | Beschreibung |
|---------|-------------|
| `/ipc-status` | Eigene Session-ID, alle Sessions, Inbox-Status |
| `/ipc-send <id> <nachricht>` | Nachricht/Aufgabe/Ergebnis senden (Typ wird automatisch erkannt) |
| `/ipc-read` | Inbox lesen und Nachrichten verarbeiten |
| `/ipc-ask <id> <frage>` | Frage senden und auf Antwort warten (60s Timeout) |
| `/ipc-trigger <id> <prompt>` | Prompt direkt in anderes Pane tippen |

## CLI-Referenz

```
claude-ipc <command> [args]

register <id> [desc]                Session registrieren (auto-detect tmux pane)
send <to> <type> <payload>          Nachricht senden (task|result|message|query)
read <id> [--wait] [--timeout=N]    Nachrichten lesen & archivieren
peek <id>                           Inbox anschauen ohne zu konsumieren
list [id]                           Alle oder eine Inbox auflisten
sessions                            Registrierte Sessions anzeigen
clear <id>                          Inbox leeren
inject <tmux-target> <text>         Keystrokes in tmux-Pane senden
watch <id>                          Live-Watch (inotifywait oder Polling)
reset                               Alles zuruecksetzen
```

```
claude-sessions [options] <dir1> [dir2] [dir3] ...

--layout=tiled|vertical|horizontal   Pane-Layout (default: tiled)
--name=<name>                        tmux-Session-Name (default: claude-multi)
```

### Umgebungsvariablen

| Variable | Beschreibung |
|----------|-------------|
| `CLAUDE_IPC_SESSION` | Eigene Session-ID (= Verzeichnisname, automatisch gesetzt) |
| `TMUX_PANE` | Wird beim Registrieren fuer Notifications genutzt |

## Kommunikations-Patterns

### Aufgabe delegieren

```
# api gibt frontend eine Aufgabe:
[api]      /ipc-send frontend task: Erstelle UserProfile-Komponente mit Avatar
[frontend] /ipc-read
[frontend] ... arbeitet ...
[frontend] /ipc-send api result: Fertig, siehe src/components/UserProfile.tsx
[api]      /ipc-read
```

### Frage und Antwort

```
# frontend fragt api:
[frontend] /ipc-ask api Welche Felder hat der /users Response?
# frontend wartet jetzt bis zu 60s auf Antwort

# api muss /ipc-read ausfuehren:
[api]      /ipc-read
[api]      /ipc-send frontend { id, name, email, avatar_url }

# frontend bekommt die Antwort automatisch
```

### Direkt triggern

```
# api tippt einen Prompt direkt in shared's Pane:
[api] /ipc-trigger shared Exportiere alle Types aus src/index.ts
```

### Paralleles Arbeiten

```
# api verteilt Aufgaben an verschiedene Projekte:
[api] /ipc-send frontend task: Implementiere Login-Page
[api] /ipc-send shared task: Erstelle shared Auth-Types
[api] ... arbeitet selbst am Auth-Endpoint ...

# Spaeter Ergebnisse einsammeln:
[api] /ipc-read
```

## Ghostty + tmux Tipps

- **Pane Navigation**: `Ctrl-b` + Pfeiltasten
- **Pane Zoom**: `Ctrl-b z` zum Vergroessern/Verkleinern
- **Scrollback**: `Ctrl-b [` fuer Scroll-Modus

## Troubleshooting

**"command not found: claude-ipc"**
```bash
export PATH="${HOME}/.local/bin:${PATH}"  # in .zshrc eintragen
```

**Nachrichten kommen nicht an**
```bash
claude-ipc sessions    # Sessions registriert?
claude-ipc peek api    # Nachrichten in Inbox?
```

**Session-ID herausfinden**
```bash
echo $CLAUDE_IPC_SESSION   # im Terminal
/ipc-status                # in Claude Code
```

**tmux-Session existiert schon**
```bash
tmux kill-session -t claude-multi
```

## Voraussetzungen

- Bash 4+
- tmux
- Optional: `inotify-tools` (fuer `watch` mit inotifywait statt Polling)
