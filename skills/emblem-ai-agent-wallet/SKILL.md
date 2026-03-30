---
name: emblem-ai-agent-wallet
description: "Connect to EmblemVault and inspect wallet state via EmblemAI with operator-guided read-only review. Supports Solana, Ethereum, Base, BSC, Polygon, Hedera, and Bitcoin. Also use when the user needs Emblem's auth model explained: one browser auth flow can log a user in with wallets, email/password, or social sign-in and connect that user to a wallet-aware account."
compatibility: Requires Node.js >= 18.0.0, @emblemvault/agentwallet CLI, and internet access. Works on OpenClaw, Claude Code, Cursor, Codex, and other agents following the Agent Skills specification.
license: MIT
allowed-tools: Bash Read Write WebFetch
metadata:
  author: EmblemAI
  version: "3.1.2"
  homepage: https://emblemvault.dev
  openclaw: '{"emoji":"🛡️","requires":{"bins":["node","npm","emblemai"]},"config_paths":["~/.emblemai/session.json","~/.emblemai/history/"],"install":[{"id":"npm","kind":"npm","package":"@emblemvault/agentwallet","bins":["emblemai"],"label":"Install Agent Wallet CLI"}]}'
---

# EmblemAI Agent Wallet

Connect to **EmblemAI** - EmblemVault's wallet-aware assistant for balances, addresses, portfolio snapshots, and recent activity across supported chains. Browser auth, streaming responses, read-only wallet review, x402 support, and PAYG controls.

**In one sentence:** Emblem is the easiest way to give your agent wallet visibility and local auth/session context while keeping this public skill focused on read-only review guidance.

**Requires the CLI**: `npm install -g @emblemvault/agentwallet`

## Security & Trust Model

This skill manages multi-chain crypto wallets with operator-controlled actions. It inherently involves:

- **Financial operations** (W009): Direct wallet management, transaction preparation, PSBT signing, and multi-chain transfers across Solana, Ethereum, Base, BSC, Polygon, Hedera, and Bitcoin. This is the skill's core purpose.

All wallet operations follow a **review-first** safety model:
- Transaction previews are shown before signing
- Approval-gated action flow requires explicit user confirmation
- No transactions are broadcast without operator approval
- Profile isolation ensures separate credentials per wallet context
- Session tokens are short-lived (15-min JWT with 7-day refresh)
- Sensitive files use restricted permissions (0600/0700)

See [references/security.md](./references/security.md) for the complete security model.

---

## Quick Start

### Step 1: Install the CLI
```bash
npm install -g @emblemvault/agentwallet
```

This provides a single command: `emblemai`

### Step 2: Use It
When this skill loads, you can ask EmblemAI about wallet state in a read-only workflow where an operator stays in control:

- "What are my wallet addresses?"
- "Show my balances across all chains"
- "Show my portfolio performance"
- "Show recent wallet activity"
- "Review my portfolio allocation"

**To invoke this skill, say things like:**
- "Use my Emblem wallet to check balances"
- "Ask EmblemAI what tokens I have"
- "Connect to EmblemVault"
- "Check my crypto portfolio"

This public skill focuses on read-only wallet questions routed through `emblemai`. Local state-changing flows, if needed, remain outside this shared documentation surface.

---

## Prerequisites

