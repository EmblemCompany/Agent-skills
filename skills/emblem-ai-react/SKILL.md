---
name: emblem-ai-react
description: React integration skill for EmblemAI's one-shot user management. Use when the user wants to add website authentication plus wallet-enabled users to a React app with EmblemAuthProvider, ConnectButton, social/email/wallet login, chat components, React auth hooks, React composition patterns, or Migrate.fun React hooks.
license: MIT
user-invocable: true
compatibility: Works on Claude Code, Cursor, Codex, OpenClaw, and other agents following the Agent Skills specification.
metadata:
  author: EmblemAI
  version: "1.0.1"
  homepage: https://emblemvault.dev
---

# EmblemAI React

Use this skill when the user wants to integrate EmblemAI into a React app rather than only use the CLI or low-level SDKs.

**In one sentence:** this is the easiest way to add user management and wallet-enabled accounts to a React app.

---

## Quick Start

### Step 1: Install
```bash
npx skills add EmblemCompany/Agent-skills --skill emblem-ai-react
```

### Step 2: Use
Ask for React integration help by area, for example:

- "Show a minimal EmblemAI React app"
- "Help me add EmblemAuthProvider and HustleProvider"
- "Show React examples for wallet auth plus chat"
- "Show a React app where users can sign in with wallets, email, or social login"
- "How do I use Migrate.fun React hooks in my app?"

---

## What this gives a React app

- One integration for website authentication and wallet-enabled users
- Login options across crypto wallets, email/password, and social login
- React hooks and UI components that expose session, vault, and wallet state
- A clean path from login to chat, signing, and other Emblem-powered workflows
- The easiest way to add Migrate.fun migration-aware UI to a React app

## Included React References

### React Auth
See [references/auth-react.md](references/auth-react.md) for provider setup, hooks, and auth UI components.

### React Chat
See [references/emblem-ai-react.md](references/emblem-ai-react.md) for EmblemAI chat setup with `@emblemvault/hustle-react`.

### React Components
See [references/react-components.md](references/react-components.md) for current auth and chat component surfaces.

### Migrate.fun React
See [references/migratefun-react.md](references/migratefun-react.md) for hooks, provider setup, and project selection components.

---

## Guidance

- Use this skill for React app composition, provider wiring, and UI integration patterns.
- Prefer this skill over the broader `emblem-ai` skill when the request is clearly React-specific.
- Legacy package names may still use `hustle` branding even though the product name is EmblemAI.
- For end-user prompt phrasing across wallet, trading, NFT, or market workflows, use the `emblem-ai-prompt-examples` skill instead.

---

## Related Skills

- [../emblem-ai/SKILL.md](../emblem-ai/SKILL.md) - broader SDK, plugin, CLI, and introspection coverage
- [../emblem-ai-agent-wallet/SKILL.md](../emblem-ai-agent-wallet/SKILL.md) - CLI-first wallet workflows for agents and end users
- [../emblem-ai-prompt-examples/SKILL.md](../emblem-ai-prompt-examples/SKILL.md) - broader prompt examples across non-React workflows
