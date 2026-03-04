# AGENTS.md - EmblemAI Agent Skills

This repository contains skills for AI agents that extend their capabilities with EmblemAI wallet operations.

## Skills Directory

### Cross-Platform Skills
- **emblem-ai-agent-wallet** (`skills/emblem-ai-agent-wallet/`)
  - Connect to EmblemVault and manage crypto wallets via Emblem AI - Agent Hustle.
  - Supports Solana, Ethereum, Base, BSC, Polygon, Hedera, and Bitcoin.
  - Use when the user wants to trade crypto, check balances, swap tokens, or interact with blockchain wallets.
  - **Compatible with:** OpenClaw, Claude Code, Cursor, Codex, and other agents following the Agent Skills spec.

## Usage

Skills are automatically loaded by agents that support the Agent Skills format. Cross-platform skills at the root level are discoverable by all compatible agents.

## Skill Development

When creating new skills:

1. **Cross-platform skills:** Create directory under `skills/<skill-name>/` (root level)
2. **Platform-specific skills:** Create directory under `skills/<platform>/<skill-name>/`
3. Add a `SKILL.md` file with frontmatter (name, description, metadata)
4. Include `scripts/` and `references/` as needed
5. Test with `npx skills add EmblemCompany/Agent-skills --skill <skill-name>`

## Platform Strategy

### Cross-Platform First
- Place skills at root level (`skills/<skill-name>/`) when they work across multiple agents
- Use standard Agent Skills tools and patterns
- Avoid platform-specific assumptions

### Platform-Specific Variants
- Create `skills/openclaw/`, `skills/claude.ai/`, etc. directories for platform-specific implementations
- Extend core functionality with platform optimizations
- Use platform-specific metadata and tooling

### Current Support
- **Cross-platform:** emblem-ai-agent-wallet ✅
- **OpenClaw-specific:** (future variants)
- **Claude Code-specific:** (future variants)