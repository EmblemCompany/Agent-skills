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
const SERVER_VERSION = "1.0.0";

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
  return await forward("tools/list", {});
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
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
