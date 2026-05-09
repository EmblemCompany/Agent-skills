# Stdio MCP bridge to the hosted EmblemAI MCP server.
#
# Builds the @emblemvault/mcp stdio adapter (./mcp-bridge) which speaks
# JSON-RPC over stdio and forwards requests to https://emblemvault.ai/api/mcp.
#
# Anonymous read methods (initialize, ping, tools/list) work without
# credentials. Tool execution requires one of:
#   EMBLEMAI_API_KEY  — vault access key (full read+write, recommended)
#   EMBLEMAI_BEARER   — JWT (read-only, ~15 min)
# Optional:
#   EMBLEMAI_TRANSACTIONS=enabled  — surface state-changing tools

FROM node:20-alpine
WORKDIR /app

COPY mcp-bridge/package.json mcp-bridge/package-lock.json ./
RUN npm ci --omit=dev --omit=optional

COPY mcp-bridge/ ./

ENTRYPOINT ["node", "index.js"]
CMD ["--stdio"]
