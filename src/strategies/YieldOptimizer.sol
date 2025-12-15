// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title YieldOptimizer
 * @notice Automatically routes funds to highest yielding strategies
 */
contract YieldOptimizer {
    struct Strategy {
        address strategy;
        uint256 apy;
        uint256 tvl;
        uint256 lastUpdate;
    }

    mapping(address => Strategy[]) public strategies;

    function addStrategy(address vault, address strategy, uint256 apy) external {
        strategies[vault].push(Strategy({
            strategy: strategy,
            apy: apy,
            tvl: 0,
            lastUpdate: block.timestamp
        }));
    }

    function getBestStrategy(address vault) external view returns (address best) {
        Strategy[] memory strats = strategies[vault];
        uint256 highestAPY = 0;

        for (uint256 i = 0; i < strats.length; i++) {
            if (strats[i].apy > highestAPY) {
                highestAPY = strats[i].apy;
                best = strats[i].strategy;
            }
        }
    }
}
