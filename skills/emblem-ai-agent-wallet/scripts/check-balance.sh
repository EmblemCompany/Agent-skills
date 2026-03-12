#!/bin/bash
# check-balance.sh - Example script to check crypto balances using EmblemAI Agent Wallet
# Usage: bash scripts/check-balance.sh

set -e

echo "🔍 Checking crypto balances across all chains..."
echo "=================================================="

# Check if emblemai CLI is installed
if ! command -v emblemai &> /dev/null; then
    echo "❌ Error: emblemai CLI not found"
    echo "Install with: npm install -g @emblemvault/agentwallet"
    exit 1
fi

# Check balances
echo "📊 Querying EmblemAI for balances..."
echo ""

# Run in agent mode to get balances
if [ -f "$HOME/.emblemai/session.json" ] || [ -d "$HOME/.emblemai" ]; then
    echo "Using existing local Emblem CLI state"
    emblemai --agent -m "Show my balances across all chains in a clear table format"
else
    echo "⚠️  No credentials found. Run 'emblemai' once to complete browser auth."
    echo ""
    echo "Example query you can run manually:"
    echo "  emblemai --agent -m 'Show my balances across all chains'"
fi

echo ""
echo "=================================================="
echo "✅ Balance check script completed"
echo ""
echo "Additional commands you can try:"
echo "  emblemai --agent -m 'What are my wallet addresses?'"
echo "  emblemai --agent -m 'Show my portfolio performance'"
echo "  emblemai --agent -m 'Summarize current market conditions on Solana'"
