# EmblemAI Agent Skills

Official skill collection for AI agents, maintained by [EmblemAI](https://emblemvault.dev). Compatible with Claude Code, Cursor, Codex, and other agents following the [Agent Skills](https://agentskills.io/) specification.

## Available Skills

| Skill | Description | Install |
|-------|-------------|---------|
| [emblem-ai](skills/emblem-ai/) | EmblemAI developer tools for wallet auth, AI crypto tooling, React SDKs, and app introspection | `npx skills add EmblemCompany/Agent-skills --skill emblem-ai` |
| [emblem-ai-agent-wallet](skills/emblem-ai-agent-wallet/) | Crypto wallet management via Agent Hustle across 7 blockchains with browser auth, PAYG, and x402 | `npx skills add EmblemCompany/Agent-skills --skill emblem-ai-agent-wallet` |

## Quick Install

```bash
# Install a specific skill
npx skills add EmblemCompany/Agent-skills --skill emblem-ai
npx skills add EmblemCompany/Agent-skills --skill emblem-ai-agent-wallet

# Install all skills
npx skills add EmblemCompany/Agent-skills

# List available skills
npx skills add EmblemCompany/Agent-skills --list
```

## Skill Structure

Each skill follows the [Agent Skills specification](https://agentskills.io/):

```
skills/<skill-name>/
├── SKILL.md              # Required — skill instructions + metadata (recommended <500 lines)
├── references/           # Optional — detailed documentation by topic
├── scripts/              # Optional — executable helpers
├── assets/               # Optional — config templates, schemas
└── examples/             # Optional — sample outputs
```

## Adding Skills

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding new skills.

## Validation

```bash
# Validate all skills locally
bash validate-all.sh

# Validate one skill locally
bash validate-skill.sh emblem-ai-agent-wallet
```

Validation also runs automatically on every PR via GitHub Actions.

## License

MIT
