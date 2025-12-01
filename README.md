# BaseVault

Cross-Chain DeFi Yield Optimizer with AI-Powered Risk Management on Base

## Overview

BaseVault is a sophisticated DeFi protocol built on Base that automatically optimizes yield across multiple DEXs while providing AI-powered risk management and social trading features.

## Features

- **Intelligent Yield Aggregation**: Auto-routes funds across Base DEXs (Aerodrome, Uniswap V3)
- **Cross-Chain Integration**: Bridge assets between Base, Ethereum, Optimism, and Arbitrum
- **AI Risk Scoring**: Chainlink Functions-powered risk assessment
- **Social Trading**: Copy top performers and earn rewards via Talent Protocol
- **Privacy Options**: ZK-proof enabled anonymous yield farming

## Tech Stack

- **Smart Contracts**: Foundry (Solidity ^0.8.20)
- **Frontend**: Next.js 14 with App Router
- **Oracles**: Chainlink Functions & Price Feeds
- **Bridges**: LayerZero
- **Testing**: Foundry (unit, integration, fork tests)

## Project Status

🚧 **Under Active Development** - Talent Protocol Base Challenge Entry

## Getting Started

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install dependencies
forge install

# Run tests
forge test

# Deploy to Base Sepolia
forge script script/Deploy.s.sol --rpc-url base-sepolia --broadcast
```

## License

MIT
