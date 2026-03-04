# Authentication

EmblemAI v3 supports two authentication methods: **browser auth** for interactive use and **password auth** for agent/scripted use.

## Browser Auth (Interactive Mode)

When you run `emblemai` without `-p`, the CLI:

1. Checks `~/.emblemai/session.json` for a saved session
2. If a valid (non-expired) session exists, restores it instantly — no login needed
3. If no session, starts a local server on `127.0.0.1:18247` and opens your browser
4. You authenticate via the EmblemVault auth modal in the browser
5. The session JWT is captured, saved to disk, and the CLI proceeds
6. If the browser can't open, the URL is printed for manual copy-paste
7. If authentication times out (5 minutes), falls back to a password prompt

## Password Auth (Agent Mode)

**Login and signup are the same action.** The first use of a password creates a vault; subsequent uses return the same vault. Different passwords produce different wallets.

In agent mode, if no password is provided, a secure random password is auto-generated and stored encrypted via dotenvx. Agent mode works out of the box with no manual setup.

## What Happens on Authentication

1. Browser auth: session JWT is received from browser and hydrated into the SDK
   Password auth: password is sent to `EmblemAuthSDK.authenticatePassword()`
2. A deterministic vault is derived — same credentials always yield the same vault
3. The session provides wallet addresses across multiple chains: Solana, Ethereum, Base, BSC, Polygon, Hedera, Bitcoin
4. `HustleIncognitoClient` is initialized with the session

## Credential Discovery

Before making requests, locate the password using this priority:

| Method | How to use | Priority |
|--------|-----------|----------|
| CLI argument | `emblemai -p "your-password"` | 1 (highest, stored encrypted) |
| Environment variable | `export EMBLEM_PASSWORD="your-password"` | 2 (not stored) |
| Encrypted credential | dotenvx-encrypted `~/.emblemai/.env` | 3 |
| Auto-generate (agent mode) | Automatic on first run | 4 |
| Interactive prompt | Fallback when browser auth fails | 5 (lowest) |

If no credentials are found, ask the user:
> "I need your EmblemVault password to connect to Hustle AI. This password must be at least 16 characters.
>
> **Note:** If this is your first time, entering a new password will create a new wallet. If you've used this before, use the same password to access your existing wallet.
>
> Would you like to provide a password?"

- Password must be 16+ characters
- No recovery if lost (treat it like a private key)

## Execution Notes

**Allow sufficient time.** Hustle AI queries may take up to 2 minutes for complex operations (trading, cross-chain lookups). The CLI outputs progress dots every 5 seconds to indicate it's working.

**Present Hustle's response clearly.** Display the response from Hustle AI to the user in a markdown codeblock:

```markdown
**Hustle AI Response:**
\`\`\`
[response from Hustle]
\`\`\`
```

## Auth Backup and Restore

### Backup

From the `/auth` menu (option 8), select **Backup Agent Auth** to export your credentials to a JSON file. This file contains your EmblemVault password — keep it secure.

### Restore

```bash
emblemai --restore-auth ~/emblemai-auth-backup.json
```

This places the credential files in `~/.emblemai/` so you can authenticate immediately.

## Wallet Addresses

Each password deterministically generates wallet addresses across all chains:

| Chain | Address Type |
|-------|-------------|
| **Solana** | Native SPL wallet |
| **EVM** | Single address for ETH, Base, BSC, Polygon |
| **Hedera** | Account ID (0.0.XXXXXXX) |
| **Bitcoin** | Taproot, SegWit, and Legacy addresses |

Ask Hustle: `"What are my wallet addresses?"` to retrieve all addresses.