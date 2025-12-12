// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title StrategyPerformance
 * @notice Track and analyze strategy performance metrics
 */
contract StrategyPerformance {
    struct PerformanceData {
        uint256 totalProfit;
        uint256 totalLoss;
        uint256 harvestCount;
        uint256 lastHarvestTime;
        uint256 avgHarvestProfit;
        uint256 sharpeRatio; // Scaled by 1e18
        uint256 maxDrawdown; // In basis points
        uint256 consistencyScore; // 0-100
    }

    mapping(address => PerformanceData) public strategyPerformance;
    mapping(address => uint256[]) public harvestHistory;

    uint256 public constant PRECISION = 1e18;

    event PerformanceRecorded(
        address indexed strategy,
        uint256 profit,
        uint256 loss,
        uint256 harvestTime
    );

    function recordHarvest(
        address strategy,
        uint256 profit,
        uint256 loss
    ) external {
        PerformanceData storage perf = strategyPerformance[strategy];

        perf.totalProfit += profit;
        perf.totalLoss += loss;
        perf.harvestCount++;
        perf.lastHarvestTime = block.timestamp;

        if (perf.harvestCount > 0) {
            perf.avgHarvestProfit = perf.totalProfit / perf.harvestCount;
        }

        // Store harvest in history
        harvestHistory[strategy].push(profit);

        // Update advanced metrics
        _updateSharpeRatio(strategy);
        _updateConsistencyScore(strategy);

        emit PerformanceRecorded(strategy, profit, loss, block.timestamp);
    }

    function _updateSharpeRatio(address strategy) internal {
        PerformanceData storage perf = strategyPerformance[strategy];
        uint256[] storage history = harvestHistory[strategy];

        if (history.length < 2) return;

        // Calculate standard deviation of returns
        uint256 mean = perf.avgHarvestProfit;
        uint256 sumSquaredDiff = 0;

        for (uint256 i = 0; i < history.length; i++) {
            uint256 diff = history[i] > mean ? history[i] - mean : mean - history[i];
            sumSquaredDiff += diff * diff;
        }

        uint256 variance = sumSquaredDiff / history.length;
        uint256 stdDev = _sqrt(variance);

        if (stdDev > 0) {
            perf.sharpeRatio = (mean * PRECISION) / stdDev;
        }
    }

    function _updateConsistencyScore(address strategy) internal {
        PerformanceData storage perf = strategyPerformance[strategy];
        uint256[] storage history = harvestHistory[strategy];

        if (history.length < 3) {
            perf.consistencyScore = 50;
            return;
        }

        // Count profitable harvests
        uint256 profitable = 0;
        for (uint256 i = 0; i < history.length; i++) {
            if (history[i] > 0) profitable++;
        }

        // Score based on profit rate and variance
        uint256 profitRate = (profitable * 100) / history.length;
        perf.consistencyScore = profitRate;
    }

    function _sqrt(uint256 x) internal pure returns (uint256) {
        if (x == 0) return 0;
        uint256 z = (x + 1) / 2;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }

    function getStrategyRanking(address[] calldata strategies)
        external
        view
        returns (address[] memory ranked)
    {
        ranked = new address[](strategies.length);
        uint256[] memory scores = new uint256[](strategies.length);

        // Calculate composite score for each strategy
        for (uint256 i = 0; i < strategies.length; i++) {
            PerformanceData memory perf = strategyPerformance[strategies[i]];

            // Composite score = profit + sharpe + consistency
            scores[i] = perf.totalProfit +
                (perf.sharpeRatio / PRECISION) +
                perf.consistencyScore;
        }

        // Simple bubble sort (fine for small arrays)
        for (uint256 i = 0; i < strategies.length; i++) {
            for (uint256 j = i + 1; j < strategies.length; j++) {
                if (scores[j] > scores[i]) {
                    (scores[i], scores[j]) = (scores[j], scores[i]);
                    (strategies[i], strategies[j]) = (strategies[j], strategies[i]);
                }
            }
        }

        return strategies;
    }

    function getHarvestHistory(address strategy)
        external
        view
        returns (uint256[] memory)
    {
        return harvestHistory[strategy];
    }
}
