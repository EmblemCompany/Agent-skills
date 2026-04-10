#!/bin/bash
# memecoin-scan.sh - Scan trending memecoins via Agent Hustle
# Usage: bash scripts/memecoin-scan.sh [chain]

set -e

CHAIN="${1:-Solana}"

echo "Memecoin Scout — $(date '+%Y-%m-%d %H:%M')"
echo "Chain: $CHAIN"
echo "=================================================="

if ! command -v emblemai &> /dev/null; then
    echo "Error: emblemai CLI not found"
    echo "Install with: npm install -g @emblemvault/agentwallet"
    exit 1
fi

echo ""
echo "1. Trending Memecoins"
echo "---------------------"
emblemai --agent --profile default -m "Show the top 10 trending memecoins on $CHAIN by volume with market cap and holder count"

echo ""
echo "2. New Launches"
echo "---------------"
emblemai --agent --profile default -m "What are the newest token launches on $CHAIN in the last 6 hours with significant volume?"

echo ""
echo "3. Social Buzz"
echo "--------------"
emblemai --agent --profile default -m "Which memecoins on $CHAIN have the most social media activity right now?"

echo ""
echo "=================================================="
echo "Scan complete. Run with a chain: bash scripts/memecoin-scan.sh Base"
