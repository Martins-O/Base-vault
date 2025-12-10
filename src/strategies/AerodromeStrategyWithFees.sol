// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseStrategy} from "./BaseStrategy.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract AerodromeStrategyWithFees is BaseStrategy {
    using SafeERC20 for IERC20;
    
    address public feeCollector;
    uint256 public performanceFeeBps = 1000; // 10%
    uint256 public totalDeposits;
    
    event HarvestFeeCollected(uint256 amount);
    
    constructor(
        address _vault,
        address _asset,
        address _feeCollector
    ) BaseStrategy(_vault, _asset) {
        feeCollector = _feeCollector;
    }
    
    function deposit(uint256 amount) external {
        _checkVault();
        IERC20(asset).safeTransferFrom(msg.sender, address(this), amount);
        totalDeposits += amount;
    }
    
    function balanceOf() public view override returns (uint256) {
        return totalDeposits;
    }
    
    function harvest() external override returns (uint256 profit, uint256 loss) {
        _checkVault();
        
        // Simulate harvest profit
        uint256 harvestedAmount = totalDeposits / 10; // 10% profit
        uint256 fee = (harvestedAmount * performanceFeeBps) / MAX_BPS;
        
        if (fee > 0) {
            IERC20(asset).safeTransfer(feeCollector, fee);
            emit HarvestFeeCollected(fee);
        }
        
        return (harvestedAmount - fee, 0);
    }
    
    function withdraw(uint256 amount) external override returns (uint256) {
        _checkVault();
        if (amount > totalDeposits) amount = totalDeposits;
        totalDeposits -= amount;
        IERC20(asset).safeTransfer(vault, amount);
        return amount;
    }
    
    function estimatedTotalAssets() external view override returns (uint256) {
        return totalDeposits;
    }
    
    function estimatedAPY() external pure override returns (uint256) {
        return 800; // 8% APY
    }
    
    uint256 private constant MAX_BPS = 10000;
}
