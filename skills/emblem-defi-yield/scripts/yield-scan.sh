#!/bin/bash
# yield-scan.sh - Scan DeFi yield opportunities via Agent Hustle
# Usage: bash scripts/yield-scan.sh [chain]

set -e

CHAIN="${1:-Solana}"

echo "DeFi Yield Scan — $(date '+%Y-%m-%d %H:%M')"
echo "Chain: $CHAIN"
echo "=================================================="

if ! command -v emblemai &> /dev/null; then
    echo "Error: emblemai CLI not found"
    echo "Install with: npm install -g @emblemvault/agentwallet"
    exit 1
fi

echo ""
echo "1. Top Yield Pools"
echo "------------------"
emblemai --agent --profile default -m "Show the top 10 liquidity pools on $CHAIN by APY with TVL over \$50k"

echo ""
echo "2. Stable Pair Opportunities"
echo "----------------------------"
emblemai --agent --profile default -m "Show stablecoin pair pools on $CHAIN sorted by APY"

echo ""
echo "3. My Positions"
echo "---------------"
emblemai --agent --profile default -m "Show my current liquidity and staking positions on $CHAIN with earned rewards"

echo ""
echo "=================================================="
echo "Scan complete. Run with a chain: bash scripts/yield-scan.sh Ethereum"
