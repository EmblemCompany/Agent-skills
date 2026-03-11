---
name: emblem-ai
description: Multi-chain wallet authentication, AI-powered crypto assistant, and AI app introspection. Use when the user wants to integrate wallet authentication (Ethereum, Solana, Bitcoin, Hedera), sign transactions, add AI chat capabilities with built-in crypto and web3 tools, display Migrate.fun token migration data, or embed AI-powered monitoring and debugging into Node.js apps. Provides React components, TypeScript SDKs, session-based authentication, and Reflexive for AI introspection. Supports trading, token analysis, DeFi operations, token migration browsing, multi-language debugging, and custom AI tool plugins.
license: MIT
metadata:
  source-repo: EmblemCompany/EmblemAi-SKILLS
  source-homepage: https://emblemvault.dev
  clawdbot-emoji: 🔐
compatibility: Cross-platform skill compatible with Claude Code, Cursor, Codex, OpenClaw, and other Agent Skills implementations.
---

# EmblemAI developer tools

EmblemAI developer tools for multi-chain wallet authentication, AI-powered crypto workflows, and app introspection.

Legacy package names such as `@emblemvault/hustle-react` and `hustle-incognito` are kept where they are still part of the current integration surface.

## What You Can Build

**Authentication & Signing**
- Wallet connect flows (MetaMask, Phantom, WalletConnect, etc.)
- Multi-chain authentication (Ethereum, Solana, Bitcoin, Hedera)
- OAuth login (Google, Twitter)
- Session management with automatic JWT refresh
- Transaction signing across chains

**AI Chat & Tools**
- AI assistant with built-in crypto and web3 tools
- Streaming chat responses
- Custom tool plugins
- Trading, DeFi, token analysis, and more

**Token Migration (Migrate.fun)**
- Browse and display migrate.fun projects
- Token mint info (decimals, program, supply)
- Liquidity pool details (source, output, quote token)
- Ready-to-use `<ProjectSelect>` component

**AI App Introspection And Build Agent (Reflexive)**
- Embed Claude inside running apps to monitor, debug, and develop
- Multi-language debugging (Node.js, Python, Go, .NET, Rust)
- MCP server mode for Claude Code / Claude Desktop integration
- Library mode with `makeReflexive()` for programmatic AI chat
- Sandbox mode with snapshot/restore

## Quick Start

### Installation

```bash
# CLI for AI agent wallets
npm install -g @emblemvault/agentwallet

# Core authentication
npm install @emblemvault/auth-sdk

# React integration (includes auth)
npm install @emblemvault/emblem-auth-react

# EmblemAI chat for React
npm install @emblemvault/hustle-react

# EmblemAI chat SDK (Node.js / vanilla JS)
npm install hustle-incognito

# Token migration data (Migrate.fun)
npm install @emblemvault/migratefun-react

# AI app introspection and debugging
npm install reflexive
```

### Option A: React App (Recommended)

```tsx
import { EmblemAuthProvider, ConnectButton, useEmblemAuth } from '@emblemvault/emblem-auth-react';
import { HustleProvider, HustleChat } from '@emblemvault/hustle-react';

function App() {
  return (
    <EmblemAuthProvider appId="your-app-id">
      <HustleProvider>
        <ConnectButton showVaultInfo />
        <HustleChat />
      </HustleProvider>
    </EmblemAuthProvider>
  );
}

function MyComponent() {
  const { isAuthenticated, walletAddress, vaultId } = useEmblemAuth();

  if (!isAuthenticated) {
    return <ConnectButton />;
  }

  return <div>Connected: {walletAddress}</div>;
}
```

If the user is building their own React app, use the dedicated [../emblem-ai-react/SKILL.md](../emblem-ai-react/SKILL.md) skill for the React-specific references and examples.

### Option B: Vanilla JavaScript / Node.js

```typescript
import { EmblemAuthSDK } from '@emblemvault/auth-sdk';
import { HustleIncognitoClient } from 'hustle-incognito';

// Initialize auth
const auth = new EmblemAuthSDK({ appId: 'your-app-id' });

// Open auth modal (browser)
auth.openAuthModal();

// Listen for session
auth.on('session', (session) => {
  console.log('Authenticated:', session.user.vaultId);
});

// Initialize AI with auth
const emblemAI = new HustleIncognitoClient({ sdk: auth });

// Chat with AI
const response = await emblemAI.chat([
  { role: 'user', content: 'What tokens are trending on Base?' }
]);
```

### Option C: CLI (Agent Wallet)

```bash
# Install globally
npm install -g @emblemvault/agentwallet

# Interactive mode -- opens browser for authentication
emblemai

# Agent mode -- single-shot queries for scripts and AI frameworks
emblemai --agent -m "What's the price of ETH?"

# Agent mode with explicit wallet identity
emblemai --agent -p "your-password-16-chars-min" -m "Show my balances across all chains"
```

