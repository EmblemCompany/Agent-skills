# EmblemAI Agent Wallet

Give AI agents their own crypto wallets across 7 blockchains, powered by [EmblemAI](https://agenthustle.ai).

This is the easiest way to give your agent a crypto wallet. The same Emblem auth system can also log users into apps with wallets, email/password, or social sign-in, while giving each user a full-featured crypto wallet.

## Install

```bash
npm install -g @emblemvault/agentwallet
```

## Usage

```bash
# Interactive mode (browser auth)
emblemai

# Agent mode (zero-config, single-shot)
emblemai --agent -m "What are my wallet addresses?"
```

## Supported Chains

Solana, Ethereum, Base, BSC, Polygon, Hedera, Bitcoin

## Docs

See [SKILL.md](SKILL.md) for the full reference -- authentication, commands, plugins, agent mode, troubleshooting, and prompt examples.

If you want to integrate EmblemAI into your own React app, see [../emblem-ai-react/SKILL.md](../emblem-ai-react/SKILL.md).

## Links

- [emblemvault.dev](https://emblemvault.dev)
- [npm: @emblemvault/agentwallet](https://www.npmjs.com/package/@emblemvault/agentwallet)
- [GitHub: EmblemCompany](https://github.com/EmblemCompany)
