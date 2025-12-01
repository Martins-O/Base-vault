// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title YieldCalculator
 * @notice Library for calculating APY and yield metrics
 */
library YieldCalculator {
    uint256 private constant SECONDS_PER_YEAR = 365 days;
    uint256 private constant PRECISION = 1e18;

    /**
     * @notice Calculate APY based on profit over time period
     * @param profit The profit earned
     * @param principal The principal amount
     * @param timeElapsed Time in seconds
     * @return apy Annual Percentage Yield in basis points
     */
    function calculateAPY(
        uint256 profit,
        uint256 principal,
        uint256 timeElapsed
    ) internal pure returns (uint256 apy) {
        if (principal == 0 || timeElapsed == 0) return 0;

        // Calculate annualized return
        uint256 periodReturn = (profit * PRECISION) / principal;
        apy = (periodReturn * SECONDS_PER_YEAR) / timeElapsed;

        // Convert to basis points (1 bps = 0.01%)
        return (apy * 10000) / PRECISION;
    }

    /**
     * @notice Calculate compound interest
     * @param principal The principal amount
     * @param rate The interest rate (in basis points)
     * @param periods Number of compounding periods
     * @return result The final amount after compounding
     */
    function compound(
        uint256 principal,
        uint256 rate,
        uint256 periods
    ) internal pure returns (uint256 result) {
        result = principal;
        for (uint256 i = 0; i < periods; i++) {
            result += (result * rate) / 10000;
        }
    }
}
