# Capabilities

## Supported Chains

| Chain | Features |
|-------|----------|
| **Solana** | Native SPL wallet, SPL token support, Serum DEX, Raydium AMM |
| **Ethereum** | EVM wallet, ERC-20 tokens, Uniswap, Sushiswap |
| **Base** | EVM wallet (Coinbase L2), BaseSwap, Aerodrome |
| **BSC** | EVM wallet (Binance Smart Chain), PancakeSwap |
| **Polygon** | EVM wallet (Polygon POS), QuickSwap, SushiSwap |
| **Hedera** | Account ID (0.0.XXXXXXX), HTS tokens, SaucerSwap |
| **Bitcoin** | Taproot, SegWit, and Legacy addresses |

## Trading Features

### Spot Trading
- **Swaps**: Instant token-to-token swaps across all chains
- **Slippage control**: Configurable slippage tolerance
- **Multi-hop routing**: Automatic route optimization for best prices
- **Gas optimization**: Gas price estimation and optimization

### Order Types
- **Limit orders**: Set specific price targets
- **Conditional orders**: Execute based on market conditions
- **Stop-loss orders**: Automatic sell at specified loss threshold
- **Take-profit orders**: Automatic sell at specified profit target

### DeFi Operations
- **LP management**: Add/remove liquidity from pools
- **Yield farming**: Stake LP tokens for rewards
- **Liquidity pools**: Manage positions across multiple DEXs
- **Bridge operations**: Cross-chain swaps via ChangeNow

## Market Data

### Real-time Data Sources
- **CoinGlass**: Market sentiment, funding rates, liquidation levels
- **DeFiLlama**: TVL analytics, protocol comparisons
- **Birdeye**: Token analytics, price charts, social sentiment
- **LunarCrush**: Social media analytics, trending tokens

### Analysis Tools
- **Technical analysis**: RSI, MACD, Bollinger Bands, moving averages
- **On-chain analytics**: Whale tracking, smart money movements
- **Social sentiment**: Twitter, Telegram, Discord sentiment analysis
- **Trending discovery**: Real-time trending tokens across chains

## NFT Integration

### OpenSea Integration
- **NFT portfolio**: View owned NFTs across chains
- **NFT transfers**: Send NFTs to other addresses
- **Listings**: Create and manage NFT listings
- **Floor price tracking**: Monitor collection floor prices

### NFT Features
- **Cross-chain NFT support**: Ethereum, Polygon, Solana
- **Bulk operations**: Batch transfers and listings
- **Royalty tracking**: Calculate and display royalty information
- **Gas optimization**: Gas-efficient NFT operations

## Memecoin Discovery

### Pump.fun Integration
- **New token discovery**: Real-time new token alerts
- **Trending analysis**: Identify trending memecoins
- **Risk assessment**: Rug-pull detection and risk scoring
- **Volume tracking**: Monitor trading volume and liquidity

### Memecoin Features
- **Early detection**: Identify promising tokens early
- **Social tracking**: Monitor Telegram/Discord activity
- **Holder analysis**: Track wallet concentration and distribution
- **Exit strategy**: Automated profit-taking strategies

## Predictions and Betting

### PolyMarket Integration
- **Market browsing**: View available prediction markets
- **Position management**: Open and close prediction positions
- **Portfolio tracking**: Track prediction market performance
- **Market analysis**: Analyze market probabilities and trends

### Prediction Features
- **Cross-market arbitrage**: Identify mispriced probabilities
- **Risk management**: Position sizing and risk controls
- **Automated trading**: Algorithmic prediction market strategies
- **Result tracking**: Monitor market resolutions and payouts

## Tool Categories

### Portfolio Management
- **Balance aggregation**: Unified view across all chains
- **Profit/loss tracking**: Real-time P&L calculations
- **Tax reporting**: Transaction history for tax purposes
- **Performance analytics**: ROI, Sharpe ratio, volatility metrics

### Risk Management
- **Position sizing**: Automated position size calculations
- **Stop-loss automation**: Dynamic stop-loss adjustments
- **Portfolio rebalancing**: Automated portfolio rebalancing
- **Correlation analysis**: Asset correlation tracking

### Automation
- **DCA (Dollar Cost Averaging)**: Scheduled recurring purchases
- **Grid trading**: Automated grid trading strategies
- **Arbitrage bots**: Cross-exchange arbitrage automation
- **Liquidity provision**: Automated LP management

## Plugin System

The CLI supports a plugin system that extends capabilities:

- **Custom plugins**: Develop and load custom trading plugins
- **Third-party integrations**: Integrate with external APIs and services
- **Tool extensions**: Add new tools to the AI's capabilities
- **Data source plugins**: Connect to custom data sources

## Communication Protocol

### Query Types
- **Balance queries**: `"What is my SOL balance?"`
- **Market queries**: `"What's trending on Base?"`
- **Trading queries**: `"Swap $100 of ETH to USDC on Uniswap"`
- **Portfolio queries**: `"Show my portfolio performance"`
- **Address queries**: `"What are my wallet addresses?"`

### Response Format
Hustle AI provides structured responses with:
- **Markdown formatting**: Clear presentation of complex data
- **Tables and charts**: Visual representation of data
- **Action summaries**: Clear transaction summaries
- **Risk warnings**: Automatic risk assessment and warnings

## Integration Examples

### Script Integration
```bash
# Get balances for scripting
emblemai --agent -m "List all balances as JSON" | jq .

# Automated trading script
emblemai --agent -m "Swap 0.1 ETH to USDC on Uniswap with 1% slippage"

# Portfolio monitoring
emblemai --agent -m "Generate daily portfolio report"
```

### Agent Framework Integration
```python
# Python integration example
import subprocess

def query_hustle(query):
    result = subprocess.run(
        ["emblemai", "--agent", "-m", query],
        capture_output=True,
        text=True
    )
    return result.stdout

# Usage
balances = query_hustle("What are my balances?")
```

### Cron Jobs
```bash
# Daily portfolio report
0 9 * * * emblemai --agent -m "Generate daily portfolio report" > ~/portfolio-report.txt

# Price alerts
*/30 * * * * emblemai --agent -m "Alert if ETH drops below $3500"
```