// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title FeeAnalytics
 * @notice Advanced analytics and reporting for fee generation
 */
contract FeeAnalytics {
    struct DailyStats {
        uint256 totalFees;
        uint256 depositFees;
        uint256 withdrawalFees;
        uint256 performanceFees;
        uint256 txCount;
        uint256 uniqueUsers;
    }

    struct VaultMetrics {
        uint256 lifetimeFees;
        uint256 averageDailyFees;
        uint256 peakDailyFees;
        uint256 totalTransactions;
        uint256 feeGrowthRate; // In bps per day
    }

    mapping(address => mapping(uint256 => DailyStats)) public dailyStats; // vault => day => stats
    mapping(address => VaultMetrics) public vaultMetrics;
    mapping(address => mapping(uint256 => mapping(address => bool))) private userSeenToday;

    event StatsRecorded(address indexed vault, uint256 indexed day, uint256 totalFees);

    function recordTransaction(
        address vault,
        string memory feeType,
        uint256 feeAmount,
        address user
    ) external {
        uint256 today = block.timestamp / 1 days;
        DailyStats storage stats = dailyStats[vault][today];

        stats.totalFees += feeAmount;
        stats.txCount++;

        // Track unique users
        if (!userSeenToday[vault][today][user]) {
            stats.uniqueUsers++;
            userSeenToday[vault][today][user] = true;
        }

        // Categorize fee type
        if (keccak256(bytes(feeType)) == keccak256("deposit")) {
            stats.depositFees += feeAmount;
        } else if (keccak256(bytes(feeType)) == keccak256("withdrawal")) {
            stats.withdrawalFees += feeAmount;
        } else if (keccak256(bytes(feeType)) == keccak256("performance")) {
            stats.performanceFees += feeAmount;
        }

        // Update vault metrics
        VaultMetrics storage metrics = vaultMetrics[vault];
        metrics.lifetimeFees += feeAmount;
        metrics.totalTransactions++;

        if (stats.totalFees > metrics.peakDailyFees) {
            metrics.peakDailyFees = stats.totalFees;
        }

        emit StatsRecorded(vault, today, stats.totalFees);
    }

    function getDailyStats(address vault, uint256 day)
        external
        view
        returns (DailyStats memory)
    {
        return dailyStats[vault][day];
    }

    function getLastNDaysStats(address vault, uint256 n)
        external
        view
        returns (uint256 totalFees, uint256 avgFees)
    {
        uint256 today = block.timestamp / 1 days;

        for (uint256 i = 0; i < n; i++) {
            totalFees += dailyStats[vault][today - i].totalFees;
        }

        avgFees = n > 0 ? totalFees / n : 0;
    }

    function calculateFeeGrowthRate(address vault, uint256 days)
        external
        view
        returns (uint256 growthRate)
    {
        if (days < 2) return 0;

        uint256 today = block.timestamp / 1 days;
        uint256 recentFees = dailyStats[vault][today].totalFees;
        uint256 oldFees = dailyStats[vault][today - days].totalFees;

        if (oldFees == 0) return 0;

        // Growth rate in basis points
        growthRate = ((recentFees - oldFees) * 10000) / oldFees / days;
    }
}
