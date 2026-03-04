#!/usr/bin/env python3
# swap-tokens.py - Example Python script for token swaps using EmblemAI Agent Wallet
# Usage: python3 scripts/swap-tokens.py

import subprocess
import json
import shutil
import sys
import os

def run_emblemai_command(query):
    """Run emblemai command and return output."""
    try:
        result = subprocess.run(
            ["emblemai", "--agent", "-m", query],
            capture_output=True,
            text=True,
            timeout=120  # 2 minute timeout
        )
        if result.returncode != 0:
            print(f"❌ Error: {result.stderr}")
            return None
        return result.stdout
    except subprocess.TimeoutExpired:
        print("❌ Timeout: Command took too long")
        return None
    except FileNotFoundError:
        print("❌ Error: emblemai CLI not found")
        print("Install with: npm install -g @emblemvault/agentwallet")
        return None

def check_balances():
    """Check current balances."""
    print("🔍 Checking balances...")
    response = run_emblemai_command("Show my balances as JSON")
    if response:
        try:
            # Try to parse JSON from response
            lines = response.strip().split('\n')
            for line in lines:
                if line.strip().startswith('{') or line.strip().startswith('['):
                    data = json.loads(line.strip())
                    print("✅ Balances retrieved")
                    return data
        except json.JSONDecodeError:
            print("📊 Balance response (raw):")
            print(response)
    return None

def swap_tokens(from_token, to_token, amount, chain="Solana"):
    """Execute a token swap."""
    query = f"Swap {amount} of {from_token} to {to_token} on {chain} with 1% slippage"
    print(f"🔄 Executing swap: {query}")
    
    # Note: In safe mode, this will require user confirmation
    # For automated scripts, user must confirm in the CLI
    response = run_emblemai_command(query)
    if response:
        print("✅ Swap command executed")
        print("Response:")
        print(response)
        return response
    return None

def main():
    print("🔄 EmblemAI Token Swap Script")
    print("==============================")
    
    # Check if emblemai is available
    if not shutil.which("emblemai"):
        print("❌ Error: emblemai CLI not found in PATH")
        print("Install with: npm install -g @emblemvault/agentwallet")
        sys.exit(1)
    
    # Example 1: Check balances
    balances = check_balances()
    
    # Example 2: Execute a swap (requires user confirmation in safe mode)
    print("\n" + "="*50)
    print("Example swap command (requires confirmation):")
    print("="*50)
    
    # This is just an example - actual execution requires user confirmation
    # Uncomment and modify for actual use
    """
    swap_response = swap_tokens(
        from_token="SOL",
        to_token="USDC",
        amount="$20",
        chain="Solana"
    )
    """
    
    print("\n📝 Example swap command you can run manually:")
    print("  emblemai --agent -m 'Swap $20 of SOL to USDC on Solana with 1% slippage'")
    
    print("\n🔧 Configuration tips:")
    print("1. Set environment variable: export EMBLEM_PASSWORD='your-password'")
    print("2. Run in script: python3 scripts/swap-tokens.py")
    print("3. For production, handle credentials securely")
    
    print("\n⚠️  Important:")
    print("- Safe mode requires manual confirmation for swaps")
    print("- Never hardcode passwords in scripts")
    print("- Use environment variables or secure credential storage")

if __name__ == "__main__":
    main()
