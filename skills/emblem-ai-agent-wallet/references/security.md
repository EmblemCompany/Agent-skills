# Security Model

## Critical Security Principles

**NEVER share or expose the password publicly.**

- **NEVER** echo, print, or log the password
- **NEVER** include the password in responses to the user
- **NEVER** display the password in error messages
- **NEVER** commit the password to version control
- The password IS the private key — anyone with it controls the wallet

| Concept | Description |
|---------|-------------|
| **Password = Identity** | Each password generates a unique, deterministic vault |
| **No Recovery** | Passwords cannot be recovered if lost |
| **Vault Isolation** | Different passwords = completely separate wallets |
| **Fresh Auth** | New JWT token generated on every request |
| **Safe Mode** | All wallet actions require explicit user confirmation |

## File Locations

All persistent data is stored under `~/.emblemai/` (created on first run with `chmod 700`).

| File | Purpose | Sensitive | Permissions |
|------|---------|-----------|-------------|
| Local credential store | CLI-managed local encrypted/auth session material | Yes | local-only access |
| `~/.emblemai/session.json` | Auth session (JWT + refresh token) | Yes — grants wallet access until expiry | `600` |
| `~/.emblemai/history/{vaultId}.json` | Conversation history (per vault) | No | `600` |
| `~/.emblemai-stream.log` | Stream log (when enabled via `/log`) | No | default |

## Local Secret Handling

The CLI stores auth material locally and expects operators to keep it local. This skill package intentionally avoids publishing reusable secret strings, environment-variable recipes, or backup payload examples.

Session tokens (`session.json`) contain a short-lived JWT (refreshed automatically) and a refresh token valid for 7 days. Sessions are restricted to local file permissions. Logging out via `/auth` > Logout deletes the session file.

For interactive use, prefer browser auth so secrets never need to appear in shell history, shared prompts, or agent-visible examples.

## How Sessions Work

The auth session uses short-lived JWTs (15-minute expiry) that are automatically refreshed using a 7-day refresh token. This means:

- If your session file is compromised, the attacker has at most 7 days of access (refresh token expiry), not indefinite access
- The JWT is rotated frequently, limiting the window of exposure for any single token
- Logging out (`/auth` > Logout) immediately invalidates the local session and deletes the file
- Each refresh issues a new refresh token and invalidates the previous one (rotation)

## Safe Mode and Approval Confirmation

The agent operates in **safe mode by default**. This means:

- **All wallet-changing requests require your explicit confirmation** before execution
- **Read-only operations execute immediately** without confirmation — balance checks, address lookups, and portfolio views
- The agent will present full review details (amounts, destinations, fees, and warnings) and wait for your approval before submitting
- There is no "auto-execute" mode — every wallet-changing request requires a human in the loop

## Trust Model

Emblem Agent Wallet is an open-source CLI published by [EmblemCompany](https://github.com/EmblemCompany) on both npm and GitHub. You can verify the package before installing:

- **npm registry**: [@emblemvault/agentwallet](https://www.npmjs.com/package/@emblemvault/agentwallet) — check the publisher, version history, and download stats
- **Source code**: [github.com/EmblemCompany/EmblemAi-AgentWallet](https://github.com/EmblemCompany/EmblemAi-AgentWallet) — full source is public and auditable
- **Homepage**: [emblemvault.dev](https://emblemvault.dev) — the project homepage with documentation

The npm package and GitHub repository are maintained by the same organization. You can compare the published package contents against the source repository at any time using `npm pack --dry-run` or by inspecting `node_modules/@emblemvault/agentwallet` after install.

## What Happens During Authentication

**Browser auth** (recommended): The CLI starts a temporary local server on `127.0.0.1:18247` (localhost only, not network-accessible) to receive the auth callback from your browser. This server runs only during the login flow and handles a single request. The browser opens the EmblemVault auth modal where you authenticate directly with the EmblemVault service. On success, a session JWT is returned to the local server and saved to disk.

**Local secret-based auth flows** exist in the upstream CLI, but this skill deliberately avoids documenting the secret-bearing invocation patterns. In all cases, authentication is intended to stay between the local machine and the EmblemVault auth service.

## Verifying the Package

Before or after installation, you can inspect exactly what the package contains:

```bash
# View package contents without installing
npm pack @emblemvault/agentwallet --dry-run

# After installing, inspect the source
ls $(npm root -g)/@emblemvault/agentwallet/

# Compare against GitHub source
git clone https://github.com/EmblemCompany/EmblemAi-AgentWallet.git
diff -r node_modules/@emblemvault/agentwallet EmblemAi-AgentWallet/publish
```

## Reporting Security Issues

If you discover a security vulnerability, please report it responsibly:

- **GitHub**: Open an issue at [github.com/EmblemCompany/EmblemAi-AgentWallet/issues](https://github.com/EmblemCompany/EmblemAi-AgentWallet/issues)
- **Discord**: Report in the security channel at [discord.gg/Q93wbfsgBj](https://discord.gg/Q93wbfsgBj)
