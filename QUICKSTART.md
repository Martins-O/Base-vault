# BaseVault Quick Start

## For Users

### Interact with InteractiveVault
```bash
# View on BaseScan
https://sepolia.basescan.org/address/0x24ed030F7F62E05Eb5842bF5197c87a82397BDAC

# Deposit USDC (0.5% fee)
# Withdraw USDC (0.3% fee)
```

### Create a New Vault
```bash
# Use VaultFactory (0.001 ETH fee)
https://sepolia.basescan.org/address/0xd4b5C23ACB221AC6F8671EC3d45141E346ee80d8
```

## For Developers

### Deploy Locally
```bash
# Clone repo
git clone https://github.com/Martins-O/Base-vault.git
cd Base-vault

# Install dependencies
forge install

# Run tests
forge test

# Deploy to testnet
forge script script/DeployCore.s.sol --rpc-url $BASE_SEPOLIA_RPC_URL --broadcast
```

### Verify Contracts
```bash
forge verify-contract <ADDRESS> <CONTRACT> --chain-id 84532
```

## Fees
- Deposit: 0.5%
- Withdrawal: 0.3%
- Vault Creation: 0.001 ETH
- Strategy Performance: 8-10%

All fees go to FeeCollector: `0xCd5De20043a8aE46D80a22678b0Eb8B1078829Ce`
