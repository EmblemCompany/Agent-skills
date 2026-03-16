# EmblemAI SDK (`hustle-incognito`)

Low-level SDK for EmblemAI chat and tool execution.

The package, class names, and some env var names still use legacy `hustle` branding in the current integration surface.

## Installation

```bash
npm install hustle-incognito
```

## Initialization

### API key mode (server scripts)

```typescript
import { HustleIncognitoClient } from 'hustle-incognito';

const emblemAIClient = new HustleIncognitoClient({
  apiKey: process.env.HUSTLE_API_KEY,
  vaultId: process.env.VAULT_ID,
  hustleApiUrl: process.env.HUSTLE_API_URL // optional trusted backend URL
});
```

### Auth SDK mode (browser)

```typescript
import { EmblemAuthSDK } from '@emblemvault/auth-sdk';
import { HustleIncognitoClient } from 'hustle-incognito';

const auth = new EmblemAuthSDK({ appId: 'your-app-id' });
const emblemAIClient = new HustleIncognitoClient({
  sdk: auth,
  hustleApiUrl: process.env.HUSTLE_API_URL
});
```

### JWT / custom auth mode

```typescript
const emblemAIClient = new HustleIncognitoClient({
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
const response = await emblemAIClient.chat([
  { role: 'user', content: 'What tokens are trending on Solana?' }
]);

for await (const chunk of emblemAIClient.chatStream({
  messages: [{ role: 'user', content: 'Analyze ETH price action' }],
  processChunks: true
})) {
  // text/tool chunks
}

for await (const raw of emblemAIClient.rawStream({
  messages: [{ role: 'user', content: 'Show my portfolio' }]
})) {
  // raw SSE events
}
```

## Discovery, models, billing

```typescript
await emblemAIClient.getTools();
await emblemAIClient.discoverTools();
await emblemAIClient.getModels();

const payg = await emblemAIClient.getPaygStatus();
await emblemAIClient.configurePayg({ enabled: true, payment_token: 'SOL' });
```

## Plugins

```typescript
await emblemAIClient.use({
  name: 'my-plugin',
  version: '1.0.0',
  tools: [{
    name: 'get_nft_floor',
    description: 'Get floor price',
    parameters: {
      type: 'object',
      properties: {
        collection: { type: 'string' }
      },
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
export HUSTLE_API_URL=https://api.emblemvault.ai
```
