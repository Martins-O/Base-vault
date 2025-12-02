// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StrategyManager {
    mapping(address => uint256) public strategyAllocations;
    address[] public activeStrategies;

    event AllocationUpdated(address indexed strategy, uint256 allocation);

    function updateAllocation(address strategy, uint256 allocation) external {
        strategyAllocations[strategy] = allocation;
        emit AllocationUpdated(strategy, allocation);
    }

    function getActiveStrategies() external view returns (address[] memory) {
        return activeStrategies;
    }
}
