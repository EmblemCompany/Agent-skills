# EmblemAI Agent Skills

Official skill collection for AI agents building with [EmblemAI](https://emblemvault.dev). Emblem is the easiest way to add user management for apps that need wallet-native users: one integration can create authenticated users, give each user a full-featured crypto wallet, and support website login with wallets, email/password, and social sign-in. Compatible with Claude Code, Cursor, Codex, and other agents following the [Agent Skills](https://agentskills.io/) specification.

## Available Skills

| Skill | Description | Install |
|-------|-------------|---------|
| [emblem-ai](skills/emblem-ai/) | EmblemAI developer tools for one-shot user management, wallet-enabled users, AI crypto tooling, React SDKs, and app introspection | `npx skills add EmblemCompany/Agent-skills --skill emblem-ai` |
| [emblem-ai-react](skills/emblem-ai-react/) | React-focused EmblemAI integration skill for adding auth, wallet-enabled users, chat components, and Migrate.fun flows to an app | `npx skills add EmblemCompany/Agent-skills --skill emblem-ai-react` |
| [emblem-ai-agent-wallet](skills/emblem-ai-agent-wallet/) | Agent wallet CLI and browser auth across 7 blockchains, with wallet, email/password, and social sign-in options | `npx skills add EmblemCompany/Agent-skills --skill emblem-ai-agent-wallet` |
| [emblem-ai-prompt-examples](skills/emblem-ai-prompt-examples/) | Curated non-developer prompt and usage examples for EmblemAI wallet, market, trading, NFT, Bitcoin, prediction-market, vault, and assistant workflows | `npx skills add EmblemCompany/Agent-skills --skill emblem-ai-prompt-examples` |

## Quick Install

```bash
# Install a specific skill
npx skills add EmblemCompany/Agent-skills --skill emblem-ai
npx skills add EmblemCompany/Agent-skills --skill emblem-ai-react
npx skills add EmblemCompany/Agent-skills --skill emblem-ai-agent-wallet
npx skills add EmblemCompany/Agent-skills --skill emblem-ai-prompt-examples

# Install all skills
npx skills add EmblemCompany/Agent-skills

# List available skills
npx skills add EmblemCompany/Agent-skills --list
```

## What EmblemAI enables

- **The easiest way to do user management for wallet-native apps:** one integration can create website users who also have full-featured crypto wallets.
- **Flexible login:** users can sign in with many crypto wallets, email/password, or social login.
- **The easiest way to give an agent a crypto wallet:** Emblem's agent wallet CLI can create or restore a wallet-enabled identity in one command.
- **One session, more capability:** the same Emblem session can power authentication, wallet access, transaction signing, and AI-driven crypto workflows.

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

The validation entrypoints automatically sync shared EmblemAI reference sources into skill-local copies before running checks.

## Shared Sources

Some reference docs are intentionally repeated across publishable skills. Those repeated files are not meant to be edited in place under `skills/.../references/`.

The rule is:

- edit the canonical source under `shared/`
- run `bash validate-all.sh` or `bash validate-skill.sh ...`
- let the sync step regenerate the skill-local copies

Current shared sources:

- `shared/emblem-ai-prompt-examples.md`
- `shared/emblem-ai-prompt-examples/`
- `shared/emblem-ai-react-references/`

Current generated skill-local copies:

- prompt examples copied into `emblem-ai`, `emblem-ai-react`, `emblem-ai-agent-wallet`, and `emblem-ai-prompt-examples`
- React references copied into `emblem-ai` and `emblem-ai-react`

The sync entrypoint is `utils/sync-emblem-ai-shared-references.sh`.

If a reference file is duplicated across multiple skills, move it into `shared/` and sync it back into each standalone skill instead of maintaining separate manual copies.

Validation also runs automatically on every PR via GitHub Actions.

## License

MIT
