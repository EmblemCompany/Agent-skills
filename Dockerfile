# Bridges a stdio MCP runner (e.g. Glama, Claude Desktop, mcp-remote consumers)
# to the hosted EmblemAI MCP server at https://emblemvault.ai/api/mcp.
#
# Read-only methods (initialize, ping, tools/list, notifications/*) are
# anonymous, so the bridge can introspect the full tool catalog without an
# OAuth flow. State-changing tools (tools/call) still require a bearer token
# or x-api-key on the upstream MCP endpoint.

FROM node:20-alpine

RUN npm install -g mcp-remote@latest

ENTRYPOINT ["mcp-remote"]
CMD ["https://emblemvault.ai/api/mcp"]
