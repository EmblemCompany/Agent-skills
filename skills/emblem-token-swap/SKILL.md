---
name: emblem-token-swap
description: >
  Execute token swaps across 7 blockchains via Agent Hustle. Automatic route optimization,
  slippage control, and multi-DEX support. Use when the user wants to swap tokens, exchange
  crypto, convert between currencies, or trade on a DEX.
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

# Emblem Token Swap

Guided token swapping powered by **Agent Hustle**. Multi-hop routing, slippage protection, and support for major DEXs across Solana, Ethereum, Base, BSC, Polygon, and Hedera.

**Requires**: `npm install -g @emblemvault/agentwallet`

---

## Quick Start

```bash
npm install -g @emblemvault/agentwallet

# Simple swap
emblemai --agent --profile default -m "Swap $20 worth of SOL to USDC on Solana with 1% slippage"

# Cross-chain bridge
emblemai --agent --profile default -m "Bridge $50 of ETH from Ethereum to Base via ChangeNow"
```

**Trigger phrases:**
- "Swap SOL to USDC"
- "Exchange ETH for USDT"
- "Convert my tokens"
- "Trade on Uniswap"
- "Bridge tokens to Base"

---

## Supported DEXs

| Chain | DEXs |
|-------|------|
| Solana | Raydium, Serum |
| Ethereum | Uniswap, SushiSwap |
| Base | BaseSwap, Aerodrome |
| BSC | PancakeSwap |
| Polygon | QuickSwap, SushiSwap |
| Hedera | SaucerSwap |

Cross-chain bridging via **ChangeNow**.

---

## Workflow: Safe Token Swap

### Step 1: Check Balance
Confirm you have enough of the source token.
```bash
emblemai --agent --profile default -m "What is my SOL balance on Solana?"
```

### Step 2: Get a Quote
Preview the swap before executing.
```bash
emblemai --agent --profile default -m "How much USDC would I get if I swapped $20 of SOL on Solana?"
```

### Step 3: Execute the Swap
Always specify amount, tokens, chain, and slippage.
```bash
emblemai --agent --profile default -m "Swap $20 worth of SOL to USDC on Solana with 1% slippage"
```
Safe mode requires your confirmation before executing.

### Step 4: Verify
Confirm the new balance.
```bash
emblemai --agent --profile default -m "Show my USDC and SOL balances on Solana"
```

---

## Swap Patterns

### Dollar-Amount Swap
```bash
emblemai --agent --profile default -m "Swap $50 worth of ETH to USDC on Ethereum with 0.5% slippage"
```

### Token-Amount Swap
```bash
emblemai --agent --profile default -m "Swap 0.1 ETH to USDC on Ethereum with 1% slippage"
```

### Specific DEX
```bash
emblemai --agent --profile default -m "Swap $30 of BNB to USDT on PancakeSwap with 1% slippage"
```

### Cross-Chain Bridge
```bash
emblemai --agent --profile default -m "Bridge 0.05 ETH from Ethereum to Base using ChangeNow"
```

---

## Communication Rules

**Always include these in swap requests:**
1. **Amount** — dollar value or token quantity
2. **Source token** — what you're swapping from
3. **Target token** — what you're swapping to
4. **Chain** — which blockchain
5. **Slippage** — tolerance percentage (recommend 0.5-2%)

| Bad | Good |
|-----|------|
| `"swap sol usdc"` | `"Swap $20 of SOL to USDC on Solana with 1% slippage"` |
| `"buy eth"` | `"Swap $100 of USDC to ETH on Ethereum with 0.5% slippage"` |

---

## Safety

All swaps require explicit user confirmation (safe mode). The agent will:
1. Show you the swap details (amount, route, estimated output)
2. Display gas estimate
3. Wait for your approval before executing
4. Report the transaction result

Never bypasses confirmation for any value-moving operation.

---

## Helper Script

```bash
bash scripts/swap-helper.sh
```

See [scripts/swap-helper.sh](scripts/swap-helper.sh) for an interactive swap walkthrough.

---

## Links

- [Agent Wallet CLI](https://www.npmjs.com/package/@emblemvault/agentwallet)
- [EmblemVault Docs](https://emblemvault.dev)
- [Agent Hustle](https://agenthustle.ai)
