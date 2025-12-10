# BaseVault Deployment Plan (Dec 10-16, 2025)

## Goal
Deploy fee-generating contracts to maximize Talent Protocol leaderboard ranking.

## Leaderboard Metrics
1. **Fees Generated**: Primary metric
2. **On-Chain Activity**: Transaction count
3. **GitHub Contributions**: Commits (already done)

## Deployment Schedule

### Phase 1: Fee Infrastructure (Dec 10)
- [x] FeeCollector
- [x] InteractiveVault with fees
- [ ] Deploy to Base Sepolia

### Phase 2: Strategy Deployment (Dec 11)
- [ ] AerodromeStrategyWithFees
- [ ] UniswapV3StrategyWithFees
- [ ] Connect to vaults

### Phase 3: Revenue Generation (Dec 12-14)
- [ ] VaultFactory with creation fees
- [ ] Multiple vault deployments
- [ ] Test transactions to generate fees

### Phase 4: Social Features (Dec 15)
- [ ] TalentProtocol rewards
- [ ] Copy trading with fees
- [ ] Leader fee distribution

### Phase 5: Optimization (Dec 16)
- [ ] Fee rate optimization
- [ ] Gas optimization
- [ ] Maximum fee generation

## Fee Structure Summary

| Contract | Fee Type | Rate | Revenue Potential |
|----------|----------|------|-------------------|
| InteractiveVault | Deposit | 0.5% | High |
| InteractiveVault | Withdrawal | 0.3% | High |
| InteractiveVault | Performance | 2% | Very High |
| InteractiveVault | Management | 0.5% annual | Medium |
| VaultFactory | Creation | 0.001 ETH | Medium |
| Strategies | Performance | 8-10% | Very High |
| Copy Trading | Leader Fee | Up to 20% | High |

## Expected Outcomes
- **Total Deployments**: 10+ contracts
- **Fee Generation**: Active from day 1
- **User Interactions**: Testnet activity
- **Leaderboard Position**: Top 10 target
