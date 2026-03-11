# @emblemvault/auth-sdk

Core authentication SDK for Emblem wallet sessions.

## Installation

```bash
npm install @emblemvault/auth-sdk
```

## Initialization

```typescript
import { EmblemAuthSDK } from '@emblemvault/auth-sdk';

const auth = new EmblemAuthSDK({
  appId: 'your-app-id',
  authUrl: 'https://auth.emblemvault.ai', // optional
  apiUrl: 'https://api.emblemvault.ai',   // optional
  modalMode: 'auto',                      // optional: 'auto' | 'iframe' | 'popup'
  persistSession: true                    // optional, default true
});
```

## Authentication Methods

### Wallet modal (browser)

```typescript
await auth.openAuthModal();
```

### Programmatic wallet auth

```typescript
const session = await auth.authenticateWallet({
  network: 'ethereum', // ethereum | solana | bitcoin | hedera
  address: '0x...',
  message: 'Sign to authenticate',
  signature: '0x...'
});
```

### OAuth

```typescript
await auth.openOAuth('google'); // or 'twitter'
```

### Email OTP

```typescript
await auth.sendEmailOtp({ email: 'user@example.com' });

const session = await auth.verifyEmailOtp({
  email: 'user@example.com',
  otpCode: '123456'
});
```

## Session Management

```typescript
const session = auth.getSession(); // sync

if (session) {
  console.log(session.authToken);
  console.log(session.user.vaultId);
}

await auth.refreshSession();
auth.logout();
```

### Node/session persistence pattern

The SDK does not expose a custom `storage` adapter config. For Node or custom persistence, use `persistSession: false` + `hydrateSession(session)` and subscribe to refresh/expiry events.

## Vault Methods

```typescript
const vaultInfo = await auth.getVaultInfo();
const apiKey = await auth.getVaultApiKey();
```

## Events

```typescript
auth.on('session', (session) => {});
auth.on('sessionExpired', () => {});
auth.on('sessionRefreshed', (session) => {});
auth.on('sessionWillRefresh', (info) => {});
auth.on('authError', (error) => {});
auth.on('cancelled', () => {});
```

## Types

```typescript
import type {
  AuthSession,
  EmblemAuthConfig,
  VaultInfo,
  AuthEventMap
} from '@emblemvault/auth-sdk';
```
