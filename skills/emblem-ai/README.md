# EmblemAI developer tools

EmblemAI developer tools for one-shot user management, multi-chain wallet authentication, AI-powered crypto tools, and developer workflows.

With Emblem, you get the easiest way to add user management for wallet-native apps. One integration can create authenticated users who also have full-featured crypto wallets. Users can sign in with wallets, email/password, or social login, then continue into chat, signing, and crypto workflows.

Legacy package names such as `@emblemvault/hustle-react` and `hustle-incognito` are preserved below until the underlying npm surfaces are renamed.

## Features

- **One-shot User Management**: create website users who also have full-featured crypto wallets
- **Flexible Login Options**: wallets, email/password, Google, Twitter/X
- **Wallet Authentication**: Ethereum, Solana, Bitcoin, Hedera
- **Transaction Signing**: viem, ethers.js, web3.js, Solana adapters
- **AI Chat**: Built-in crypto and web3 tools for trading, analysis, and DeFi
- **React Components**: Pre-built UI for rapid development

## Quick Start

See [SKILL.md](./SKILL.md) for full documentation.

### React App

```tsx
import { EmblemAuthProvider, ConnectButton } from '@emblemvault/emblem-auth-react';
import { HustleProvider, HustleChat } from '@emblemvault/hustle-react';

function App() {
  return (
    <EmblemAuthProvider appId="your-app-id">
      <HustleProvider>
        <ConnectButton />
        <HustleChat />
      </HustleProvider>
    </EmblemAuthProvider>
  );
}
```

If you want to integrate EmblemAI into your own React app, see the dedicated [../emblem-ai-react/SKILL.md](../emblem-ai-react/SKILL.md) skill for the React-specific examples and references.

### CLI (Agent Wallet)

```bash
# Install globally
npm install -g @emblemvault/agentwallet

# Interactive mode (browser auth)
emblemai

# Agent mode (single-shot)
emblemai --agent -m "What is the price of ETH?"
```

## Documentation

- [SKILL.md](./SKILL.md) - Main documentation
- [references/](./references/) - Detailed API references
  - [agentwallet.md](./references/agentwallet.md) - CLI for AI agents
  - [auth-sdk.md](./references/auth-sdk.md) - Authentication SDK
  - [signing.md](./references/signing.md) - Transaction signing
  - [auth-react.md](./references/auth-react.md) - React auth hooks
  - [emblem-ai-react.md](./references/emblem-ai-react.md) - React EmblemAI chat
  - [emblem-ai-incognito.md](./references/emblem-ai-incognito.md) - EmblemAI SDK
  - [ai-tools.md](./references/ai-tools.md) - Built-in AI tools
  - [emblem-ai-prompt-examples.md](./references/emblem-ai-prompt-examples.md) - Prompt and usage examples shared across EmblemAI skills
  - [plugins.md](./references/plugins.md) - Plugin integrations
  - [react-components.md](./references/react-components.md) - Component reference
  - [migratefun-react.md](./references/migratefun-react.md) - Migrate.fun React hooks
  - [reflexive.md](./references/reflexive.md) - AI app introspection

For a React-only install surface, use [../emblem-ai-react/SKILL.md](../emblem-ai-react/SKILL.md).

## Packages

| Package | Description |
|---------|-------------|
| `@emblemvault/agentwallet` | CLI for AI agent wallet management |
| `@emblemvault/auth-sdk` | Core authentication SDK |
| `@emblemvault/emblem-auth-react` | React hooks and components for auth |
| `@emblemvault/hustle-react` | React EmblemAI chat components |
| `@emblemvault/migratefun-react` | Migrate.fun React hooks and components |
| `hustle-incognito` | Low-level EmblemAI SDK |
| `reflexive` | AI app introspection and debugging |
