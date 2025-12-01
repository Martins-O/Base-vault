// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Math
 * @notice Math utilities for BaseVault
 */
library Math {
    uint256 private constant BASIS_POINTS = 10000;

    /**
     * @notice Calculate percentage of a value
     * @param value The value to calculate percentage of
     * @param bps Basis points (1 bps = 0.01%)
     * @return result The calculated percentage
     */
    function percentage(uint256 value, uint256 bps) internal pure returns (uint256) {
        return (value * bps) / BASIS_POINTS;
    }

    /**
     * @notice Calculate the minimum of two values
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @notice Calculate the maximum of two values
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }
}