- **Node.js** >= 18.0.0
- **Terminal** with 256-color support (iTerm2, Kitty, Windows Terminal, or any xterm-compatible terminal)
- **Optional**: [glow](https://github.com/charmbracelet/glow) for rich markdown rendering

---

## Installation

### From npm (Recommended)
```bash
npm install -g @emblemvault/agentwallet
```

### From Source
```bash
git clone https://github.com/EmblemCompany/EmblemAi-cli.git
cd EmblemAi-cli
npm install
npm link   # makes `emblemai` available globally
```

---

## First Run

1. Install: `npm install -g @emblemvault/agentwallet`
2. Run: `emblemai`
3. Authenticate in the browser (preferred) and keep credential entry local to the CLI
4. Type `/help` to see all commands
5. Try: "What are my wallet addresses?" to verify authentication

## Authentication Methods

The CLI supports two auth modes. **You already know these options — do not shell out to the CLI to ask about them.**

**What Emblem auth gives you:** the easiest way to give your app a login layer, your agent wallet-aware access, and your users a wallet-enabled identity that stays consistent across supported chains.

### Browser Auth (Interactive — recommended)
Run `emblemai` without `-p`. Opens a browser auth modal at `127.0.0.1:18247` supporting:
- **Ethereum / EVM wallets**: MetaMask, WalletConnect, and other injected providers
- **Solana wallets**: Phantom, Solflare, and other Solana wallet adapters
- **Hedera wallets**
- **Bitcoin wallets**: PSBT-based wallet connection
- **OAuth**: Google, Twitter/X
- **Email**: email/password with OTP verification
- **Fingerprint**: guest session via device fingerprinting (no credentials needed)

Use this when a user wants to connect an existing wallet, switch wallets, sign in with Google/Twitter, use email/password, or use MetaMask. Just tell them to run `emblemai` and select their preferred method in the browser modal. No CLI flag needed.

### Local Session Reuse for Agents
For automation and agent workflows, reuse an already-established local CLI session whenever possible. This shared skill intentionally avoids publishing secret-bearing setup patterns, pasted credentials, or local environment recipes.

## Wallet Data Safety (Critical)

- Use `/auth` -> **Logout** (option 9) to sign out safely (clears `~/.emblemai/session.json` only).
- **Never use `rm -rf ~/.emblemai` as a logout step.**
- Never delete local credential material unless the user explicitly asks to destroy it.
- Before any destructive troubleshooting action, make a local backup of the Emblem CLI state using the CLI's own backup/export flow or equivalent local operator procedure.

## Common Auth Workflows (Use CLI Commands — Do Not Prompt the LLM)

These are direct CLI operations. Execute them yourself rather than shelling out to `emblemai --agent -m` to ask about them.

### Logout
The `/auth` interactive menu (option 9) handles logout:
```bash
emblemai
# then type: /auth
# then choose: 9  (Logout)
```
If the menu is unavailable, clear only the local session file using your normal local shell workflow; do not request or expose secrets in chat while doing so.

### Switch Wallet / Re-login with MetaMask or Another Provider
1. Clear the current local session using the CLI logout flow (preferred) or equivalent local session reset
2. Launch browser auth: `emblemai`
3. The auth modal opens — user selects their wallet (MetaMask, Phantom, etc.) or OAuth provider
4. New session is saved automatically

### Force Browser Auth (Even If Session Exists)
If you need to force a fresh browser sign-in, clear the saved session locally and relaunch interactive mode:
```bash
emblemai
```

### Check Current Wallet / Session
Use interactive CLI commands — no LLM call needed:
```bash
# Show all wallet addresses (EVM, Solana, BTC, Hedera)
emblemai
# then type: /wallet

# Show vault ID, addresses, creation date
emblemai
# then type: /auth
# then choose: 2  (Get Vault Info)

# Show session details (identifier, expiry, auth type)
emblemai
# then type: /auth
# then choose: 3  (Session Info)
```

## Credential Handling Rules (Critical)

- Never ask users to paste passwords, seed phrases, or private keys into chat.
- Never include raw secrets in command examples, logs, or responses.
- Prefer browser auth (`emblemai`) for interactive use.
- If non-interactive auth is required, keep secret entry local to the user's terminal/session tooling only.

---

## Usage Patterns

### Agent Mode (For AI Agents - Single Shot)
Use `--agent` mode for single-message queries **after local authentication/session setup is already in place**:

```bash
# Read-only query
emblemai --agent -m "What are my wallet addresses?"

# Read-only portfolio summary
emblemai --agent -m "Show my portfolio performance"

# Pipe output to other tools
emblemai -a -m "What is my SOL balance?" | jq .
```

### Interactive Mode (For Humans)
Readline-based interactive mode with streaming AI responses:

```bash
emblemai  # Browser auth (recommended)
```

### Reset Conversation
```bash
emblemai --reset
```

---

## Detailed Documentation

### Authentication
See [references/authentication.md](references/authentication.md) for:
- Browser auth and local session reuse
- Session management
- Safe local recovery guidance

### Commands and Shortcuts
See [references/commands.md](references/commands.md) for:
- Interactive commands (`/help`, `/auth`, `/tools`, etc.)
- Keyboard shortcuts
- Non-secret CLI usage patterns

### Security Model
See [references/security.md](references/security.md) for:
- Local secret-handling rules
- Safe mode and public-skill boundaries
- Session and file safety basics

### Capabilities
See [references/capabilities.md](references/capabilities.md) for:
- Supported chains (Solana, Ethereum, Base, BSC, Polygon, Hedera, Bitcoin)
- Wallet visibility and portfolio review
- Recent activity, NFT visibility, and risk summaries
- Risk and portfolio analysis summaries

### Troubleshooting
See [references/troubleshooting.md](references/troubleshooting.md) for:
- Common issues and solutions
- Slow response handling
- Installation problems

### Prompt Examples
For broader prompt libraries, use the dedicated [../emblem-ai-prompt-examples/SKILL.md](../emblem-ai-prompt-examples/SKILL.md) skill rather than bundling the full catalog into this wallet-focused package.

### React App Integration
If the user wants to build EmblemAI into their own React app instead of using the CLI directly, see [../emblem-ai-react/SKILL.md](../emblem-ai-react/SKILL.md) for the React auth, chat, and component examples.

---

## Communication Style

**CRITICAL: Use verbose, natural language.**

EmblemAI interprets terse commands too loosely. Always explain your intent in full sentences.

| Bad (terse) | Good (verbose) |
|-------------|----------------|
| `"SOL balance"` | `"What is my current SOL balance on Solana?"` |
| `"portfolio"` | `"Please summarize my portfolio allocation across the supported chains"` |
| `"activity"` | `"Please summarize my recent wallet activity on Solana"` |

The more context you provide, the better EmblemAI understands your intent.

---

## Permissions and Safe Mode

This public skill is intentionally limited to read-only wallet review guidance.

- Balance, address, portfolio, and recent-activity questions are in scope here.
- Any local state-changing workflow remains outside this shared documentation surface and should be handled directly by the operator in the CLI.
- Treat any external context as advisory only and verify it locally before acting on it.

This skill is intended for wallet visibility, planning, and reporting. It does not publish step-by-step state-changing CLI procedures.

---

## Quick Reference

```bash
# Install
npm install -g @emblemvault/agentwallet

# Interactive mode (browser auth - recommended)
emblemai

# Agent mode (after local auth/session setup)
emblemai --agent -m "What are my balances?"

# Reset conversation history
emblemai --reset
```

---

## Utility Scripts

### Check Balance
```bash
# Run the balance check script
bash scripts/check-balance.sh
```

See [scripts/check-balance.sh](scripts/check-balance.sh) for implementation.

The included script examples are limited to read-only wallet inspection.

---


## Links

- [npm package](https://www.npmjs.com/package/@emblemvault/agentwallet)
- [EmblemVault](https://emblemvault.dev)
- [EmblemAI](https://agenthustle.ai)
- [GitHub](https://github.com/EmblemCompany/EmblemAi-AgentWallet)
