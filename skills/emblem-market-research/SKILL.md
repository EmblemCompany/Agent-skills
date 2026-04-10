---
name: emblem-market-research
description: >
  Crypto market intelligence via Agent Hustle. Trending tokens, social sentiment, technical
  analysis, on-chain analytics, and real-time market data from CoinGlass, DeFiLlama, Birdeye,
  and LunarCrush. Use when the user wants market data, trending tokens, sentiment analysis,
  or technical indicators.
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

# Emblem Market Research

Crypto market intelligence powered by **Agent Hustle**. Real-time data from CoinGlass, DeFiLlama, Birdeye, and LunarCrush — trending tokens, sentiment, technicals, and on-chain analytics.

**Requires**: `npm install -g @emblemvault/agentwallet`

---

## Quick Start

```bash
npm install -g @emblemvault/agentwallet

# What's trending
emblemai --agent --profile default -m "What tokens are trending on Solana right now?"

# Market sentiment
emblemai --agent --profile default -m "What is the current market sentiment for Bitcoin and Ethereum?"
```

**Trigger phrases:**
- "What's trending on Solana?"
- "Show me market sentiment"
- "Analyze this token"
- "What are the top movers today?"
- "Give me a market overview"

---

## Data Sources

| Source | Coverage |
|--------|----------|
| **CoinGlass** | Funding rates, liquidation levels, open interest, market sentiment |
| **DeFiLlama** | TVL analytics, protocol comparisons, yield data |
| **Birdeye** | Token analytics, price charts, Solana-focused data |
| **LunarCrush** | Social media sentiment, trending metrics, community activity |

---

## Workflow: Token Research

### Step 1: Discovery
Find what's moving.
```bash
emblemai --agent --profile default -m "What tokens are trending on Solana right now with volume and price change?"
```

### Step 2: Deep Dive
Research a specific token.
```bash
emblemai --agent --profile default -m "Give me a detailed analysis of JUP token — price, volume, market cap, and social sentiment"
```

### Step 3: Technical Analysis
Check technicals before making a decision.
```bash
emblemai --agent --profile default -m "Show technical analysis for SOL — RSI, MACD, and key support/resistance levels"
```

### Step 4: On-Chain Data
Verify with on-chain metrics.
```bash
emblemai --agent --profile default -m "Show on-chain analytics for SOL — whale movements, smart money flows, and holder distribution"
```

---

## Research Patterns

### Market Overview
```bash
emblemai --agent --profile default -m "Give me a crypto market overview — BTC dominance, total market cap, fear/greed index, and top 5 movers"
```

### Chain-Specific Trends
```bash
emblemai --agent --profile default -m "What are the top trending tokens on Base this week by volume?"
emblemai --agent --profile default -m "Show the highest TVL protocols on Ethereum right now"
```

### Social Sentiment
```bash
emblemai --agent --profile default -m "What tokens have the most social media buzz on Twitter and Telegram right now?"
```

### Funding & Derivatives
```bash
emblemai --agent --profile default -m "Show current funding rates for BTC and ETH across major exchanges"
emblemai --agent --profile default -m "What are the current liquidation levels for Bitcoin?"
```

### Comparative Analysis
```bash
emblemai --agent --profile default -m "Compare SOL vs ETH — price performance, TVL, social sentiment over the last 7 days"
```

---

## Communication Tips

Be specific about what data you want and the timeframe:

| Bad | Good |
|-----|------|
| `"trending"` | `"What tokens are trending on Solana by volume in the last 24 hours?"` |
| `"analyze sol"` | `"Give me technical analysis of SOL with RSI, MACD, and support levels"` |
| `"market"` | `"Show a crypto market overview with BTC dominance and fear/greed index"` |

---

## Read-Only Skill

This skill only reads market data. No wallet interaction, no transactions, no confirmation needed. All queries execute immediately.

---

## Helper Script

```bash
bash scripts/market-scan.sh
```

See [scripts/market-scan.sh](scripts/market-scan.sh) for a daily market scan report.

---

## Links

- [Agent Wallet CLI](https://www.npmjs.com/package/@emblemvault/agentwallet)
- [EmblemVault Docs](https://emblemvault.dev)
- [Agent Hustle](https://agenthustle.ai)
