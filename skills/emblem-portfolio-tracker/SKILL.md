---
name: emblem-portfolio-tracker
description: >
  Track crypto portfolio across 7 blockchains via Agent Hustle. Aggregated balances, P&L,
  performance analytics, and tax-ready transaction history. Use when the user wants to check
  their portfolio, see balances across chains, track profit/loss, or generate portfolio reports.
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

# Emblem Portfolio Tracker

Cross-chain crypto portfolio monitoring powered by **Agent Hustle**. Aggregated balances, profit/loss tracking, performance analytics, and transaction history across Solana, Ethereum, Base, BSC, Polygon, Hedera, and Bitcoin.

**Requires**: `npm install -g @emblemvault/agentwallet`

---

## Quick Start

```bash
# Install the CLI (if not already installed)
npm install -g @emblemvault/agentwallet

# Check balances across all chains
emblemai --agent --profile default -m "Show my balances across all chains in a table"

# Portfolio summary with P&L
emblemai --agent --profile default -m "Show my portfolio performance with profit and loss for each position"
```

**Trigger phrases** (say these to activate this skill):
- "Check my portfolio"
- "Show balances across all chains"
- "What's my P&L?"
- "Generate a portfolio report"
- "How is my crypto performing?"

---

## Workflow: Full Portfolio Review

Follow these steps for a comprehensive portfolio review:

### Step 1: Wallet Addresses
```bash
emblemai --agent --profile default -m "List all my wallet addresses across every chain"
```
Confirms which chains have active wallets.

### Step 2: Balance Snapshot
```bash
emblemai --agent --profile default -m "Show my current balances across all chains with USD values in a clear table"
```
Gets the aggregate view — token amounts and USD equivalents.

### Step 3: Performance Check
```bash
emblemai --agent --profile default -m "Show my portfolio performance — include total value, 24h change, and profit/loss per position"
```
P&L breakdown per token and overall.

### Step 4: Transaction History
```bash
emblemai --agent --profile default -m "Show my recent transactions across all chains — last 10 transactions"
```
Recent activity for audit or tax purposes.

---

## Use Cases

### Daily Check-In
Quick morning review of holdings and overnight changes.
```bash
emblemai --agent --profile default -m "Give me a quick portfolio summary — total value, biggest movers in last 24h"
```

### Chain-Specific Deep Dive
Focus on a single chain when investigating positions.
```bash
emblemai --agent --profile default -m "Show all my Solana token balances with current prices"
emblemai --agent --profile default -m "What are my Ethereum positions worth right now?"
```

### Tax / Reporting
Transaction history formatted for record-keeping.
```bash
emblemai --agent --profile default -m "List all my swap transactions in the last 30 days with dates, amounts, and USD values"
```

### Portfolio Comparison
Compare allocation across chains.
```bash
emblemai --agent --profile default -m "Show my portfolio allocation by chain as percentages"
```

---

## Communication Tips

Use verbose, natural language for best results:

| Bad | Good |
|-----|------|
| `"balances"` | `"Show my balances across all chains with USD values"` |
| `"PnL"` | `"What is my profit and loss for each position I hold?"` |
| `"history"` | `"Show my last 10 transactions across all chains with dates"` |

---

## Helper Script

```bash
# Run the portfolio report script
bash scripts/portfolio-report.sh
```

See [scripts/portfolio-report.sh](scripts/portfolio-report.sh) for a ready-to-use daily report generator.

---

## Links

- [Agent Wallet CLI](https://www.npmjs.com/package/@emblemvault/agentwallet)
- [EmblemVault Docs](https://emblemvault.dev)
- [Agent Hustle](https://agenthustle.ai)
