// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {RiskManager} from "./RiskManager.sol";

contract AutoRebalancer {
    RiskManager public riskManager;
    uint256 public rebalanceThreshold = 20; // 20 risk score points

    event Rebalanced(address indexed from, address indexed to, uint256 amount);

    constructor(address _riskManager) {
        riskManager = RiskManager(_riskManager);
    }

    function shouldRebalance(address strategy, address user) external view returns (bool) {
        return !riskManager.isAcceptableRisk(strategy, user);
    }

    function rebalance(address fromStrategy, address toStrategy, uint256 amount) external {
        // Placeholder implementation
        emit Rebalanced(fromStrategy, toStrategy, amount);
    }
}
