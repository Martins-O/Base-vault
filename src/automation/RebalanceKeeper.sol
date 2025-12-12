// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {StrategyRouter} from "../strategies/StrategyRouter.sol";

/**
 * @title RebalanceKeeper
 * @notice Chainlink Automation compatible keeper for rebalancing
 */
contract RebalanceKeeper {
    StrategyRouter public immutable router;
    address public immutable asset;

    uint256 public rebalanceInterval = 12 hours;
    uint256 public lastRebalance;
    uint256 public rebalanceThreshold = 500; // 5% deviation triggers rebalance

    event RebalanceTriggered(uint256 timestamp);
    event ThresholdUpdated(uint256 newThreshold);

    constructor(address _router, address _asset) {
        router = StrategyRouter(_router);
        asset = _asset;
        lastRebalance = block.timestamp;
    }

    function checkUpkeep(bytes calldata)
        external
        view
        returns (bool upkeepNeeded, bytes memory)
    {
        // Check if enough time has passed
        bool timeElapsed = block.timestamp >= lastRebalance + rebalanceInterval;

        // Check if deviation exceeds threshold
        bool needsRebalance = _checkDeviation();

        upkeepNeeded = timeElapsed && needsRebalance;
    }

    function performUpkeep(bytes calldata) external {
        require(
            block.timestamp >= lastRebalance + rebalanceInterval,
            "Too soon"
        );

        router.rebalance(asset);
        lastRebalance = block.timestamp;

        emit RebalanceTriggered(block.timestamp);
    }

    function _checkDeviation() internal view returns (bool) {
        // Simplified: in production, calculate actual allocation deviation
        uint256 totalAssets = router.getTotalAssets();
        if (totalAssets == 0) return false;

        // Would check if any strategy deviates from target allocation by > threshold
        return true; // Placeholder
    }

    function setRebalanceInterval(uint256 interval) external {
        rebalanceInterval = interval;
    }

    function setThreshold(uint256 threshold) external {
        require(threshold <= 10_000, "Invalid threshold");
        rebalanceThreshold = threshold;
        emit ThresholdUpdated(threshold);
    }
}
