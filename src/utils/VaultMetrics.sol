// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC4626} from "@openzeppelin/contracts/interfaces/IERC4626.sol";

/**
 * @title VaultMetrics
 * @notice Aggregate and calculate vault metrics for dashboards
 */
contract VaultMetrics {
    struct Metrics {
        uint256 tvl;
        uint256 totalShares;
        uint256 pricePerShare;
        uint256 apy;
        uint256 totalUsers;
        uint256 dailyVolume;
        uint256 weeklyVolume;
        uint256 feesGenerated;
    }

    struct HistoricalData {
        uint256 timestamp;
        uint256 tvl;
        uint256 pricePerShare;
    }

    mapping(address => HistoricalData[]) public history;
    mapping(address => uint256) public lastSnapshotTime;

    uint256 public constant SNAPSHOT_INTERVAL = 1 hours;

    event SnapshotTaken(address indexed vault, uint256 tvl, uint256 pricePerShare);

    function recordSnapshot(address vault) external {
        require(
            block.timestamp >= lastSnapshotTime[vault] + SNAPSHOT_INTERVAL,
            "Too soon"
        );

        IERC4626 v = IERC4626(vault);

        uint256 tvl = v.totalAssets();
        uint256 totalSupply = v.totalSupply();
        uint256 pricePerShare = totalSupply > 0 ? (tvl * 1e18) / totalSupply : 1e18;

        history[vault].push(
            HistoricalData({
                timestamp: block.timestamp,
                tvl: tvl,
                pricePerShare: pricePerShare
            })
        );

        lastSnapshotTime[vault] = block.timestamp;

        emit SnapshotTaken(vault, tvl, pricePerShare);
    }

    function getMetrics(address vault) external view returns (Metrics memory metrics) {
        IERC4626 v = IERC4626(vault);

        metrics.tvl = v.totalAssets();
        metrics.totalShares = v.totalSupply();

        if (metrics.totalShares > 0) {
            metrics.pricePerShare = (metrics.tvl * 1e18) / metrics.totalShares;
        } else {
            metrics.pricePerShare = 1e18;
        }

        metrics.apy = _calculateAPY(vault);
    }

    function _calculateAPY(address vault) internal view returns (uint256) {
        HistoricalData[] storage data = history[vault];

        if (data.length < 2) return 0;

        // Use last 7 days for APY calculation
        uint256 weekAgo = block.timestamp - 7 days;
        uint256 oldPricePerShare = 1e18;

        // Find price from ~1 week ago
        for (uint256 i = data.length; i > 0; i--) {
            if (data[i - 1].timestamp <= weekAgo) {
                oldPricePerShare = data[i - 1].pricePerShare;
                break;
            }
        }

        uint256 currentPrice = data[data.length - 1].pricePerShare;

        if (currentPrice <= oldPricePerShare) return 0;

        // Calculate weekly return
        uint256 weeklyReturn = ((currentPrice - oldPricePerShare) * 10_000) / oldPricePerShare;

        // Annualize (52 weeks)
        return weeklyReturn * 52;
    }

    function getHistoricalData(address vault, uint256 fromIndex, uint256 toIndex)
        external
        view
        returns (HistoricalData[] memory)
    {
        require(toIndex >= fromIndex, "Invalid range");

        HistoricalData[] storage data = history[vault];
        uint256 length = toIndex - fromIndex + 1;

        if (toIndex >= data.length) {
            length = data.length - fromIndex;
        }

        HistoricalData[] memory result = new HistoricalData[](length);

        for (uint256 i = 0; i < length; i++) {
            result[i] = data[fromIndex + i];
        }

        return result;
    }

    function getLatestSnapshots(address vault, uint256 count)
        external
        view
        returns (HistoricalData[] memory)
    {
        HistoricalData[] storage data = history[vault];

        if (count > data.length) {
            count = data.length;
        }

        HistoricalData[] memory result = new HistoricalData[](count);
        uint256 startIndex = data.length - count;

        for (uint256 i = 0; i < count; i++) {
            result[i] = data[startIndex + i];
        }

        return result;
    }
}
