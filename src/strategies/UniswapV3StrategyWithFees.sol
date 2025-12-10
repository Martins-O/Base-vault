// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseStrategy} from "./BaseStrategy.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract UniswapV3StrategyWithFees is BaseStrategy {
    using SafeERC20 for IERC20;
    
    address public feeCollector;
    uint256 public performanceFeeBps = 800; // 8%
    uint256 public totalLiquidity;
    
    event FeesEarned(uint256 amount);
    event LiquidityAdded(uint256 amount);
    
    constructor(
        address _vault,
        address _asset,
        address _feeCollector
    ) BaseStrategy(_vault, _asset) {
        feeCollector = _feeCollector;
    }
    
    function addLiquidity(uint256 amount) external {
        _checkVault();
        IERC20(asset).safeTransferFrom(msg.sender, address(this), amount);
        totalLiquidity += amount;
        emit LiquidityAdded(amount);
    }
    
    function balanceOf() public view override returns (uint256) {
        return totalLiquidity;
    }
    
    function harvest() external override returns (uint256 profit, uint256 loss) {
        _checkVault();
        
        // Simulate Uniswap V3 fee collection
        uint256 tradingFees = totalLiquidity / 20; // 5% trading fees
        uint256 strategyFee = (tradingFees * performanceFeeBps) / MAX_BPS;
        
        if (strategyFee > 0) {
            IERC20(asset).safeTransfer(feeCollector, strategyFee);
            emit FeesEarned(strategyFee);
        }
        
        return (tradingFees - strategyFee, 0);
    }
    
    function withdraw(uint256 amount) external override returns (uint256) {
        _checkVault();
        if (amount > totalLiquidity) amount = totalLiquidity;
        totalLiquidity -= amount;
        IERC20(asset).safeTransfer(vault, amount);
        return amount;
    }
    
    function estimatedTotalAssets() external view override returns (uint256) {
        return totalLiquidity;
    }
    
    function estimatedAPY() external pure override returns (uint256) {
        return 1200; // 12% APY
    }
    
    uint256 private constant MAX_BPS = 10000;
}
