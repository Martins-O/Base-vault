// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseStrategy} from "./BaseStrategy.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title YieldFarmingStrategy
 * @notice Strategy for yield farming with auto-compounding
 */
contract YieldFarmingStrategy is BaseStrategy {
    using SafeERC20 for IERC20;

    address public immutable rewardToken;
    address public immutable stakingPool;
    address public immutable feeCollector;

    uint256 public totalStaked;
    uint256 public lastHarvest;
    uint256 public accumulatedRewards;
    uint256 public performanceFeeBps = 1000; // 10%

    uint256 public constant MAX_BPS = 10_000;
    uint256 public constant MIN_HARVEST_INTERVAL = 6 hours;

    event Staked(uint256 amount);
    event Unstaked(uint256 amount);
    event Harvested(uint256 rewards, uint256 fee);
    event Compounded(uint256 amount);

    constructor(
        address _vault,
        address _asset,
        address _rewardToken,
        address _stakingPool,
        address _feeCollector
    ) BaseStrategy(_vault, _asset) {
        rewardToken = _rewardToken;
        stakingPool = _stakingPool;
        feeCollector = _feeCollector;
        lastHarvest = block.timestamp;
    }

    function deposit(uint256 amount) external override onlyVault returns (uint256) {
        require(amount > 0, "Zero amount");

        IERC20(asset).safeTransferFrom(msg.sender, address(this), amount);

        // Stake in pool
        IERC20(asset).approve(stakingPool, amount);
        // Pool stake call would go here
        totalStaked += amount;

        emit Staked(amount);
        return amount;
    }

    function withdraw(uint256 amount) external override onlyVault returns (uint256) {
        require(amount > 0, "Zero amount");
        require(amount <= totalStaked, "Insufficient balance");

        // Unstake from pool
        // Pool unstake call would go here
        totalStaked -= amount;

        IERC20(asset).safeTransfer(msg.sender, amount);

        emit Unstaked(amount);
        return amount;
    }

    function harvest() external override returns (uint256 profit, uint256 loss) {
        require(
            block.timestamp >= lastHarvest + MIN_HARVEST_INTERVAL,
            "Too soon to harvest"
        );

        // Claim rewards from pool
        // Pool claim rewards call would go here
        uint256 rewards = totalStaked / 50; // Simulated 2% reward

        if (rewards > 0) {
            // Calculate performance fee
            uint256 fee = (rewards * performanceFeeBps) / MAX_BPS;
            uint256 netRewards = rewards - fee;

            // Transfer fee
            if (fee > 0) {
                IERC20(rewardToken).safeTransfer(feeCollector, fee);
            }

            // Compound net rewards
            _compound(netRewards);

            accumulatedRewards += netRewards;
            profit = netRewards;

            emit Harvested(rewards, fee);
        }

        lastHarvest = block.timestamp;
        return (profit, 0);
    }

    function _compound(uint256 rewardAmount) internal {
        // Swap rewards to asset
        // In production: use DEX router to swap rewardToken to asset

        // Stake compounded amount
        totalStaked += rewardAmount;

        emit Compounded(rewardAmount);
    }

    function estimatedAPY() external view override returns (uint256) {
        if (totalStaked == 0) return 0;

        // Simplified APY calculation
        // In production: calculate based on actual pool APY
        uint256 annualRewards = (totalStaked * 24) / 100; // 24% base APY
        uint256 afterFees = (annualRewards * (MAX_BPS - performanceFeeBps)) / MAX_BPS;

        return (afterFees * MAX_BPS) / totalStaked;
    }

    function estimatedTotalAssets() external view override returns (uint256) {
        return totalStaked + accumulatedRewards;
    }
}
