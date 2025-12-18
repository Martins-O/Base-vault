# BaseVault Contract Addresses

## Base Sepolia Testnet (Chain ID: 84532)

### Core Contracts
| Contract | Address | Verified |
|----------|---------|----------|
| FeeCollector | `0xCd5De20043a8aE46D80a22678b0Eb8B1078829Ce` | ✅ |
| InteractiveVault | `0x24ed030F7F62E05Eb5842bF5197c87a82397BDAC` | ✅ |
| VaultFactory | `0xd4b5C23ACB221AC6F8671EC3d45141E346ee80d8` | ✅ |

### Strategy Contracts
| Contract | Address | Verified |
|----------|---------|----------|
| AerodromeStrategy | `0xD248B35E5D2CBC4562D025daa1d0850A529E360b` | ✅ |
| UniswapV3Strategy | `0x9923Ec8b23D8f5442d641Cd9bd5918d56E8fA031` | ✅ |

### Additional Vaults
15 additional vaults deployed - see [VERIFIED_CONTRACTS.md](VERIFIED_CONTRACTS.md)

## Usage

Import into your .env:
```bash
FEE_COLLECTOR_ADDRESS=0xCd5De20043a8aE46D80a22678b0Eb8B1078829Ce
INTERACTIVE_VAULT_ADDRESS=0x24ed030F7F62E05Eb5842bF5197c87a82397BDAC
VAULT_FACTORY_ADDRESS=0xd4b5C23ACB221AC6F8671EC3d45141E346ee80d8
```

All contracts are live on Base Sepolia testnet.
