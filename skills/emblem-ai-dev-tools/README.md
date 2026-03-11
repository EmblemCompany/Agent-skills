# EmblemAI developer tools

EmblemAI developer tools for multi-chain wallet authentication, AI-powered crypto tools, and developer workflows.

## Features

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
  - [hustle-react.md](./references/hustle-react.md) - React AI chat
  - [hustle-incognito.md](./references/hustle-incognito.md) - AI SDK
  - [ai-tools.md](./references/ai-tools.md) - Built-in AI tools
  - [plugins.md](./references/plugins.md) - Custom plugins
  - [react-components.md](./references/react-components.md) - Component reference
  - [migratefun-react.md](./references/migratefun-react.md) - Migrate.fun React hooks
  - [reflexive.md](./references/reflexive.md) - AI app introspection

## Packages

| Package | Description |
|---------|-------------|
| `@emblemvault/agentwallet` | CLI for AI agent wallet management |
| `@emblemvault/auth-sdk` | Core authentication SDK |
| `@emblemvault/emblem-auth-react` | React hooks and components for auth |
| `@emblemvault/hustle-react` | React AI chat components |
| `@emblemvault/migratefun-react` | Migrate.fun React hooks and components |
| `hustle-incognito` | Low-level AI SDK |
| `reflexive` | AI app introspection and debugging |
