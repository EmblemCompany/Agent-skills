# hustle-incognito

Low-level SDK for Agent Hustle AI chat and tool execution.

## Installation

```bash
npm install hustle-incognito
```

## Initialization

### API key mode (server scripts)

```typescript
import { HustleIncognitoClient } from 'hustle-incognito';

const client = new HustleIncognitoClient({
  apiKey: process.env.HUSTLE_API_KEY,
  vaultId: process.env.VAULT_ID,
  hustleApiUrl: 'https://agenthustle.ai' // optional
});
```

### Auth SDK mode (browser)

```typescript
import { EmblemAuthSDK } from '@emblemvault/auth-sdk';
import { HustleIncognitoClient } from 'hustle-incognito';

const auth = new EmblemAuthSDK({ appId: 'your-app-id' });
const client = new HustleIncognitoClient({
  sdk: auth,
  hustleApiUrl: 'https://agenthustle.ai'
});
```

### JWT / custom auth mode

```typescript
const client = new HustleIncognitoClient({
  jwt: 'token' // or getJwt / getAuthHeaders
});

const clientWithDynamicJwt = new HustleIncognitoClient({
  getJwt: async () => getToken()
});

const clientWithHeaders = new HustleIncognitoClient({
  getAuthHeaders: async () => ({ Authorization: `Bearer ${await getToken()}` })
});
```

## Chat

```typescript
const response = await client.chat([
  { role: 'user', content: 'What tokens are trending on Solana?' }
]);

for await (const chunk of client.chatStream({
  messages: [{ role: 'user', content: 'Analyze ETH price action' }],
  processChunks: true
})) {
  // text/tool chunks
}

for await (const raw of client.rawStream({
  messages: [{ role: 'user', content: 'Show my portfolio' }]
})) {
  // raw SSE events
}
```

## Discovery, models, billing

```typescript
await client.getTools();
await client.discoverTools();
await client.getModels();

const payg = await client.getPaygStatus();
await client.configurePayg({ enabled: true, payment_token: 'SOL' });
```

## Plugins

```typescript
await client.use({
  name: 'my-plugin',
  version: '1.0.0',
  tools: [{
    name: 'get_nft_floor',
    description: 'Get floor price',
    parameters: {
      type: 'object',
      properties: { collection: { type: 'string' } },
      required: ['collection']
    }
  }],
  executors: {
    get_nft_floor: async ({ collection }) => fetchFloor(collection)
  }
});
```

## Environment variables

```bash
export HUSTLE_API_KEY=your-key
export VAULT_ID=your-vault-id
export HUSTLE_API_URL=https://agenthustle.ai
```
