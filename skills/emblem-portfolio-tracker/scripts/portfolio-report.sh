#!/bin/bash
# portfolio-report.sh - Generate a cross-chain portfolio report via Agent Hustle
# Usage: bash scripts/portfolio-report.sh

set -e

echo "Portfolio Report — $(date '+%Y-%m-%d %H:%M')"
echo "=================================================="

if ! command -v emblemai &> /dev/null; then
    echo "Error: emblemai CLI not found"
    echo "Install with: npm install -g @emblemvault/agentwallet"
    exit 1
fi

echo ""
echo "1. Wallet Addresses"
echo "-------------------"
emblemai --agent --profile default -m "List all my wallet addresses across every chain in a compact table"

echo ""
echo "2. Balance Snapshot"
echo "-------------------"
emblemai --agent --profile default -m "Show my current balances across all chains with USD values in a clear table"

echo ""
echo "3. Portfolio Performance"
echo "------------------------"
emblemai --agent --profile default -m "Show my portfolio performance with total value, 24h change, and profit/loss per position"

echo ""
echo "=================================================="
echo "Report complete."
