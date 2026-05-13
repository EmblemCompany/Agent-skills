# Changelog

All notable changes to **EmblemAI Agent Skills** are documented here. This project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] — 2026-05-13

Docs-only release.

### Added
- **`llms-install.md`** — single source-of-truth install path for MCP clients (Cline, Claude Code, Cursor, Windsurf, Gemini CLI). Covers OAuth and API key modes, transaction double-gate, tool filtering, troubleshooting.
- **`CHANGELOG.md`** — this file. Captures the history back to v1.0.0.
- **README badges** — Smithery quality 84, Glama score, LobeHub listing, MIT license, GitHub stars. Credibility signal for registry reviewers.

## [1.1.0] — 2026-05-11

### Added
- **MCP bridge** (`mcp-bridge/`) — stdio runner for sandboxed MCP clients that can't speak HTTP directly. Bundles a 535 KB `dist/index.js` for `npx @emblemvault/mcp`-style invocation.
- **`EMBLEMAI_TOOLS_FILTER`** — env-var-driven glob filter on the bridge, applied to both `tools/list` and `tools/call`. Lets a single binary serve any subset of the 200+-tool surface. Supports `*` and `?` patterns, comma-separated.
- **`smithery.yaml`** — Smithery directory listing manifest (API key auth, header-passed `x-api-key`).
- **`glama.json`** — Glama Server-tier listing claim.
- **`server.json`** — Official MCP Registry manifest (`io.github.EmblemCompany/Agent-skills`).
- **CLI flags** on the bridge — `--stdio`, `--version`, `--help`.
- **`Dockerfile`** — split ENTRYPOINT and CMD for sandboxed runners.

### Distribution wins this release
- ✅ Smithery — live with quality score **84**.
- ✅ Glama — live + scored.
- ✅ LobeHub — listed at [lobehub.com/mcp/emblemcompany-agent-skills](https://lobehub.com/mcp/emblemcompany-agent-skills).
- ✅ claude-skill-registry — entries merged via `claude-skill-registry-core` `bffa06d`.
- 🔄 punkpeye/awesome-mcp-servers PR #5119 — open + clean.
- 🔄 block/agent-skills PR #15 — all checks green.
- 🔄 cnych/claude-mcp PR #51 — open.
- 🔄 e2b-dev/awesome-ai-sdks PR #144 — open.

### Changed
- README — added MCP server install section (OAuth + API key paths, per-client matrix link).
- README — domain canonicalization to `emblemvault.ai` (only `emblemvault.dev` retained for interactive docs).
- 5 use-case skills rewritten to match the live Hustle-V2 tool catalog.

### Fixed
- `emblem-ai-agent-wallet` — addressed skills.sh Agent Trust Hub findings (PR #9).
- Removed `user-invocable` frontmatter field rejected by the upstream agentskills validator.

## [1.0.0] — 2026-03 (initial public release)

### Added
- 4 cross-platform core skills — `emblem-ai`, `emblem-ai-react`, `emblem-ai-agent-wallet`, `emblem-ai-prompt-examples`.
- 5 use-case skills — `emblem-portfolio-tracker`, `emblem-token-swap`, `emblem-market-research`, `emblem-defi-yield`, `emblem-memecoin-scout`.
- Validation scripts — `validate-skill.sh`, `validate-all.sh`, `scan-security.sh`.
- CI workflow — security scan + structure validation.
- Repo structure per [Agent Skills specification](https://agentskills.io/specification).
