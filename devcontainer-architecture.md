# Dev Container Architecture: How Hack Development Works in VS Code

## The Big Picture

When you develop Hack inside a VS Code dev container, your system is split across two environments: your Mac (which runs the UI) and a Docker container (which runs everything else). VS Code bridges the gap by splitting itself into two halves.

```
┌──────────────────────────────────────────────────────────────┐
│                      Your Mac (macOS)                        │
│                                                              │
│  ┌────────────────────────────────────┐                      │
│  │           VS Code UI              │                      │
│  │                                    │                      │
│  │  - The window you see and click    │                      │
│  │  - Renders squiggles, tooltips,    │                      │
│  │    autocomplete menus              │                      │
│  │  - Sends your keystrokes/actions   │                      │
│  └─────────────────┬──────────────────┘                      │
│                    │                                          │
│                    │ persistent connection (pipe/websocket)   │
│                    │                                          │
│  ┌─────────────────▼──────────────────────────────────────┐  │
│  │           Docker Container (Ubuntu 20.04)               │  │
│  │                                                         │  │
│  │  ┌───────────────────────────────────────────────────┐  │  │
│  │  │             VS Code Server                        │  │  │
│  │  │          (headless, no window)                     │  │  │
│  │  │                                                   │  │  │
│  │  │  ┌─────────────────────────────────────────────┐  │  │  │
│  │  │  │    vscode-hack extension                    │  │  │  │
│  │  │  │    (pranayagarwal.vscode-hack)              │  │  │  │
│  │  │  │                                             │  │  │  │
│  │  │  │  Runs as a module inside VS Code Server.    │  │  │  │
│  │  │  │  No network boundary between them — the     │  │  │  │
│  │  │  │  extension calls VS Code APIs directly.     │  │  │  │
│  │  │  └──────────────────┬──────────────────────────┘  │  │  │
│  │  └─────────────────────┼─────────────────────────────┘  │  │
│  │                        │                                 │  │
│  │                        │ LSP (JSON-RPC over stdio)       │  │
│  │                        │                                 │  │
│  │  ┌─────────────────────▼─────────────────────────────┐  │  │
│  │  │            hh_server (daemon)                      │  │  │
│  │  │                                                   │  │  │
│  │  │  - Long-running background process                │  │  │
│  │  │  - Watches and indexes all .hack files            │  │  │
│  │  │  - Performs type checking                         │  │  │
│  │  │  - Responds to queries ("type at this position?") │  │  │
│  │  │  - Pushes diagnostics (errors) to the extension   │  │  │
│  │  └───────────────────────────────────────────────────┘  │  │
│  │                        ▲                                 │  │
│  │                        │ starts it (first time only)     │  │
│  │                        │                                 │  │
│  │  ┌─────────────────────┴─────────────────────────────┐  │  │
│  │  │            hh_client (CLI tool)                    │  │  │
│  │  │                                                   │  │  │
│  │  │  - Run manually in the terminal                   │  │  │
│  │  │  - Launches hh_server if it's not running         │  │  │
│  │  │  - Can also query hh_server for errors            │  │  │
│  │  └───────────────────────────────────────────────────┘  │  │
│  │                                                         │  │
│  │  ┌───────────────────────────────────────────────────┐  │  │
│  │  │            hhvm (runtime)                          │  │  │
│  │  │                                                   │  │  │
│  │  │  - Executes .hack files ("hhvm hello.hack")       │  │  │
│  │  │  - Completely separate from type checking          │  │  │
│  │  └───────────────────────────────────────────────────┘  │  │
│  │                                                         │  │
│  │  /workspaces/learn_hack/ ◄── mounted from Mac ──►      │  │
│  └─────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

## Communication Between Components

There are two real boundaries in this system:

### 1. VS Code UI ↔ VS Code Server

A persistent bidirectional connection (pipe or websocket) between your Mac and the container. The UI sends user actions ("user hovered at line 5") and receives rendering instructions ("show this tooltip"). This is what makes it feel like VS Code is running locally even though the "brain" is in the container.

### 2. Extension ↔ hh_server

Uses **LSP** (Language Server Protocol) — an open standard for editor-to-language-server communication. It's JSON-RPC messages over stdio. Traffic flows both directions:

- **Extension → hh_server** (on demand): Triggered by your actions. Hover over a variable → "what's the type here?" Type a dot → "what completions are available?" Cmd+click → "where is this defined?"
- **hh_server → extension** (push): When hh_server finishes rechecking files, it pushes diagnostics (errors/warnings) to the extension without being asked.

### No boundary: Extension ↔ VS Code Server

There is no network protocol here. The extension runs *inside* VS Code Server as a loaded module/plugin. It calls VS Code APIs directly in-process, like:

```typescript
// Simplified example of how the extension works
vscode.languages.registerHoverProvider('hack', {
  provideHover(document, position) {
    // Ask hh_server "what's at this position?" via LSP
    const result = hh_client.query(document, position);
    // Return it directly to VS Code Server via the API
    return new vscode.Hover(result.type);
  }
});
```

When you hover over a variable, VS Code Server calls the extension's `provideHover`. The extension asks hh_server, gets the answer, and returns it. VS Code Server then sends the result to the UI for rendering.

## How a Hover Tooltip Happens (End to End)

```
You hover over a variable in the editor
        │
        ▼
VS Code UI sends "hover at line 5, col 12" to VS Code Server
        │
        ▼
VS Code Server calls the extension's provideHover()
        │
        ▼
Extension sends LSP request to hh_server: "what's at this position?"
        │
        ▼
hh_server looks up its index, returns: "int"
        │
        ▼
Extension returns new vscode.Hover("int") to VS Code Server
        │
        ▼
VS Code Server sends render instruction to VS Code UI
        │
        ▼
You see a tooltip showing "int"
```

## How Type Error Squiggles Appear

```
You save a file (or just edit it)
        │
        ▼
hh_server detects the file change (it watches the filesystem)
        │
        ▼
hh_server rechecks types, finds errors
        │
        ▼
hh_server pushes diagnostics to the extension via LSP
        │
        ▼
Extension passes them to VS Code Server via the API
        │
        ▼
VS Code Server sends render instructions to VS Code UI
        │
        ▼
You see red squiggles under the errors
```

## Why You Need to Run `hh_client` Once

`hh_server` is a daemon that doesn't start automatically. The VS Code extension expects it to already be running — it doesn't launch it. When you run `hh_client` in the terminal, it boots `hh_server` as a background process. After that, the extension can connect and everything works.

You only need to do this once per container session. If you want to automate it, you could add it to your `postStartCommand` in `devcontainer.json`.
