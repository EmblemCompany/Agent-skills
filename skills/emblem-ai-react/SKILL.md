---
name: emblem-ai-react
description: React integration skill for EmblemAI. Use when the user wants to build or integrate EmblemAI into a React app using EmblemAuthProvider, HustleProvider, chat components, React auth hooks, React composition patterns, or Migrate.fun React hooks.
license: MIT
user-invocable: true
compatibility: Works on Claude Code, Cursor, Codex, OpenClaw, and other agents following the Agent Skills specification.
metadata:
  author: EmblemAI
  version: "1.0.0"
  homepage: https://emblemvault.dev
---

# EmblemAI React

Use this skill when the user wants to integrate EmblemAI into their own React application rather than only use the CLI or low-level SDKs.

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
- "How do I use Migrate.fun React hooks in my app?"

---

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
