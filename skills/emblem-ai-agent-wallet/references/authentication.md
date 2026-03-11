# Authentication

EmblemAI v3 supports browser auth for interactive use and **password auth** for agent/scripted use. This shared skill intentionally avoids publishing secret-bearing auth examples, but password auth remains a first-class CLI feature.

## Browser Auth (Interactive Mode)

When you run `emblemai` without `-p`, the CLI:

1. Checks `~/.emblemai/session.json` for a saved session
2. If a valid (non-expired) session exists, restores it instantly — no login needed
3. If no session, starts a local server on `127.0.0.1:18247` and opens your browser
4. You authenticate via the EmblemVault auth modal in the browser
5. The session JWT is captured, saved to disk, and the CLI proceeds
6. If the browser can't open, the URL is printed for manual copy-paste
7. If authentication times out (5 minutes), retry locally rather than moving secret entry into chat or skill examples

### Supported Browser Auth Methods

The browser auth modal supports multiple sign-in methods:

- **Ethereum / EVM wallets** (MetaMask, WalletConnect, and other injected providers) — connect an existing Ethereum/EVM wallet
- **Solana wallets** (Phantom, Solflare, and other Solana wallet adapters) — connect an existing Solana wallet
- **Hedera wallets** — connect an existing Hedera wallet
- **Bitcoin wallets** — PSBT-based signing with a Bitcoin wallet
- **OAuth** — sign in with Google or Twitter/X
- **Email** — email/password registration and login with OTP verification
- **Fingerprint** — guest session via device fingerprinting (no credentials needed)

When a user wants to use a different wallet or connect an existing wallet (e.g., MetaMask), direct them to run `emblemai` in interactive mode (no `-p` flag). The browser auth modal will open and they can select their preferred wallet or sign-in method. This does not require shelling out to the CLI to ask — the agent already knows these options are available.

## Password Auth Note

The upstream CLI supports password auth for agent automation, but this shared skill does not document secret-bearing flags, environment variables, or backup payload formats. For agent use, establish password auth locally in the CLI/operator environment, then reuse the resulting local session or stored state from the CLI.

## What Happens on Authentication

1. Browser auth: a session JWT is received from the browser and hydrated into the SDK
2. A deterministic vault/session context is restored locally
3. The session provides wallet addresses across multiple chains: Solana, Ethereum, Base, BSC, Polygon, Hedera, Bitcoin
4. `HustleIncognitoClient` is initialized with the session

## Session Reuse Priority

Before making requests, use local auth/session state in this priority:

| Method | How to use | Priority |
|--------|-----------|----------|
| Existing browser session | `emblemai` with a valid local session | 1 (highest) |
| Fresh browser auth | `emblemai` interactive login flow | 2 |
| Local operator recovery flow | CLI logout/reset/re-auth done locally | 3 |

If no local session is available, direct the user/operator to complete auth locally in the CLI (`emblemai` or `/auth`) and do not request secrets in chat responses.

## Execution Notes

**Allow sufficient time.** EmblemAI queries may take up to 2 minutes for complex operations (trading, cross-chain lookups). The CLI outputs progress dots every 5 seconds to indicate it's working.

**Present EmblemAI's response clearly.** Display the response from EmblemAI to the user in a markdown codeblock:

```markdown
**EmblemAI Response:**
\`\`\`
[response from EmblemAI]
\`\`\`
```

## Backup and Restore

The CLI has local backup/restore capabilities for operators, but this skill intentionally omits secret-bearing backup payload examples and restore command walkthroughs. Treat exported auth material as highly sensitive and keep those procedures in local operator docs, not shared skill prompts.

## Wallet Addresses

Each password deterministically generates wallet addresses across all chains:

| Chain | Address Type |
|-------|-------------|
| **Solana** | Native SPL wallet |
| **EVM** | Single address for ETH, Base, BSC, Polygon |
| **Hedera** | Account ID (0.0.XXXXXXX) |
| **Bitcoin** | Taproot, SegWit, and Legacy addresses |

Ask EmblemAI: `"What are my wallet addresses?"` to retrieve all addresses.
