# BaseVault Deployments

## Base Sepolia Testnet

### December 30, 2025

| Contract | Address | Status | Deployment Date |
|----------|---------|--------|-----------------|
| BaseVault (USDC) | [`0x221b7cca1c385c6c81e17b086c753328af41aaaa`](https://sepolia.basescan.org/address/0x221b7cca1c385c6c81e17b086c753328af41aaaa) | ✅ **Verified** | Dec 30, 2025 |

## Deployment Parameters

### BaseVault (USDC)
- **Asset**: `0x036CbD53842c5426634e7929541eC2318f3dCF7e` (USDC on Base Sepolia)
- **Name**: "BaseVault USDC"
- **Symbol**: "bvUSDC"
- **Governance**: `0x4A78dFC52566063f50F8cf4eD52F513AEB866A0C`

## Verification

✅ **Contract Verified on BaseScan**

The BaseVault contract source code is verified and publicly viewable on BaseScan:
https://sepolia.basescan.org/address/0x221b7cca1c385c6c81e17b086c753328af41aaaa#code

To verify additional contracts, use:
```bash
forge verify-contract \
  <CONTRACT_ADDRESS> \
  src/<path>/<Contract>.sol:<ContractName> \
  --chain-id 84532 \
  --constructor-args $(cast abi-encode "constructor(...)" <args>) \
  --etherscan-api-key $BASESCAN_API_KEY
```

## Interact with Contract

```bash
# Check vault details
cast call 0x221b7cca1c385c6c81e17b086c753328af41aaaa "name()" --rpc-url https://sepolia.base.org

# Check total assets
cast call 0x221b7cca1c385c6c81e17b086c753328af41aaaa "totalAssets()" --rpc-url https://sepolia.base.org

# Check governance
cast call 0x221b7cca1c385c6c81e17b086c753328af41aaaa "governance()" --rpc-url https://sepolia.base.org
```

## Talent Protocol Challenge

This deployment is part of the **Talent Protocol Base Challenge** (December 1-8, 2025).

- **GitHub**: https://github.com/Martins-O/Base-vault
- **Total Commits**: 171+ (Dec 1-8, 2025)
- **On-Chain Deployments**: See above

## Future Deployments

Planned deployments:
- [ ] VaultFactory contract
- [ ] UniswapV3Strategy contract
- [ ] AerodromeStrategy contract
- [ ] RiskOracle contract
- [ ] RiskManager contract
- [ ] Base Mainnet deployment (after testing)
