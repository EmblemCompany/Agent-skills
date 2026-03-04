# AGENTS.md - EmblemAI Agent Skills

This repository contains skills for AI agents that extend their capabilities with EmblemAI wallet operations.

## Skills Directory

### OpenClaw Skills
- **emblem-ai-agent-wallet** (`skills/openclaw/emblem-ai-agent-wallet/`)
  - Connect to EmblemVault and manage crypto wallets via Emblem AI - Agent Hustle.
  - Supports Solana, Ethereum, Base, BSC, Polygon, Hedera, and Bitcoin.
  - Use when the user wants to trade crypto, check balances, swap tokens, or interact with blockchain wallets.

## Usage

Skills are automatically loaded by agents that support the Agent Skills format. For OpenClaw agents, skills in the `openclaw` directory are loaded when relevant.

## Skill Development

When creating new skills:

1. Create a directory under `skills/<platform>/<skill-name>/`
2. Add a `SKILL.md` file with frontmatter (name, description, metadata)
3. Include `scripts/` and `references/` as needed
4. Test with `npx skills add EmblemCompany/Agent-skills --skill <skill-name>`

## Platform Support

- **openclaw** - Skills for OpenClaw agents
- **claude.ai** - Skills for Claude.ai (future)
- **general** - Platform-agnostic skills (future)