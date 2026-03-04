# Skills Registry Strategy & Monorepo Structure

## Executive Summary

**Problem:** Skills registries require GitHub repos as source, but we had platform-specific directory structure (`skills/openclaw/`) that reduces discoverability.

**Solution:** Move cross-platform skills to root level (`skills/`), use platform directories only for platform-specific variants.

**Outcome:** Maximizes discoverability on skills.sh and other registries while maintaining platform optimization capabilities.

## Skills.sh Discovery Behavior

### Key Findings:
1. **Without `--full-depth` flag:** Only finds skills at `skills/` root level
2. **With `--full-depth` flag:** Finds skills in nested directories (`skills/openclaw/`, `skills/claude.ai/`, etc.)
3. **Default behavior:** Most users won't use `--full-depth`, so root-level placement is critical for discovery

### Vercel Labs Pattern Analysis:
```
skills/
├── claude.ai/                    # Platform-specific (deployment requires Claude Code)
│   └── vercel-deploy-claimable/
├── react-best-practices/         # Cross-platform (root level)
├── web-design-guidelines/        # Cross-platform (root level)
└── composition-patterns/         # Cross-platform (root level)
```

**Insight:** Platform directories are used **only when necessary** (platform-specific implementations).

## Our Skill: EmblemAI Agent Wallet

### Platform Analysis:
- **Functionality:** Crypto wallet management via EmblemVault API
- **Dependencies:** Node.js, `@emblemvault/agentwallet` CLI
- **Platform-specific?** NO - works on any agent with exec/web_fetch capabilities
- **Conclusion:** CROSS-PLATFORM ✅

### Structural Changes Made:
1. **Before:** `skills/openclaw/emblem-ai-agent-wallet/`
2. **After:** `skills/emblem-ai-agent-wallet/` (root level)
3. **Metadata:** Kept OpenClaw-specific metadata (agents ignore what they don't understand)

## Registry Submission Strategy

### 8 Target Registries:
1. **skills.sh** (Vercel) - 270K+ skills, requires GitHub OAuth
2. **SkillHub** - 7K+ skills with quality scoring, requires GitHub OAuth  
3. **AgentRegistry** - Curated directory, requires GitHub PR
4. **awesome-agent-skills** - High trust tier, requires GitHub PR
5. **Skills Directory** - Requires GitHub OAuth
6. **SkillUse** - Requires GitHub PR
7. **SkillsMP** - Auto-indexing from GitHub (Cloudflare blocked)
8. **Killer Skills** - CLI install only, not a publishable directory

### Submission Requirements:
- **ALL registries** require GitHub repos as source
- **GitHub OAuth needed** for skills.sh, SkillHub, Skills Directory
- **GitHub PRs needed** for AgentRegistry, awesome-agent-skills, SkillUse
- **Auto-indexing** from GitHub for SkillsMP (currently blocked by Cloudflare)

### Multi-Skill Strategy:
```
EmblemCompany/Agent-skills/      # Monorepo (MAIN)
├── skills/emblem-ai-agent-wallet/      # Cross-platform core
├── skills/openclaw/emblem-enhanced/    # OpenClaw-specific variant (future)
└── skills/claude.ai/emblem-claude/     # Claude Code variant (future)

EmblemCompany/EmblemAi-AgentWallet/     # Single-skill repo (backup)
└── SKILL.md
```

## Platform Compatibility Matrix

### Agent Support:
| Agent | ID | Skills Path | Compatible? |
|-------|----|-------------|-------------|
| OpenClaw | `openclaw` | `~/.openclaw/skills/` | ✅ |
| Claude Code | `claude-code` | `~/.claude/skills/` | ✅ (test needed) |
| Cursor | `cursor` | `~/.cursor/skills/` | ✅ (test needed) |
| Codex | `codex` | `~/.codex/skills/` | ✅ (test needed) |
| 30+ other agents | various | various | ✅ (Agent Skills spec) |

### Feature Compatibility:
| Feature | OpenClaw | Claude Code | Cursor | Notes |
|---------|----------|-------------|--------|-------|
| Basic skills | ✅ | ✅ | ✅ | All agents |
| `allowed-tools` | ✅ | ✅ | ✅ | Most agents |
| `context: fork` | ❌ | ✅ | ❌ | Claude Code only |
| Hooks | ❌ | ✅ | ✅ | Claude Code + Cursor |

## Implementation Guidelines

### For Cross-Platform Skills:
1. **Place at root:** `skills/<skill-name>/`
2. **Use standard tools:** `exec`, `web_fetch`, `browser` (check agent support)
3. **Avoid platform assumptions:** No OpenClaw/Claude-specific code
4. **Metadata:** Optional, can include platform-specific sections
5. **Scripts:** Use platform-agnostic languages (Bash, Python, Node.js)

### For Platform-Specific Variants:
1. **Place in platform dir:** `skills/<platform>/<skill-name>/`
2. **Extend core functionality:** Don't duplicate, enhance
3. **Use platform features:** OpenClaw tools, Claude Code hooks, etc.
4. **Clear naming:** `emblem-enhanced`, `emblem-claude`, etc.

### Testing Strategy:
1. **OpenClaw:** ✅ Tested and working
2. **Claude Code:** ⚠️ Needs testing (no access)
3. **Cursor:** ⚠️ Needs testing (no access)
4. **skills.sh CLI:** ✅ Tested and working

## Next Steps

### Immediate (This Week):
1. ✅ Move skill to root level
2. ✅ Update documentation
3. ⚠️ Test on Claude Code (if possible)
4. ⚠️ Submit to skills.sh registry (GitHub OAuth needed)

### Short-term (Next 2 Weeks):
1. Create platform-specific variants (if needed)
2. Submit to remaining 7 registries
3. Build skill family (trading, DeFi, NFT management)
4. Establish testing pipeline for multiple agents

### Long-term (Strategic):
1. Become **default crypto wallet infra** across all agents
2. Build **platform adaptation layer** for major agents
3. Create **skill marketplace** within EmblemAI ecosystem
4. **Monetization:** Premium skills, wallet-as-a-service

## Risk Mitigation

### High Risk:
- ❌ Platform-specific code in cross-platform skill
- ❌ Assuming all agents have same tool capabilities
- ❌ Hardcoded paths/patterns

### Medium Risk:
- ⚠️ Using advanced features (`allowed-tools`, hooks)
- ⚠️ Complex dependencies
- ⚠️ Network access assumptions

### Low Risk:
- ✅ HTTP/API calls (standard)
- ✅ File operations (standard)
- ✅ Environment variables (standard)

## Success Metrics

### Quantitative:
- **Registry listings:** 8/8 target registries
- **Skill installs:** 1K+ monthly (skills.sh metrics)
- **Agent compatibility:** 5+ major agents
- **Skill family:** 5+ related skills

### Qualitative:
- **Brand recognition:** "EmblemAI = crypto wallet for AI agents"
- **Developer adoption:** Used in tutorials, examples, templates
- **Platform partnerships:** Featured by agent platforms
- **Community:** Active skill contributors

## Conclusion

**Root-level placement is CRITICAL** for skills.sh discovery. Platform directories should be used sparingly, only for truly platform-specific implementations.

Our wallet skill is **cross-platform by design** and belongs at the root level. This maximizes discoverability while maintaining the ability to create platform-specific variants when needed.

The **monorepo approach** (`EmblemCompany/Agent-skills`) is optimal for registry submissions, as all registries require GitHub repos as source. We can submit the entire monorepo or individual skill directories as needed.

**Next priority:** Test on Claude Code and submit to skills.sh registry (requires GitHub OAuth setup).