Agent mode auto-generates a secure password on first run if none provided. See [references/agentwallet.md](references/agentwallet.md) for full CLI reference.

## Core Capabilities

### Wallet Authentication

**Supported Chains:**
| Chain | Auth Method | Signing Support |
|-------|-------------|-----------------|
| Ethereum/EVM | Signature verification | viem, ethers.js, web3.js |
| Solana | Signature verification | @solana/web3.js, @solana/kit |
| Bitcoin | PSBT signing | Native PSBT |
| Hedera | Signature verification | Hedera SDK |

**Additional Auth Methods:**
- OAuth (Google, Twitter)
- Email/password with OTP

**Reference**: [references/auth-sdk.md](references/auth-sdk.md)

### Transaction Signing

Convert authenticated sessions into signers for any blockchain library:

```typescript
const auth = new EmblemAuthSDK({ appId: 'your-app-id' });

// After authentication...

// EVM signing
const viemAccount = await auth.toViemAccount();
const ethersWallet = await auth.toEthersWallet(provider);
const web3Adapter = await auth.toWeb3Adapter();

// Solana signing
const solanaSigner = await auth.toSolanaWeb3Signer();
const solanaKitSigner = await auth.toSolanaKitSigner();

// Bitcoin PSBT signing
const bitcoinSigner = await auth.toBitcoinSigner();
```

**Reference**: [references/signing.md](references/signing.md)

### AI Chat Tools

Built-in crypto and web3 tool categories accessible via natural language:

**Trading & Swaps**
- Token swaps across chains
- Cross-chain bridges
- Limit orders and stop losses

**Market Research**
- Real-time prices
- Technical analysis (RSI, MACD)
- Trending tokens
- Social sentiment

**DeFi Operations**
- Liquidity pool analysis
- Yield farming opportunities
- Protocol interactions

**Token Analysis**
- Security audits
- Whale tracking
- Holder distribution

**Reference**: [references/ai-tools.md](references/ai-tools.md)

### React Components

Pre-built UI components for rapid development:

```tsx
// Auth components
<ConnectButton />           // Wallet connect button
<ConnectButton showVaultInfo />  // With vault dropdown
<AuthStatus />              // Shows connection status

// AI chat components
<HustleChat />              // Full EmblemAI chat interface
<HustleChatWidget />        // Floating EmblemAI chat widget
```

**Reference**: [references/react-components.md](references/react-components.md)

**Want to integrate EmblemAI into your own React app?** See the standalone [../emblem-ai-react/SKILL.md](../emblem-ai-react/SKILL.md) skill for the React auth, chat, component, and Migrate.fun examples in one place.

### Agent Wallet CLI

Give AI agents their own crypto wallets via a single CLI command. Zero-config agent mode auto-generates a wallet on first run. Supports 7 chains, the full EmblemAI toolset, browser auth for humans, and password auth for agents.

```bash
# Zero-config -- auto-generates wallet, answers query, exits
emblemai --agent -m "What are my wallet addresses?"

# Explicit wallet identity
emblemai --agent -p "your-password-16-chars-min" -m "Swap $20 of SOL to USDC"

# Interactive mode with browser auth
emblemai
```

```bash
# Integrate with any agent framework (OpenClaw, CrewAI, AutoGPT)
emblemai --agent -m "Send 0.1 SOL to <address>"
emblemai --agent -m "What tokens do I hold across all chains?"

# Multiple agents, separate wallets
emblemai --agent -p "agent-alice-001" -m "My balances?"
emblemai --agent -p "agent-bob-002" -m "My balances?"
```

**Modes**: Interactive (browser auth, slash commands), Agent (single-shot, stdout)

**Plugins**: x402 + ElizaOS (default), with A2A, ACP, and Bridge available via `/plugins`

**Reference**: [references/agentwallet.md](references/agentwallet.md)

### Migrate.fun Token Migration

React hooks and a `<ProjectSelect>` component for browsing and displaying migrate.fun projects, token mint details, and liquidity pool info.

```tsx
import { MigrateFunProvider } from '@emblemvault/migratefun-react/providers';
import { ProjectSelect } from '@emblemvault/migratefun-react/components';
import { useProject, useMintInfo } from '@emblemvault/migratefun-react/hooks';

function MigrationBrowser() {
  const [projectId, setProjectId] = useState('');
  const { project } = useProject(projectId);
  const { mintInfo } = useMintInfo(projectId);

  return (
    <MigrateFunProvider>
      <ProjectSelect value={projectId} onChange={setProjectId} />
      {project && <p>{project.oldTokenMeta?.symbol} -> {project.newTokenMeta?.symbol}</p>}
      {mintInfo && <p>Supply: {mintInfo.newToken.supplyFormatted}</p>}
    </MigrateFunProvider>
  );
}
```

