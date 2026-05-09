# Stdio MCP bridge to the hosted EmblemAI MCP server.
#
# Glama and similar sandboxed MCP runners use their own base image and
# ignore this file. It exists for local testing and self-hosted users
# who want a containerised stdio bridge.
#
# The bundled, dependency-inlined entry point is at
# ./mcp-bridge/dist/index.js (regenerate with `npm run build` from
# ./mcp-bridge). For sandbox runners that clone the repo, point the
# CMD at that file directly — no install step needed.
#
# Auth env (optional for tools/call; tools/list works anonymously):
#   EMBLEMAI_API_KEY              — full read+write, no expiry
#   EMBLEMAI_BEARER               — JWT, read-only, ~15 min
#   EMBLEMAI_TRANSACTIONS=enabled — surface state-changing tools

FROM node:20-alpine
WORKDIR /app

COPY mcp-bridge/dist/ ./

ENTRYPOINT ["node", "index.js"]
