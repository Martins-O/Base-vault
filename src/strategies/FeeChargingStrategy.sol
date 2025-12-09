// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseStrategy} from "./BaseStrategy.sol";

contract FeeChargingStrategy is BaseStrategy {
    address public feeCollector;
    uint256 public performanceFeeBps = 1000; // 10%
    
    event PerformanceFeeCharged(uint256 amount);
    
    constructor(
        address _vault,
        address _asset,
        address _feeCollector
    ) BaseStrategy(_vault, _asset) {
        feeCollector = _feeCollector;
    }
    
    function balanceOf() public pure override returns (uint256) {
        return 0;
    }
    
    function harvest() external override returns (uint256 profit, uint256 loss) {
        // Charge 10% performance fee on harvest
        uint256 harvestedAmount = 1000e18; // Example
        uint256 fee = (harvestedAmount * performanceFeeBps) / 10000;
        
        emit PerformanceFeeCharged(fee);
        return (harvestedAmount - fee, 0);
    }
    
    function withdraw(uint256 amount) external override returns (uint256) {
        _checkVault();
        return amount;
    }
    
    function estimatedTotalAssets() external pure override returns (uint256) {
        return 1000e18;
    }
    
    function estimatedAPY() external pure override returns (uint256) {
        return 800; // 8%
    }
}
