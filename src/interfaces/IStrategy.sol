// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IStrategy
 * @notice Interface for yield strategies
 */
interface IStrategy {
    // Events
    event Harvested(uint256 profit, uint256 loss);
    event Rebalanced(uint256 oldPosition, uint256 newPosition);

    // Errors
    error InsufficientBalance();
    error InvalidVault();

    // Functions
    function vault() external view returns (address);
    function asset() external view returns (address);
    function balanceOf() external view returns (uint256);
    function harvest() external returns (uint256 profit, uint256 loss);
    function withdraw(uint256 amount) external returns (uint256);
    function estimatedTotalAssets() external view returns (uint256);
    function estimatedAPY() external view returns (uint256);
}
