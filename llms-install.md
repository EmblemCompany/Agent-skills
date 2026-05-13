# EmblemAI MCP — Install for Cline (and other LLM-driven MCP clients)

This file is the single source-of-truth install path for any MCP client agent (Cline, Claude Code, Cursor, Windsurf, Gemini CLI) configuring **EmblemAI** as a Model Context Protocol server.

EmblemAI is a **hosted HTTP MCP server** at `https://emblemvault.ai/api/mcp`. No local process to run.

---

## Quick install — drop into MCP client config

### `.mcp.json` (Cline, Claude Code, Cursor, generic)

Read-only (OAuth flow opens in browser on first use):

```json
{
  "mcpServers": {
    "emblemai": {
      "type": "http",
      "url": "https://emblemvault.ai/api/mcp"
    }
  }
}
```

Read + write (requires API key from https://emblemvault.ai → Settings → Vault Access Key):

```json
{
  "mcpServers": {
    "emblemai": {
      "type": "http",
      "url": "https://emblemvault.ai/api/mcp",
      "headers": {
        "x-api-key": "YOUR_API_KEY",
        "x-mcp-transactions": "enabled"
      }
    }
  }
}
```

### One-command (Claude Code)

```bash
claude mcp add --transport http EmblemAI https://emblemvault.ai/api/mcp
```

For headless/CI:

```bash
claude mcp add --transport http EmblemAI https://emblemvault.ai/api/mcp \
  --header "x-api-key: YOUR_API_KEY"
```

---

## Auth modes

| Mode | Header | Scope | Use case |
|------|--------|-------|----------|
| OAuth (default) | none | `vault:read` | interactive sessions, no setup |
| API key | `x-api-key: <key>` | `vault:read vault:write` | unattended agents, transactions |

**OAuth tokens are ~15 min and rotate via browser popup** — pick API key for cron jobs, scheduled agents, or any unattended flow.

## Transaction tools

State-changing tools (swap, transfer, mint, approve) require **BOTH**:

1. `x-api-key` auth (OAuth Bearer tokens can't pass the `vault:write` gate)
2. `x-mcp-transactions: enabled` request header — exposes them in `tools/list` with a `-transaction` suffix

Clients that want to opt OUT of transaction tools can wildcard-filter `*-transaction` after listing.

## Tool surface

200+ tools across 7 blockchains:

| Chain | Coverage |
|-------|----------|
| Solana | balance, swap, transfer, token search, gem discovery, memecoin scout |
| Ethereum | balance, swap, NFT (OpenSea), Clanker tokens |
| Base | balance, swap, Clanker discovery |
| BSC | balance, swap, FourMeme memecoins |
| Polygon | balance, swap |
| Hedera | balance, swap, memecoin discovery |
| Bitcoin | balance, Ordinals/Inscriptions, Runes, BRC-20, Alkanes, SRC-20, Stamps |

Cross-cutting:
- Market intelligence: Birdeye, CoinGlass, Nansen, LunarCrush
- DeFi: yield, LP, staking
- Prediction markets: Polymarket
- Cross-chain: ChangeNow
- Wallet management (EmblemVault): collections, vaults, deposit addresses

## Tool filtering

If you want a smaller surface than 200 tools, set `EMBLEMAI_TOOLS_FILTER` (env var on the stdio bridge) or use `x-mcp-tools-filter` request header on the HTTP endpoint. Comma-separated shell-style globs:

```
EMBLEMAI_TOOLS_FILTER="bitcoin*,solana*"
EMBLEMAI_TOOLS_FILTER="*Balances,*SwapQuote"
```

## Verify install

After config + client restart:

1. The client should report **200+ EmblemAI tools** discovered.
2. Try a read-only call:
   - "What's the current price of SOL?"
   - "Get trending Solana tokens"
   - "Show top Bitcoin Ordinals collections by volume"
3. If you set up API key + transaction header, try a quote:
   - "Quote me a swap of 1 SOL for USDC"

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `tools/list` shows 0 tools | Check the URL — must be exactly `https://emblemvault.ai/api/mcp` |
| `401 Unauthorized` on a transaction tool | Add `x-mcp-transactions: enabled` header + use API key auth |
| OAuth flow loops without completing | Clear client OAuth cache, retry; ensure pop-ups allowed |
| Tool call hangs > 30s | Likely upstream RPC; check `https://emblemvault.ai/api/health` |

## Per-client install matrix

Full setup guide per client (Claude Desktop bridge, Cursor, Windsurf, Gemini CLI, ChatGPT Connectors, Cline): https://emblemvault.ai/docs/mcp

## Links

- **Endpoint:** `https://emblemvault.ai/api/mcp`
- **Repo:** https://github.com/EmblemCompany/Agent-skills (MIT)
- **Smithery (quality 84):** https://smithery.ai/server/emblem-mcp--emblemai
- **Glama:** https://glama.ai/mcp/servers/EmblemCompany/Agent-skills
- **LobeHub:** https://lobehub.com/mcp/emblemcompany-agent-skills
- **Docs:** https://emblemvault.ai/docs/mcp
