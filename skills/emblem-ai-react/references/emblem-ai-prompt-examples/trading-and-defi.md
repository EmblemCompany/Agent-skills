# Trading And DeFi Prompts

## Quote-Only Trading

```text
Get a quote to swap $20 of SOL to USDC on Solana. Do not execute.
Find the best ETH to USDC route on Base and summarize fees.
Compare two swap routes for 0.5 ETH to USDC and explain slippage tradeoffs.
Get a quote to swap HBAR to USDC on Hedera. Do not execute.
Get a quote to swap MATIC to USDC on Polygon. Do not execute.
```

## Solana Intent-Style Trading

```text
Quote $100 of JUP on Solana. Do not execute.
Buy BONK with 0.5 SOL on Solana.
Buy 100k BONK on Solana and show me the exact expected spend first.
Swap 50 USDC to BONK on Solana and stop before execution.
If BONK is ambiguous, show me the candidate token addresses first.
```

## EVM And Hedera Swaps

```text
Prepare a swap plan for $100 of ETH to USDC on Base, but stop before execution.
Show the exact transaction summary and approval steps before any swap.
Quote this trade with a maximum slippage tolerance of 1%.
Find the best BSC route to swap BNB into USDC and summarize fees.
Show me the preferred native USDC route on Base instead of bridged USDbC.
```

## DeFi And Yield

```text
Show me yield opportunities for USDC above 8% APY.
Compare the top ETH/USDC liquidity pools by fee tier and depth.
Find low-risk stablecoin yield opportunities and explain the main risks.
Show me good LP opportunities for SOL/USDC with a short risk summary.
Compare lending, LP, and staking options for idle USDC.
```

## Meme Token Discovery By Platform

```text
Show me trending Clanker tokens on Base with enough liquidity to trade.
Find new PumpFun launches on Solana with growing holders and volume.
Show me promising FourMeme tokens on BSC.
Find active MemeJob tokens on Hedera.
Recommend tradeable meme tokens above a 10k market cap and filter obvious rugs.
```
