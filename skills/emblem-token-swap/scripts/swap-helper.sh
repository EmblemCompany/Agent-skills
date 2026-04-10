#!/bin/bash
# swap-helper.sh - Interactive token swap walkthrough via Agent Hustle
# Usage: bash scripts/swap-helper.sh

set -e

echo "Token Swap Helper"
echo "=================================================="

if ! command -v emblemai &> /dev/null; then
    echo "Error: emblemai CLI not found"
    echo "Install with: npm install -g @emblemvault/agentwallet"
    exit 1
fi

echo ""
echo "Step 1: Current Balances"
echo "------------------------"
emblemai --agent --profile default -m "Show my balances across all chains with USD values"

echo ""
echo "Step 2: Example Swap Commands"
echo "-----------------------------"
echo "  Solana:    emblemai -a --profile default -m 'Swap \$20 of SOL to USDC on Solana with 1% slippage'"
echo "  Ethereum:  emblemai -a --profile default -m 'Swap 0.05 ETH to USDC on Ethereum with 0.5% slippage'"
echo "  Base:      emblemai -a --profile default -m 'Swap \$10 of ETH to USDC on Base with 1% slippage'"
echo "  BSC:       emblemai -a --profile default -m 'Swap \$25 of BNB to USDT on PancakeSwap with 1% slippage'"
echo ""
echo "Tips:"
echo "  - Always specify chain and slippage"
echo "  - Safe mode will ask for confirmation before executing"
echo "  - Use dollar amounts (\$20) or token amounts (0.1 ETH)"
echo ""
echo "=================================================="
