---
name: emblem-defi-yield
description: >
  DeFi yield farming and liquidity management via Agent Hustle. Add/remove liquidity,
  stake LP tokens, track yields, and manage positions across DEXs on 6 chains. Use when
  the user wants to farm yield, provide liquidity, stake tokens, or manage DeFi positions.
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

# Emblem DeFi Yield

DeFi yield farming and liquidity management powered by **Agent Hustle**. Provide liquidity, stake LP tokens, track yields, and manage positions across major DEXs on Solana, Ethereum, Base, BSC, Polygon, and Hedera.

**Requires**: `npm install -g @emblemvault/agentwallet`

---

## Quick Start

```bash
npm install -g @emblemvault/agentwallet

# Find yield opportunities
emblemai --agent --profile default -m "What are the best yield farming opportunities on Solana right now?"

# Check existing positions
emblemai --agent --profile default -m "Show my current liquidity positions across all chains"
```

**Trigger phrases:**
- "Find yield opportunities"
- "Add liquidity to a pool"
- "What are the best APYs?"
- "Manage my LP positions"
- "Stake my tokens"

---

## Supported Protocols

| Chain | DEXs / Protocols |
|-------|-----------------|
| Solana | Raydium |
| Ethereum | Uniswap, SushiSwap |
| Base | Aerodrome, BaseSwap |
| BSC | PancakeSwap |
| Polygon | QuickSwap, SushiSwap |
| Hedera | SaucerSwap |

TVL and yield data from **DeFiLlama**.

---

## Workflow: Provide Liquidity

### Step 1: Research Pools
Find high-yield pools with sustainable APY.
```bash
emblemai --agent --profile default -m "Show the top 10 liquidity pools on Solana by APY with TVL and volume"
```

### Step 2: Check Requirements
See what tokens you need for the pool.
```bash
emblemai --agent --profile default -m "What tokens do I need to provide liquidity to the SOL/USDC pool on Raydium?"
```

### Step 3: Verify Balances
Confirm you have the required tokens.
```bash
emblemai --agent --profile default -m "Show my SOL and USDC balances on Solana"
```

### Step 4: Add Liquidity
Provide liquidity to the pool.
```bash
emblemai --agent --profile default -m "Add $100 of liquidity to the SOL/USDC pool on Raydium, split evenly between both tokens"
```
Requires user confirmation in safe mode.

### Step 5: Verify Position
Confirm the LP position.
```bash
emblemai --agent --profile default -m "Show my current liquidity positions on Solana with value and rewards earned"
```

---

## DeFi Patterns

### Yield Discovery
```bash
emblemai --agent --profile default -m "What are the highest APY opportunities across all chains with at least $100k TVL?"
emblemai --agent --profile default -m "Show stable pair pools on Ethereum with the best yield"
```

### Position Management
```bash
emblemai --agent --profile default -m "Show all my LP positions with current value, impermanent loss, and rewards earned"
emblemai --agent --profile default -m "Remove my liquidity from the SOL/USDC pool on Raydium"
```

### Staking
```bash
emblemai --agent --profile default -m "What staking options are available for my SOL tokens?"
emblemai --agent --profile default -m "Stake 10 SOL on the best available validator"
```

### Protocol Comparison
```bash
emblemai --agent --profile default -m "Compare yields for SOL/USDC pools across Raydium and other Solana DEXs"
```

---

## Communication Tips

DeFi operations need precision. Always specify:
1. **Action** — add liquidity, remove, stake, unstake
2. **Amount** — dollar value or token quantity
3. **Pool/Pair** — which tokens
4. **Protocol** — which DEX
5. **Chain** — which blockchain

| Bad | Good |
|-----|------|
| `"yield"` | `"What are the best yield farming pools on Solana by APY?"` |
| `"add LP"` | `"Add $100 of liquidity to SOL/USDC on Raydium, split evenly"` |

---

## Safety

All value-moving DeFi operations require user confirmation:
- Adding/removing liquidity
- Staking/unstaking
- Claiming rewards

Read-only operations (yield lookup, position viewing, protocol comparison) execute immediately.

---

## Helper Script

```bash
bash scripts/yield-scan.sh
```

See [scripts/yield-scan.sh](scripts/yield-scan.sh) for yield opportunity scanning.

---

## Links

- [Agent Wallet CLI](https://www.npmjs.com/package/@emblemvault/agentwallet)
- [EmblemVault Docs](https://emblemvault.dev)
- [Agent Hustle](https://agenthustle.ai)