**Hooks**: `useProjects`, `useProject`, `useProjectSelect`, `useMintInfo`, `usePoolInfo`

**Reference**: [references/migratefun-react.md](references/migratefun-react.md)

### AI App Introspection (Reflexive)

Embed Claude inside running applications to monitor, debug, and develop with conversational AI. Works as a CLI, embedded library, or MCP server.

```bash
# Monitor any app (read-only by default)
npx reflexive ./server.js

# Full development mode with debugging
npx reflexive --write --shell --debug --watch ./server.js

# As MCP server for Claude Code
npx reflexive --mcp --write --shell --debug ./server.js
```

```typescript
// Library mode -- embed in your app
import { makeReflexive } from 'reflexive';

const r = makeReflexive({ webUI: true, title: 'My App' });
r.setState('users.active', 42);
const analysis = await r.chat('Any anomalies in recent activity?');
```

**Modes**: CLI (local), library (`makeReflexive()`), MCP server, sandbox, hosted

**Debugging**: Node.js, Python, Go, .NET, Rust -- breakpoints with AI prompts

**Reference**: [references/reflexive.md](references/reflexive.md)

## Session Management

Emblem uses JWT-based sessions with automatic refresh:

```typescript
// Session structure
interface Session {
  authToken: string;      // JWT for API calls
  refreshToken?: string;  // For mobile/native apps
  expiresAt: number;      // Unix timestamp
  user: {
    vaultId: string;
    identifier?: string;
  };
  appId: string;
}

// Events
auth.on('session', (session) => { /* new session */ });
auth.on('sessionExpired', () => { /* handle expiry */ });
auth.on('sessionRefreshed', (session) => { /* refreshed */ });
auth.on('sessionWillRefresh', (info) => { /* refresh soon */ });
auth.on('authError', (error) => { /* auth failure */ });
auth.on('cancelled', () => { /* user closed auth */ });
```

Sessions auto-refresh ~60 seconds before expiry. No manual token management needed.

## Custom AI Plugins

Extend the AI with your own tools:

```typescript
import { usePlugins } from '@emblemvault/hustle-react';

const { registerPlugin } = usePlugins();

await registerPlugin({
  name: 'my-plugin',
  version: '1.0.0',
  tools: [{
    name: 'get_nft_floor',
    description: 'Get NFT collection floor price',
    parameters: {
      type: 'object',
      properties: {
        collection: { type: 'string', description: 'Collection name or address' }
      },
      required: ['collection']
    }
  }],
  executors: {
    get_nft_floor: async ({ collection }) => {
      const data = await fetchFloorPrice(collection);
      return { floor: data.floorPrice, currency: 'ETH' };
    }
  }
});
```

**Reference**: [references/plugins.md](references/plugins.md)

## More Examples and References

Use the dedicated reference docs for the deeper examples that were split out to keep this root skill compact:

- [references/agentwallet.md](references/agentwallet.md) - CLI usage, auth modes, prompts, and operational troubleshooting
- [references/auth-sdk.md](references/auth-sdk.md) - auth flows, sessions, Node persistence patterns, and TypeScript types
- [references/auth-react.md](references/auth-react.md) - provider setup, hooks, browser integrations, and UX patterns
- [references/emblem-ai-react.md](references/emblem-ai-react.md) - chat UI patterns, streaming, and React composition
- [references/emblem-ai-incognito.md](references/emblem-ai-incognito.md) - Node/browser SDK examples and environment configuration
- [references/ai-tools.md](references/ai-tools.md) - tool coverage, market research, DeFi, and analysis prompts
- [references/emblem-ai-prompt-examples.md](references/emblem-ai-prompt-examples.md) - shared EmblemAI prompt index with topic-specific example files
- [references/migratefun-react.md](references/migratefun-react.md) - token migration browsing patterns and component usage
- [references/react-components.md](references/react-components.md) - prebuilt component catalog and UI integration examples
- [references/react-skill-proposal.md](references/react-skill-proposal.md) - proposed future React standalone-skill boundary and example gaps
- [references/plugins.md](references/plugins.md) - custom plugin design, tool schemas, and executor examples
- [references/signing.md](references/signing.md) - signer adapters and transaction examples for EVM, Solana, and Bitcoin
- [references/reflexive.md](references/reflexive.md) - AI introspection, debugging, and MCP/server workflows
- [README.md](README.md) - quick package map for choosing the right Emblem package

If the user specifically wants React integration guidance, point them to [../emblem-ai-react/SKILL.md](../emblem-ai-react/SKILL.md).

---

**Getting Started**: Start with `<ConnectButton />` to add wallet auth, then add `<HustleChat />` for EmblemAI capabilities.

**Need Help?**: Check the reference docs in the `references/` folder for detailed API documentation.
