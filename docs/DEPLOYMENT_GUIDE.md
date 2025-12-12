# BaseVault Deployment Guide

## Prerequisites

- Foundry installed (`curl -L https://foundry.paradigm.xyz | bash`)
- Private key with testnet ETH (Base Sepolia)
- RPC URL for Base Sepolia
- BaseScan API key for verification

## Environment Setup

1. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

2. Fill in required values:
```bash
PRIVATE_KEY=your_private_key_here
BASE_SEPOLIA_RPC_URL=https://sepolia.base.org
BASESCAN_API_KEY=your_api_key_here
```

## Deployment Steps

### 1. Deploy Core Contracts

```bash
# Deploy FeeCollector, Vaults, and Factory
forge script script/DeployAllFees.s.sol:DeployAllFeesScript \
  --rpc-url $BASE_SEPOLIA_RPC_URL \
  --broadcast \
  --verify \
  --legacy
```

### 2. Verify Deployments

```bash
# Check all contracts deployed correctly
forge script script/VerifyDeployments.s.sol:VerifyDeploymentsScript \
  --rpc-url $BASE_SEPOLIA_RPC_URL
```

### 3. Deploy Strategies

```bash
# Deploy Aerodrome and Uniswap V3 strategies
forge script script/DeployStrategies.s.sol:DeployStrategiesScript \
  --rpc-url $BASE_SEPOLIA_RPC_URL \
  --broadcast \
  --verify
```

### 4. Deploy Interactive Vault

```bash
# Deploy feature-rich interactive vault
forge script script/DeployInteractive.s.sol:DeployInteractiveScript \
  --rpc-url $BASE_SEPOLIA_RPC_URL \
  --broadcast \
  --verify
```

## Post-Deployment Configuration

### 1. Set Strategy Allocations

```bash
# Connect to deployed vault
cast send $VAULT_ADDRESS "addStrategy(address,uint256)" \
  $STRATEGY_ADDRESS \
  5000 \  # 50% allocation
  --rpc-url $BASE_SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY
```

### 2. Configure Fees

```bash
# Set performance fee (200 bps = 2%)
cast send $VAULT_ADDRESS "setPerformanceFee(uint256)" 200 \
  --rpc-url $BASE_SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY
```

### 3. Add Guardians

```bash
# Add emergency guardian
cast send $VAULT_ADDRESS "addGuardian(address)" $GUARDIAN_ADDRESS \
  --rpc-url $BASE_SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY
```

## Testing Deployments

### 1. Deposit Test

```bash
# Approve USDC
cast send $USDC_ADDRESS "approve(address,uint256)" \
  $VAULT_ADDRESS \
  1000000000 \  # 1000 USDC (6 decimals)
  --rpc-url $BASE_SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY

# Deposit
cast send $VAULT_ADDRESS "deposit(uint256,address)" \
  1000000000 \
  $YOUR_ADDRESS \
  --rpc-url $BASE_SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY
```

### 2. Check Balances

```bash
# Check shares
cast call $VAULT_ADDRESS "balanceOf(address)(uint256)" $YOUR_ADDRESS \
  --rpc-url $BASE_SEPOLIA_RPC_URL

# Check total assets
cast call $VAULT_ADDRESS "totalAssets()(uint256)" \
  --rpc-url $BASE_SEPOLIA_RPC_URL
```

### 3. Verify Fee Collection

```bash
# Check collected fees
cast call $FEE_COLLECTOR_ADDRESS \
  "collectedFees(address)(uint256)" \
  $USDC_ADDRESS \
  --rpc-url $BASE_SEPOLIA_RPC_URL
```

## Monitoring

### View Contract on BaseScan

Visit: `https://sepolia.basescan.org/address/YOUR_CONTRACT_ADDRESS`

### Check Events

```bash
# Get recent deposits
cast logs --from-block 0 \
  --address $VAULT_ADDRESS \
  "Deposit(address indexed,address indexed,uint256,uint256)" \
  --rpc-url $BASE_SEPOLIA_RPC_URL
```

## Troubleshooting

### Gas Issues

If transactions fail due to gas:
- Use `--legacy` flag for type 0 transactions
- Manually set gas limit: `--gas-limit 3000000`

### Verification Issues

If contract verification fails:
```bash
# Manual verification
forge verify-contract \
  --chain-id 84532 \
  --constructor-args $(cast abi-encode "constructor(address)" $ARG) \
  $CONTRACT_ADDRESS \
  src/core/ContractName.sol:ContractName \
  --etherscan-api-key $BASESCAN_API_KEY
```

### RPC Issues

If RPC fails, try alternatives:
- Alchemy: `https://base-sepolia.g.alchemy.com/v2/YOUR_KEY`
- QuickNode: Your QuickNode endpoint
- Public: `https://sepolia.base.org` (rate limited)

## Mainnet Deployment

⚠️ **WARNING**: Before mainnet deployment:

1. ✅ Complete security audit
2. ✅ Run full test suite: `forge test`
3. ✅ Test on testnet for 1+ week
4. ✅ Set up monitoring and alerts
5. ✅ Prepare emergency procedures
6. ✅ Use multi-sig for governance

Change RPC URL to mainnet:
```bash
BASE_MAINNET_RPC_URL=https://mainnet.base.org
```

## Support

- GitHub Issues: https://github.com/Martins-O/Base-vault/issues
- Documentation: See `docs/` directory
- Base Discord: https://discord.gg/base
