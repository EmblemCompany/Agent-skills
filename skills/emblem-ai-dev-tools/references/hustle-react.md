# @emblemvault/hustle-react

React provider, hooks, and UI components for Agent Hustle chat.

## Installation

```bash
npm install @emblemvault/hustle-react @emblemvault/emblem-auth-react
```

## Setup

```tsx
import { EmblemAuthProvider } from '@emblemvault/emblem-auth-react';
import { HustleProvider } from '@emblemvault/hustle-react';

function App() {
  return (
    <EmblemAuthProvider appId="your-app-id">
      <HustleProvider
        hustleApiUrl="https://agenthustle.ai"
        debug={false}
        instanceId="main"
      >
        {children}
      </HustleProvider>
    </EmblemAuthProvider>
  );
}
```

API-key mode is also supported by passing `apiKey` + `vaultId` to `HustleProvider`.

## Hook: `useHustle()`

```tsx
const {
  instanceId,
  isApiKeyMode,
  isReady,
  isLoading,
  error,
  models,
  client,
  chat,
  chatStream,
  uploadFile,
  loadModels,
  selectedModel,
  setSelectedModel,
  systemPrompt,
  setSystemPrompt,
  skipServerPrompt,
  setSkipServerPrompt,
} = useHustle();
```

## Hook: `usePlugins()`

Plugin registration is managed by `usePlugins`, not `useHustle`.

```tsx
import { usePlugins } from '@emblemvault/hustle-react';

const { plugins, enabledPlugins, registerPlugin, unregisterPlugin, enablePlugin, disablePlugin } = usePlugins();
```

## `HustleChat` props

```tsx
<HustleChat
  placeholder="Ask about crypto..."
  showSettings
  showDebug
  hideHeader={false}
  initialSystemPrompt="You are a helpful assistant."
  enableSpeechToText
  onMessage={(message) => {}}
  onToolCall={(toolCall) => {}}
  onResponse={(content) => {}}
/>
```

Supported props: `className`, `placeholder`, `showSettings`, `settingsPanelOpen`, `onSettingsPanelOpenChange`, `showDebug`, `hideHeader`, `initialSystemPrompt`, `enableSpeechToText`, `onMessage`, `onToolCall`, `onResponse`.

## `HustleChatWidget`

```tsx
<HustleChatWidget showSettings placeholder="How can I help?" />
```

Widget accepts a `config` object (position/size/title/offset, etc.) and passes through `HustleChat` props.
