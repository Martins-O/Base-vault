// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title LiquidationProtection
 * @notice Protect against liquidation cascades
 */
contract LiquidationProtection {
    uint256 public constant HEALTH_FACTOR_MIN = 1.5e18;

    function checkHealthFactor(address user, uint256 debt, uint256 collateral)
        external
        pure
        returns (uint256 healthFactor)
    {
        if (debt == 0) return type(uint256).max;
        healthFactor = (collateral * 1e18) / debt;
    }

    function isLiquidatable(uint256 healthFactor) external pure returns (bool) {
        return healthFactor < HEALTH_FACTOR_MIN;
    }
}
