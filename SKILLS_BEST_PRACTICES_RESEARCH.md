# Skills.sh & Agent Skills Best Practices Research
## Research Date: 2026-03-04

## Sources Consulted:
1. **Official Documentation:**
   - skills.sh/docs (minimal)
   - agentskills.io/specification (comprehensive spec)
   - platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices (Anthropic's official guide, 42K+ words)

2. **Community Resources:**
   - mgechev/skills-best-practices (GitHub, professional guide)
   - code.claude.com/docs/en/skills (Claude Code docs)
   - Multiple blog posts and tutorials

## CRITICAL FINDINGS:

### 1. **Directory Structure & Naming (MOST IMPORTANT)**
**Rule:** Directory name MUST match `name` field in SKILL.md frontmatter.
- **Directory:** `emblem-ai-agent-wallet/`
- **SKILL.md:** `name: emblem-ai-agent-wallet`
- **Validation:** `skills-ref validate ./emblem-ai-agent-wallet` will fail if mismatch

**Vercel's Broken Example:**
- Directory: `vercel-deploy-claimable/`
- SKILL.md: `name: vercel-deploy`
- **This violates spec!** Don't follow this pattern.

### 2. **Platform Directories Analysis**
**Finding:** Platform directories (`openclaw/`, `claude.ai/`) are NOT standard practice.
- **Anthropic's pattern:** All skills at `skills/<skill-name>/` (root level)
- **Vercel's pattern:** Has `claude.ai/` directory with BROKEN skill (name mismatch)
- **Microsoft/others:** Follow root-level pattern

**Conclusion:** Platform directories should ONLY be used if:
1. Skill is truly platform-specific
2. Directory name matches skill name
3. You use `compatibility` field to indicate platform requirements

### 3. **Cross-Platform vs Platform-Specific**
**Our wallet skill analysis:**
- ✅ **Cross-platform:** Works on OpenClaw, Claude Code, Cursor, Codex
- ✅ **Standard tools:** Uses `exec`, `web_fetch`, `browser` (all standard)
- ✅ **No platform dependencies:** Pure HTTP/API calls
- ❌ **NOT platform-specific**

**Decision:** Skill belongs at **root level** (`skills/emblem-ai-agent-wallet/`)

### 4. **SKILL.md Frontmatter Best Practices**
**Required fields:**
```yaml
name: emblem-ai-agent-wallet  # 1-64 chars, lowercase, hyphens, matches directory
description: Connect to EmblemVault and manage crypto wallets via Emblem AI - Agent Hustle. Supports Solana, Ethereum, Base, BSC, Polygon, Hedera, and Bitcoin. Use when the user wants to trade crypto, check balances, swap tokens, or interact with blockchain wallets.
```

**Optional fields (consider adding):**
```yaml
compatibility: Requires Node.js >= 18.0.0, @emblemvault/agentwallet CLI, and internet access
metadata:
  author: EmblemAI
  version: "3.0.8"
  homepage: https://emblemvault.dev
```

### 5. **Skills.sh Discovery Behavior (CORRECTED)**
**Previous misunderstanding:** Thought skills in platform directories require `--full-depth`
**Actual finding:** Skills.sh CLI filters skills based on VALIDATION, not directory depth

**Key insight:** The `vercel-deploy` skill in `claude.ai/` isn't found because:
1. Directory name ≠ skill name (violates spec)
2. CLI validation filters it out
3. skills.sh website might still index it (different algorithm)

**Our correction:** Move to root level AND ensure directory name matches skill name.

### 6. **Progressive Disclosure Pattern**
**From Anthropic docs:** Keep SKILL.md under 500 lines, split content:
```
emblem-ai-agent-wallet/
├── SKILL.md              # Main instructions (<500 lines)
├── references/           # Detailed docs
│   ├── authentication.md
│   ├── chains.md
│   └── api-reference.md
├── scripts/              # Utility scripts
│   ├── check-balance.sh
│   └── swap-tokens.py
└── assets/               # Templates, configs
```

**Current status:** Our SKILL.md is 24K+ lines! Needs refactoring.

### 7. **Validation Checklist (From Anthropic)**
**Before publishing:**
- [ ] Description includes "what" AND "when to use"
- [ ] SKILL.md body < 500 lines (ours: ❌ 24K+ lines!)
- [ ] Additional details in separate files (ours: ❌ all in one file)
- [ ] No time-sensitive information
- [ ] Consistent terminology
- [ ] Examples are concrete
- [ ] File references one level deep
- [ ] Tested with multiple models (Haiku, Sonnet, Opus)

### 8. **Critical Issues with Our Current Skill**
1. **SKILL.md is 24K+ lines** → Should be <500 lines
2. **All content in one file** → Should use progressive disclosure
3. **No references/scripts/assets** → Missing supporting files
4. **No `compatibility` field** → Should specify Node.js + CLI requirements
5. **Platform-specific metadata** → Has `metadata: {"openclaw": {...}}`

### 9. **Recommended Refactoring**
**Phase 1 (Immediate):**
1. Move supporting content to `references/` directory
2. Create utility scripts in `scripts/`
3. Keep SKILL.md as high-level navigation (<500 lines)

**Phase 2 (Registry submission):**
1. Add `compatibility` field
2. Consider making metadata platform-agnostic
3. Validate with `skills-ref validate`

**Phase 3 (Long-term):**
1. Create platform variants IF needed (unlikely)
2. Build skill family (trading, DeFi, NFT management)
3. Submit to all 8 registries

### 10. **Registry Submission Strategy**
**All registries require:**
- GitHub repo as source (`EmblemCompany/Agent-skills`)
- Valid SKILL.md with proper frontmatter
- Directory name matching skill name

**Submission order:**
1. **skills.sh** (largest, 270K+ skills) - requires GitHub OAuth
2. **SkillHub** (7K+ skills with scoring) - requires GitHub OAuth
3. **AgentRegistry** (curated) - requires GitHub PR
4. **awesome-agent-skills** (high trust) - requires GitHub PR

### 11. **Key Decision: Root Level Placement CONFIRMED**
**Based on research:** Our skill should be at `skills/emblem-ai-agent-wallet/` (root level).

**Reasons:**
1. Follows Anthropic's pattern (industry standard)
2. Avoids Vercel's broken example
3. Maximizes discoverability
4. Skill is cross-platform
5. Directory name matches skill name

### 12. **Action Items**
**Immediate (today):**
1. ✅ Already moved to root level (correct)
2. ⚠️ Need to refactor SKILL.md (<500 lines)
3. ⚠️ Need to add `compatibility` field
4. ⚠️ Need to create supporting directories

**Short-term (this week):**
1. Refactor skill structure
2. Validate with `skills-ref`
3. Test installation
4. Prepare registry submissions

**Long-term:**
1. Build skill family
2. Create platform variants only if truly needed
3. Establish EmblemAI as crypto wallet infra across all agents

## Conclusion
Our initial move to root level was **CORRECT**. However, we need significant refactoring to follow best practices. The skill's 24K+ line SKILL.md violates the progressive disclosure principle and needs restructuring.

Platform directories are not standard practice. Cross-platform skills belong at root level. Platform-specific variants should only be created if skill functionality differs by platform (unlikely for our wallet skill).

**Next priority:** Refactor SKILL.md to be <500 lines with supporting files in `references/`, `scripts/`, and `assets/` directories.