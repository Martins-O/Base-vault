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

## Contract Architecture

```
BaseVault/
├── src/
│   ├── core/           # Core vault contracts
│   ├── strategies/     # Yield strategies (Aerodrome, Uniswap)
│   ├── bridges/        # Cross-chain adapters
│   ├── risk/          # AI risk management
│   └── social/        # Copy trading & rewards
```

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

## Deployed Contracts

### Base Sepolia Testnet
- **BaseVault (USDC)**: [`0x221b7cca1c385c6c81e17b086c753328af41aaaa`](https://sepolia.basescan.org/address/0x221b7cca1c385c6c81e17b086c753328af41aaaa)
- VaultFactory: Coming soon
- Strategies: Coming soon

See [DEPLOYMENTS.md](./DEPLOYMENTS.md) for full deployment details.

## Development Progress

- [x] Project initialization
- [x] Core vault implementation (ERC4626)
- [x] Strategy system architecture
- [x] Deployed to Base Sepolia testnet
- [x] VaultFactory contract
- [x] Strategy contracts (Uniswap V3, Aerodrome)
- [x] Bridge adapters (LayerZero)
- [x] Risk management contracts
- [ ] Contract verification on BaseScan
- [ ] Frontend deployment
- [ ] Mainnet deployment

## License

MIT
