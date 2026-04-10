---
name: emblem-memecoin-scout
description: >
  Memecoin discovery and risk assessment via Agent Hustle. Trending memecoins, Pump.fun
  new token alerts, rug-pull detection, holder analysis, and exit strategies. Use when
  the user wants to find new memecoins, check if a token is a rug pull, or scout trending
  low-cap tokens.
license: MIT
user-invocable: true
compatibility: >
  Requires Node.js >= 18.0.0, @emblemvault/agentwallet CLI, and internet access.
  Works on Claude Code, Cursor, Codex, OpenClaw, and other agents following the Agent Skills spec.
metadata:
  author: EmblemAI
  version: "1.0.0"
  homepage: https://emblemvault.dev
---

# Emblem Memecoin Scout

Memecoin discovery and risk assessment powered by **Agent Hustle**. Real-time new token alerts, trending memecoins, rug-pull detection, holder analysis, and exit strategy planning via Pump.fun and social data.

**Requires**: `npm install -g @emblemvault/agentwallet`

---

## Quick Start

```bash
npm install -g @emblemvault/agentwallet

# What's trending in memecoins
emblemai --agent --profile default -m "What memecoins are trending on Solana right now with volume and holder count?"

# Risk check a specific token
emblemai --agent --profile default -m "Is this token safe? Analyze the risk for [TOKEN_ADDRESS] on Solana"
```

**Trigger phrases:**
- "What memecoins are trending?"
- "Find new tokens on Pump.fun"
- "Is this token a rug pull?"
- "Scout memecoins on Solana"
- "What new tokens launched today?"

---

## Capabilities

### Discovery
- **Pump.fun integration** — Real-time new token launches
- **Trending detection** — Identify tokens gaining momentum
- **Volume tracking** — Monitor trading volume spikes
- **Social tracking** — Telegram and Discord activity monitoring

### Risk Assessment
- **Rug-pull detection** — Contract analysis and red flag identification
- **Holder distribution** — Wallet concentration and whale tracking
- **Liquidity analysis** — LP lock status, liquidity depth
- **Risk scoring** — Automated risk grade for each token

### Analysis
- **Early detection** — Identify tokens before they trend
- **Social sentiment** — Community growth and engagement metrics
- **Price action** — Volume, market cap, and holder growth correlation

---

## Workflow: Scout and Evaluate

### Step 1: Discovery
Find what's gaining traction.
```bash
emblemai --agent --profile default -m "Show the top trending memecoins on Solana in the last 24 hours with volume, market cap, and holder count"
```

### Step 2: Risk Check
Evaluate safety before any position.
```bash
emblemai --agent --profile default -m "Analyze the risk of [TOKEN_NAME] on Solana — check holder concentration, LP lock, contract safety, and give a risk score"
```

### Step 3: Social Validation
Cross-check with social data.
```bash
emblemai --agent --profile default -m "What is the social media activity for [TOKEN_NAME]? Check Twitter mentions, Telegram growth, and community sentiment"
```

### Step 4: Entry Decision
If risk is acceptable, get price context.
```bash
emblemai --agent --profile default -m "Show price chart, volume trend, and key levels for [TOKEN_NAME] on Solana"
```

### Step 5: Exit Strategy
Plan the exit before entering.
```bash
emblemai --agent --profile default -m "Suggest an exit strategy for a $50 position in [TOKEN_NAME] — take profit levels and stop loss"
```

---

## Scouting Patterns

### New Launches
```bash
emblemai --agent --profile default -m "What are the newest tokens launched on Pump.fun in the last hour with the most volume?"
```

### Whale Watch
```bash
emblemai --agent --profile default -m "Are any large wallets accumulating memecoins on Solana right now?"
```

### Multi-Chain Memes
```bash
emblemai --agent --profile default -m "Compare trending memecoins across Solana, Base, and BSC — which chain has the most activity?"
```

### Red Flag Detection
```bash
emblemai --agent --profile default -m "Check [TOKEN_ADDRESS] on Solana for red flags — honeypot, mint authority, concentrated holders, locked LP"
```

---

## Risk Levels

When the agent reports risk, use this framework:

| Level | Meaning | Action |
|-------|---------|--------|
| Low | Verified contract, dispersed holders, locked LP | Proceed with caution |
| Medium | Some concentration or unlocked LP | Small position only |
| High | Major red flags (concentrated, no LP lock) | Avoid |
| Critical | Honeypot/rug indicators detected | Do not interact |

---

## Communication Tips

Be specific about what you're looking for:

| Bad | Good |
|-----|------|
| `"memes"` | `"What memecoins are trending on Solana by volume in the last 24h?"` |
| `"safe?"` | `"Analyze risk for [TOKEN_ADDRESS] — holder distribution, LP lock, contract safety"` |
| `"new coins"` | `"Show newest Pump.fun launches in the last hour with >$10k volume"` |

---

## Safety Notice

Memecoins are extremely high risk. This skill provides data and analysis to inform decisions — it does not guarantee safety. Always:
- Never invest more than you can afford to lose
- Verify contract addresses independently
- Check multiple data sources before acting
- Use stop-losses on any position

---

## Helper Script

```bash
bash scripts/memecoin-scan.sh
```

See [scripts/memecoin-scan.sh](scripts/memecoin-scan.sh) for trending memecoin scanning.

---

## Links

- [Agent Wallet CLI](https://www.npmjs.com/package/@emblemvault/agentwallet)
- [EmblemVault Docs](https://emblemvault.dev)
- [Agent Hustle](https://agenthustle.ai)
