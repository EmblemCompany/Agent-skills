# reflexive

AI-powered introspection and debugging for running applications. Reflexive embeds Claude inside your app or child process so it can inspect logs, read and edit files, set breakpoints, and respond to runtime events.

**Supported runtimes:** Node.js, Python, Go, .NET, Rust

## Installation

```bash
npm install reflexive
```

Or run directly with `npx`:

```bash
npx reflexive ./server.js
```

**Authentication:** Use Claude Code CLI auth (`claude`) or set `ANTHROPIC_API_KEY`.

## Quick Start

```bash
# Basic read-only monitoring
npx reflexive ./server.js

# Development mode with file write + shell access
npx reflexive --write --shell --watch ./server.js

# Python app with debugging
npx reflexive --debug ./app.py

# Open the dashboard automatically
npx reflexive --write --open ./server.js
```

Open `http://localhost:3099` to chat with the app, inspect logs, and manage breakpoints.

## Safety Model

Default mode is read-only. Reflexive can see logs and read files, but it cannot mutate code or run shell commands unless you explicitly opt in.

| Flag | Enables |
|------|---------|
| `--write` | File modification |
| `--shell` | Shell command execution |
| `--inject` | Deep Node.js instrumentation (console, HTTP, GC, event loop) |
| `--eval` | Runtime code evaluation in Node.js |
| `--debug` | Breakpoints, stepping, and scope inspection |

## CLI Reference

```bash
reflexive [options] [entry-file] [-- app-args...]
```

### Common options

| Option | Description |
|--------|-------------|
| `-p, --port <port>` | Dashboard port (default: `3099`) |
| `-h, --host <host>` | Dashboard host (default: `localhost`) |
| `-o, --open` | Open the dashboard in a browser |
| `-w, --watch` | Restart on file changes |
| `-i, --interactive` | Proxy stdin/stdout for interactive apps |
| `--mcp` | Run as an MCP server for external AI agents |
| `--no-webui` | Disable the dashboard in MCP mode |
| `--inject` | Enable deep Node.js instrumentation |
| `--eval` | Allow runtime eval in Node.js |
| `-d, --debug` | Enable multi-language debugging |
| `--write` | Allow file writes |
| `--shell` | Allow shell execution |
| `--node-args <args>` | Pass extra args to Node.js |

## Operating Modes

### Local CLI mode

Launches your target app as a child process and exposes logs, file access, and chat in the dashboard.

```bash
npx reflexive ./server.js
```

### MCP server mode

Run Reflexive as a stdio MCP server so external agents can control an app.

```bash
npx reflexive --mcp --write --shell ./server.js
```

Useful with Claude Code, Claude Desktop, and any MCP-compatible client. Reflexive supports dynamic app switching through the `run_app` tool, so the MCP server does not need to restart when you move between apps.

#### Claude Code integration

```bash
claude mcp add --transport stdio reflexive -- npx reflexive --mcp --write --shell --debug
```

Or add to `.mcp.json`:

```json
{
  "reflexive": {
    "command": "npx",
    "args": ["reflexive", "--mcp", "--write", "--shell", "--debug"]
  }
}
```

### Library mode

Embed Reflexive directly inside a Node.js or TypeScript app.

```typescript
import { makeReflexive } from 'reflexive';

const r = makeReflexive({
  title: 'My App',
  webUI: true,
  port: 3099,
});

r.setState('activeUsers', 42);
const answer = await r.chat('Summarize the current state');
```

You can also provide custom tools:

```typescript
import { makeReflexive } from 'reflexive';
import { tool } from '@anthropic-ai/claude-agent-sdk';
import { z } from 'zod';

const r = makeReflexive({
  tools: [
    tool(
      'get_order',
      'Look up an order',
      { orderId: z.string() },
      async ({ orderId }) => ({
        content: [{ type: 'text', text: JSON.stringify(orders.get(orderId)) }],
      })
    ),
  ],
});
```

## External MCP Server Support

Reflexive can discover and connect to external MCP servers from:

- Project `.mcp.json`
- User-level `~/.mcp.json`
- Claude Code plugin directories

The embedded agent can enable servers dynamically with tools like `list_available_mcp_servers` and `enable_mcp_server`.

## MCP Tools

When Reflexive is running as an MCP server, the connected agent can use tools such as:

- `run_app`
- `get_process_state`
- `get_output_logs`
- `restart_process`
- `stop_process`
- `start_process`
- `send_input`
- `search_logs`
- `read_file`
- `list_directory`
- `write_file` / `edit_file` (requires `--write`)
- `exec_shell` (requires `--shell`)
- `chat`
- `reflexive_self_knowledge`
- `list_available_mcp_servers`
- `enable_mcp_server`

With `--debug`, additional debugger tools are available for breakpoints, resume, stepping, and variable inspection.

## Multi-Language Debugging

Reflexive uses the Debug Adapter Protocol to support multiple languages.

| Language | Debugger | Notes |
|----------|----------|-------|
| Node.js / TypeScript | V8 Inspector | Built in |
| Python | debugpy | Install with `pip install debugpy` |
| Go | Delve | Install with `go install github.com/go-delve/delve/cmd/dlv@latest` |
| .NET | netcoredbg | Install from netcoredbg releases |
| Rust | CodeLLDB | Install with `cargo install codelldb` |

Example debugging flow:

```bash
npx reflexive --debug ./server.js
```

Then ask the agent to set a breakpoint, inspect scope variables, evaluate expressions, and step through code.

## Injection Mode (Node.js only)

With `--inject`, Reflexive captures additional runtime information without changing application code:

- Console output
- Incoming and outgoing HTTP activity
- Garbage collection events
- Event loop latency
- Uncaught errors

Apps can optionally interact with the injected API:

```javascript
if (process.reflexive) {
  process.reflexive.setState('db.connections', pool.size);
  process.reflexive.emit('userSignup', { userId: 123 });
}
```

## Dashboard

The web dashboard provides:

- Real-time chat with the agent
- Live log streaming
- Process start/stop/restart controls
- Watch pattern management
- Breakpoint controls (when `--debug` is enabled)

## Python SDK

The project README also points to a Python SDK (`./python-sdk/`) for embedding Reflexive in Python apps.
