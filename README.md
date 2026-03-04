# EmblemAI Agent Skills

Official collection of skills for AI agents, maintained by EmblemAI.

## Available Skills

### OpenClaw Skills
- **emblem-ai-agent-wallet** - Connect to EmblemVault and manage crypto wallets via Emblem AI - Agent Hustle. Supports Solana, Ethereum, Base, BSC, Polygon, Hedera, and Bitcoin.

## Installation

Install individual skills using the `skills` CLI:

```bash
npx skills add EmblemCompany/Agent-skills --skill emblem-ai-agent-wallet
```

Or install all OpenClaw skills:

```bash
npx skills add EmblemCompany/Agent-skills --skill '*' --agent openclaw
```

## Skill Structure

Each skill lives in `skills/<platform>/<skill-name>/` and contains:

- `SKILL.md` - Skill instructions and metadata
- `README.md` - Optional documentation
- `scripts/` - Optional helper scripts
- `references/` - Optional reference material

## Contributing

Skills follow the [Agent Skills](https://agentskills.io/) format.

## License

MIT