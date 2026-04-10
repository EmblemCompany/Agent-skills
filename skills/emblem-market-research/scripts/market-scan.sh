#!/bin/bash
# market-scan.sh - Daily crypto market scan via Agent Hustle
# Usage: bash scripts/market-scan.sh [chain]

set -e

CHAIN="${1:-Solana}"

echo "Market Scan — $(date '+%Y-%m-%d %H:%M')"
echo "Chain: $CHAIN"
echo "=================================================="

if ! command -v emblemai &> /dev/null; then
    echo "Error: emblemai CLI not found"
    echo "Install with: npm install -g @emblemvault/agentwallet"
    exit 1
fi

echo ""
echo "1. Market Overview"
echo "------------------"
emblemai --agent --profile default -m "Give me a crypto market overview — BTC dominance, total market cap, and fear/greed index"

echo ""
echo "2. Trending on $CHAIN"
echo "---------------------"
emblemai --agent --profile default -m "What are the top 10 trending tokens on $CHAIN by volume in the last 24 hours?"

echo ""
echo "3. Social Sentiment"
echo "-------------------"
emblemai --agent --profile default -m "Which tokens have the highest social media activity right now?"

echo ""
echo "=================================================="
echo "Scan complete. Run with a chain argument: bash scripts/market-scan.sh Base"
