// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SlippageProtection
 * @notice Slippage protection for vault deposits and withdrawals
 */
library SlippageProtection {
    uint256 public constant MAX_BPS = 10_000;

    error SlippageTooHigh(uint256 actual, uint256 minimum);

    function checkSlippage(
        uint256 actualAmount,
        uint256 expectedAmount,
        uint256 maxSlippageBps
    ) internal pure {
        uint256 minimumAcceptable = (expectedAmount * (MAX_BPS - maxSlippageBps)) / MAX_BPS;

        if (actualAmount < minimumAcceptable) {
            revert SlippageTooHigh(actualAmount, minimumAcceptable);
        }
    }

    function calculateMinimumOut(
        uint256 expectedAmount,
        uint256 maxSlippageBps
    ) internal pure returns (uint256) {
        return (expectedAmount * (MAX_BPS - maxSlippageBps)) / MAX_BPS;
    }

    function calculateActualSlippage(
        uint256 actualAmount,
        uint256 expectedAmount
    ) internal pure returns (uint256 slippageBps) {
        if (actualAmount >= expectedAmount) return 0;

        uint256 diff = expectedAmount - actualAmount;
        slippageBps = (diff * MAX_BPS) / expectedAmount;
    }
}
