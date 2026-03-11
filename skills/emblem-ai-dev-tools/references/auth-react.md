# @emblemvault/emblem-auth-react

React provider, hooks, and UI components for Emblem authentication.

## Installation

```bash
npm install @emblemvault/emblem-auth-react
```

## Setup

```tsx
import { EmblemAuthProvider } from '@emblemvault/emblem-auth-react';

function App() {
  return (
    <EmblemAuthProvider
      appId="your-app-id"
      authUrl="https://auth.emblemvault.ai"
      apiUrl="https://api.emblemvault.ai"
      debug={false}
    >
      {children}
    </EmblemAuthProvider>
  );
}
```

## Hook: `useEmblemAuth()`

```tsx
import { useEmblemAuth } from '@emblemvault/emblem-auth-react';

const {
  session,
  isAuthenticated,
  isLoading,
  error,
  vaultInfo,
  vaultId,
  walletAddress,
  visitorId,
  openAuthModal,
  logout,
  refreshSession,
  authSDK
} = useEmblemAuth();
```

Use `useEmblemAuthOptional()` when your component may render outside the provider.

## Components

### `ConnectButton`

```tsx
<ConnectButton
  showVaultInfo
  connectLabel="Connect"
  loadingLabel="Connecting..."
  onConnect={() => {}}
  onDisconnect={() => {}}
  className="my-button"
/>
```

Props: `showVaultInfo`, `connectLabel`, `loadingLabel`, `onConnect`, `onDisconnect`, `className`, `style`, `disabled`.

> `showVaultInfo` defaults to `true` in the package.

### `AuthStatus`

```tsx
<AuthStatus
  showVaultInfo
  showLogout
  className="auth-status"
/>
```

Props: `showVaultInfo`, `showLogout`, `className`, `style`.

## With Hustle

```tsx
import { EmblemAuthProvider, ConnectButton } from '@emblemvault/emblem-auth-react';
import { HustleProvider, HustleChat } from '@emblemvault/hustle-react';

function App() {
  return (
    <EmblemAuthProvider appId="your-app-id">
      <HustleProvider>
        <ConnectButton />
        <HustleChat />
      </HustleProvider>
    </EmblemAuthProvider>
  );
}
```
