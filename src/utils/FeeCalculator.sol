// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library FeeCalculator {
    uint256 constant MAX_BPS = 10000;
    
    function calculatePerformanceFee(uint256 profit, uint256 feeBps) internal pure returns (uint256) {
        return (profit * feeBps) / MAX_BPS;
    }
    
    function calculateManagementFee(
        uint256 totalValue,
        uint256 feeBps,
        uint256 timeElapsed
    ) internal pure returns (uint256) {
        return (totalValue * feeBps * timeElapsed) / (MAX_BPS * 365 days);
    }
    
    function calculateDepositFee(uint256 amount, uint256 feeBps) internal pure returns (uint256) {
        return (amount * feeBps) / MAX_BPS;
    }
}
