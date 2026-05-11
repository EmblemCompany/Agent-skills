#!/usr/bin/env node
/**
 * Stdio MCP server that bridges to the hosted EmblemAI MCP server.
 *
 * Tool catalog (initialize, tools/list) is fetched from the hosted endpoint
 * with no auth required (anonymous read methods on /api/mcp). Tool execution
 * (tools/call) forwards a bearer token or API key supplied via env:
 *
 *   EMBLEMAI_API_KEY        — vault API key (full read+write, no expiry)
 *   EMBLEMAI_BEARER         — JWT (read-only, ~15 min lifetime)
 *   EMBLEMAI_TRANSACTIONS   — set to "enabled" to expose state-changing tools
 *   EMBLEMAI_TOOLS_FILTER   — comma-separated glob patterns to restrict the
 *                             exposed tool surface, e.g.
 *                                 "bitcoin*,*Balances"
 *                                 "solana*,base*"
 *                             Tools whose name matches ANY pattern survive
 *                             tools/list; tools/call is also gated against
 *                             the same patterns. Omit / empty → full surface.
 *                             Patterns use shell-style globs (* and ?).
 *
 * Without credentials, tools/call returns a clear instruction to set one of
 * the env vars. tools/list still works fully and registries can score the
 * catalog without the user authenticating.
 */

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

const UPSTREAM_URL = "https://emblemvault.ai/api/mcp";
const PROTOCOL_VERSION = "2025-06-18";
const SERVER_NAME = "emblemai";
const SERVER_VERSION = "1.1.0";

// CLI args accepted for compatibility with sandbox runners that mandate a
// non-empty CMD (e.g. Glama's release form). Recognised: --stdio (default,
// no-op), --version (print + exit), --help. Unknown args are ignored.
const argv = process.argv.slice(2);
if (argv.includes("--version")) {
  process.stdout.write(`${SERVER_NAME} ${SERVER_VERSION}\n`);
  process.exit(0);
}
if (argv.includes("--help")) {
  process.stdout.write(
    `${SERVER_NAME} ${SERVER_VERSION} — stdio MCP bridge to ${UPSTREAM_URL}\n` +
      "Flags: --stdio (default), --version, --help\n" +
      "Env: EMBLEMAI_API_KEY, EMBLEMAI_BEARER, EMBLEMAI_TRANSACTIONS,\n" +
      "     EMBLEMAI_TOOLS_FILTER (comma-separated globs, e.g. 'bitcoin*,*Balances')\n",
  );
  process.exit(0);
}

function globToRegExp(glob) {
  const escaped = glob.replace(/[.+^${}()|[\]\\]/g, "\\$&");
  const pattern = escaped.replace(/\*/g, ".*").replace(/\?/g, ".");
  return new RegExp(`^${pattern}$`);
}

const TOOLS_FILTER_PATTERNS = (() => {
  const raw = process.env.EMBLEMAI_TOOLS_FILTER;
  if (!raw) return null;
  const patterns = raw
    .split(",")
    .map((p) => p.trim())
    .filter(Boolean);
  if (patterns.length === 0) return null;
  return patterns.map(globToRegExp);
})();

function isToolAllowed(name) {
  if (!TOOLS_FILTER_PATTERNS) return true;
  return TOOLS_FILTER_PATTERNS.some((re) => re.test(name));
}

function buildUpstreamHeaders() {
  const headers = {
    "Content-Type": "application/json",
    Accept: "application/json, text/event-stream",
    "MCP-Protocol-Version": PROTOCOL_VERSION,
  };
  if (process.env.EMBLEMAI_BEARER) {
    headers.Authorization = `Bearer ${process.env.EMBLEMAI_BEARER}`;
  }
  if (process.env.EMBLEMAI_API_KEY) {
    headers["x-api-key"] = process.env.EMBLEMAI_API_KEY;
  }
  if (process.env.EMBLEMAI_TRANSACTIONS === "enabled") {
    headers["x-mcp-transactions"] = "enabled";
  }
  return headers;
}

async function forward(method, params) {
  const response = await fetch(UPSTREAM_URL, {
    method: "POST",
    headers: buildUpstreamHeaders(),
    body: JSON.stringify({
      jsonrpc: "2.0",
      method,
      params,
      id: Date.now(),
    }),
  });

  const text = await response.text();
  let body;
  try {
    body = JSON.parse(text);
  } catch {
    throw new Error(
      `Upstream returned non-JSON (status ${response.status}): ${text.slice(0, 200)}`,
    );
  }

  if (body.error) {
    const err = new Error(body.error.message ?? "Upstream MCP error");
    err.code = body.error.code;
    err.data = body.error.data;
    throw err;
  }
  return body.result;
}

const server = new Server(
  { name: SERVER_NAME, version: SERVER_VERSION },
  { capabilities: { tools: {} } },
);

server.setRequestHandler(ListToolsRequestSchema, async () => {
  const result = await forward("tools/list", {});
  if (!TOOLS_FILTER_PATTERNS) return result;
  const tools = Array.isArray(result?.tools) ? result.tools : [];
  return { ...result, tools: tools.filter((t) => isToolAllowed(t?.name)) };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const requestedName = request?.params?.name ?? "";
  if (!isToolAllowed(requestedName)) {
    return {
      content: [
        {
          type: "text",
          text:
            `Tool '${requestedName}' is not exposed by this listing ` +
            "(filtered out by EMBLEMAI_TOOLS_FILTER). Run tools/list to see " +
            "the currently exposed surface.",
        },
      ],
      isError: true,
    };
  }
  const hasCreds =
    Boolean(process.env.EMBLEMAI_API_KEY) ||
    Boolean(process.env.EMBLEMAI_BEARER);
  if (!hasCreds) {
    return {
      content: [
        {
          type: "text",
          text:
            "EmblemAI MCP requires authentication for tool execution. Set " +
            "EMBLEMAI_API_KEY (preferred for unattended use) or EMBLEMAI_BEARER " +
            "in the MCP client's env block. Generate an API key at " +
            "https://emblemvault.ai (Settings → Vault Access Key). For " +
            "state-changing tools also set EMBLEMAI_TRANSACTIONS=enabled.",
        },
      ],
      isError: true,
    };
  }
  return await forward("tools/call", request.params);
});

await server.connect(new StdioServerTransport());
