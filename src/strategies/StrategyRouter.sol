// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IStrategy} from "../interfaces/IStrategy.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title StrategyRouter
 * @notice Routes funds to optimal strategy based on APY and risk
 */
contract StrategyRouter {
    using SafeERC20 for IERC20;

    struct StrategyInfo {
        address strategy;
        uint256 allocation; // Target allocation in BPS
        uint256 currentBalance;
        uint256 estimatedAPY;
        uint256 riskScore; // 0-100, higher = riskier
        bool active;
    }

    address public vault;
    StrategyInfo[] public strategies;
    uint256 public constant MAX_BPS = 10_000;
    uint256 public constant MAX_STRATEGIES = 20;

    event StrategyAdded(address indexed strategy, uint256 allocation);
    event StrategyRebalanced(address indexed from, address indexed to, uint256 amount);
    event AllocationUpdated(address indexed strategy, uint256 newAllocation);

    modifier onlyVault() {
        require(msg.sender == vault, "Only vault");
        _;
    }

    constructor(address _vault) {
        vault = _vault;
    }

    function addStrategy(
        address strategy,
        uint256 allocation,
        uint256 riskScore
    ) external onlyVault {
        require(strategies.length < MAX_STRATEGIES, "Max strategies reached");
        require(allocation <= MAX_BPS, "Invalid allocation");

        strategies.push(StrategyInfo({
            strategy: strategy,
            allocation: allocation,
            currentBalance: 0,
            estimatedAPY: 0,
            riskScore: riskScore,
            active: true
        }));

        emit StrategyAdded(strategy, allocation);
    }

    function routeFunds(address asset, uint256 amount) external onlyVault returns (address bestStrategy) {
        require(amount > 0, "Zero amount");

        // Find best strategy based on risk-adjusted returns
        uint256 bestScore = 0;
        uint256 bestIndex = 0;

        for (uint256 i = 0; i < strategies.length; i++) {
            if (!strategies[i].active) continue;

            // Update APY estimate
            strategies[i].estimatedAPY = IStrategy(strategies[i].strategy).estimatedAPY();

            // Risk-adjusted score = APY / (1 + risk/100)
            uint256 score = (strategies[i].estimatedAPY * 100) / (100 + strategies[i].riskScore);

            if (score > bestScore) {
                bestScore = score;
                bestIndex = i;
            }
        }

        bestStrategy = strategies[bestIndex].strategy;
        strategies[bestIndex].currentBalance += amount;

        // Transfer funds to strategy
        IERC20(asset).safeTransferFrom(msg.sender, bestStrategy, amount);
    }

    function rebalance(address asset) external onlyVault {
        uint256 totalAssets = getTotalAssets();
        if (totalAssets == 0) return;

        for (uint256 i = 0; i < strategies.length; i++) {
            if (!strategies[i].active) continue;

            uint256 targetBalance = (totalAssets * strategies[i].allocation) / MAX_BPS;
            uint256 currentBalance = strategies[i].currentBalance;

            if (currentBalance > targetBalance) {
                // Withdraw excess
                uint256 excess = currentBalance - targetBalance;
                IStrategy(strategies[i].strategy).withdraw(excess);
                strategies[i].currentBalance = targetBalance;
            }
        }
    }

    function getTotalAssets() public view returns (uint256 total) {
        for (uint256 i = 0; i < strategies.length; i++) {
            if (strategies[i].active) {
                total += strategies[i].currentBalance;
            }
        }
    }

    function getStrategyCount() external view returns (uint256) {
        return strategies.length;
    }
}
