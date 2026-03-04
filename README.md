# EmblemAI Agent Skills

Official collection of skills for AI agents, maintained by EmblemAI.

*Last updated: 2026-03-04 by Motoko (GitHub App test)*

## Available Skills

### Cross-Platform Skills
- **emblem-ai-agent-wallet** - Connect to EmblemVault and manage crypto wallets via Emblem AI - Agent Hustle. Supports Solana, Ethereum, Base, BSC, Polygon, Hedera, and Bitcoin. Works on OpenClaw, Claude Code, Cursor, and other agents.

## Installation

Install individual skills using the `skills` CLI:

```bash
# Install to all compatible agents
npx skills add EmblemCompany/Agent-skills --skill emblem-ai-agent-wallet

# Install to specific agents only
npx skills add EmblemCompany/Agent-skills --skill emblem-ai-agent-wallet --agent openclaw --agent claude-code

# Install all skills from this repo
npx skills add EmblemCompany/Agent-skills --skill '*'
```

## Skill Structure

Skills follow the [Agent Skills specification](https://agentskills.io/):

```
skills/
├── emblem-ai-agent-wallet/     # Cross-platform skill (root level)
│   ├── SKILL.md                # Required: skill instructions + metadata
│   ├── README.md               # Optional: documentation
│   ├── scripts/                # Optional: executable helpers
│   └── references/             # Optional: detailed docs
└── <platform>/                 # Optional: platform-specific variants
    └── <skill-name>/           # Platform-specific implementation
```

**Platform directories** (`openclaw/`, `claude.ai/`, etc.) are used only for platform-specific implementations. Cross-platform skills live at the root level.

## Contributing

Skills follow the [Agent Skills](https://agentskills.io/) format.

## License

MIT