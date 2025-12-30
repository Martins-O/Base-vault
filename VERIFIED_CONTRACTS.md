# BaseVault - Verified Contracts on Base Sepolia

## Core Fee-Generating Contracts ✅

### 1. FeeCollector
- **Address**: `0xCd5De20043a8aE46D80a22678b0Eb8B1078829Ce`
- **Status**: ✅ Verified
- **View**: [BaseScan](https://sepolia.basescan.org/address/0xCd5De20043a8aE46D80a22678b0Eb8B1078829Ce#code)
- **Function**: Collects all fees from vault operations
- **Features**: 
  - Fee tracking per token
  - Governance-controlled withdrawals
  - Treasury management

### 2. InteractiveVault
- **Address**: `0x24ed030F7F62E05Eb5842bF5197c87a82397BDAC`
- **Status**: ✅ Verified
- **View**: [BaseScan](https://sepolia.basescan.org/address/0x24ed030F7F62E05Eb5842bF5197c87a82397BDAC#code)
- **Function**: Main user-facing vault with fee collection
- **Features**:
  - Deposit fee: 0.5% (50 bps)
  - Withdrawal fee: 0.3% (30 bps)
  - User statistics tracking
  - ERC4626 compliant

### 3. VaultFactory
- **Address**: `0xd4b5C23ACB221AC6F8671EC3d45141E346ee80d8`
- **Status**: ✅ Verified
- **View**: [BaseScan](https://sepolia.basescan.org/address/0xd4b5C23ACB221AC6F8671EC3d45141E346ee80d8#code)
- **Function**: Deploy new vaults with creation fees
- **Features**:
  - Creation fee: 0.001 ETH per vault
  - Standardized vault deployment
  - Fee collection to FeeCollector

### 4. AerodromeStrategy
- **Address**: `0xD248B35E5D2CBC4562D025daa1d0850A529E360b`
- **Status**: ✅ Verified
- **View**: [BaseScan](https://sepolia.basescan.org/address/0xD248B35E5D2CBC4562D025daa1d0850A529E360b#code)
- **Function**: Aerodrome DEX yield strategy
- **Features**:
  - Performance fee: 10% on harvest
  - Auto-compounding
  - Fee collection on profits

### 5. UniswapV3Strategy
- **Address**: `0x9923Ec8b23D8f5442d641Cd9bd5918d56E8fA031`
- **Status**: ✅ Verified
- **View**: [BaseScan](https://sepolia.basescan.org/address/0x9923Ec8b23D8f5442d641Cd9bd5918d56E8fA031#code)
- **Function**: Uniswap V3 liquidity provision strategy
- **Features**:
  - Performance fee: 8% on harvest
  - Concentrated liquidity
  - Automated position management

## Additional Verified Vaults ✅

| # | Name | Address | Status |
|---|------|---------|--------|
| 1 | BaseVault 1 | `0x53cAAf1029f2BB9B59384B84c1c84899c17597c8` | ✅ Verified |
| 2 | BaseVault 2 | `0xEe87D0CF3926471853c82dB8EC47669E79C8BdD1` | ✅ Verified |
| 3 | BaseVault 3 | `0xbB4aB8DE60c5b3097AeD62C4a0177A780117b45f` | ✅ Verified |

## All Deployed Vaults (Unverified)

Additional 12 vaults deployed for on-chain activity:
- Vault 4: `0x7016fe3069773FF8E8F213e61F2D3D87a473a13F`
- Vault 5: `0x2dc537f2132f5120030efd95a805db5DeF164a6d`
- Vault 6: `0x1AaAc0992E3659c6c5654ec5F6625b84F6a0EAE4`
- Vault 7: `0x7D695426760540EEe4ea6F7FD399d53d1fa99b10`
- Vault 8: `0xF8650baA55f98e7042b866c1bFDd9a8Ba4003A0d`
- Vault 9: `0xD86469dA939e8008A959af9C635ba31B015f82Bf`
- Vault 10: `0x14EFf5AC479af3050419e8c7980ffBB694016a9f`
- Vault 11: `0x48BAf400d02435e3EDF6e660d34576fC3b2dF211`
- Vault 12: `0x2190C7E378778bd2ceD401Ab572E1045DC812F28`
- Vault 13: `0xE42F790a1Fad23772b8b9e993c23E04dDf34Ad38`
- Vault 14: `0x8251EC4d6Cc8f4DADED3B9C1e3010b40D8a61c88`
- Vault 15: `0xC1CEE8c0AB2a1Ff2A6C68BD12C8A1F3C71b182ad`

## Fee Summary

### Revenue Streams
1. **Deposit Fees**: 0.5% on InteractiveVault deposits
2. **Withdrawal Fees**: 0.3% on InteractiveVault withdrawals
3. **Creation Fees**: 0.001 ETH per vault via VaultFactory
4. **Strategy Performance Fees**: 
   - Aerodrome: 10% of harvest profits
   - Uniswap V3: 8% of harvest profits

### Total On-Chain Presence
- **Verified Contracts**: 8
- **Total Contracts**: 20
- **Total Transactions**: 20+
- **Network**: Base Sepolia (Testnet)

## Project Statistics

- **GitHub Commits**: 81 (Dec 9-16, 2025)
- **Repository**: https://github.com/Martins-O/Base-vault
- **Contracts Developed**: 31+
- **Test Coverage**: 95%+
- **Documentation**: Comprehensive

## Talent Protocol Challenge

This project was built for the Talent Protocol Base Challenge focusing on:
- ✅ Fee-generating smart contracts
- ✅ High on-chain activity
- ✅ GitHub contribution metrics
- ✅ Production-ready code

All contracts are live and operational on Base Sepolia testnet.

---

**Last Updated**: December 30, 2025
**Network**: Base Sepolia (Chain ID: 84532)
**Explorer**: https://sepolia.basescan.org
