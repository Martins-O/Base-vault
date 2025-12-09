// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title FeeCollector
 * @notice Collects and distributes fees from vault operations
 * @dev This contract accumulates fees and allows withdrawal by governance
 */
contract FeeCollector {
    using SafeERC20 for IERC20;

    address public treasury;
    address public governance;

    mapping(address => uint256) public collectedFees; // token => amount

    event FeeCollected(address indexed token, uint256 amount);
    event FeesWithdrawn(address indexed token, address indexed to, uint256 amount);
    event TreasuryUpdated(address indexed oldTreasury, address indexed newTreasury);

    error Unauthorized();
    error ZeroAddress();
    error InsufficientFees();

    modifier onlyGovernance() {
        if (msg.sender != governance) revert Unauthorized();
        _;
    }

    constructor(address _treasury) {
        if (_treasury == address(0)) revert ZeroAddress();
        treasury = _treasury;
        governance = msg.sender;
    }

    /**
     * @notice Collect fees from vault operations
     * @param token Fee token address
     * @param amount Fee amount
     */
    function collectFee(address token, uint256 amount) external {
        if (amount == 0) return;

        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        collectedFees[token] += amount;

        emit FeeCollected(token, amount);
    }

    /**
     * @notice Withdraw collected fees to treasury
     * @param token Token to withdraw
     * @param amount Amount to withdraw
     */
    function withdrawFees(address token, uint256 amount) external onlyGovernance {
        if (amount > collectedFees[token]) revert InsufficientFees();

        collectedFees[token] -= amount;
        IERC20(token).safeTransfer(treasury, amount);

        emit FeesWithdrawn(token, treasury, amount);
    }

    /**
     * @notice Update treasury address
     * @param newTreasury New treasury address
     */
    function updateTreasury(address newTreasury) external onlyGovernance {
        if (newTreasury == address(0)) revert ZeroAddress();

        address oldTreasury = treasury;
        treasury = newTreasury;

        emit TreasuryUpdated(oldTreasury, newTreasury);
    }

    /**
     * @notice Get total fees collected for a token
     * @param token Token address
     * @return Total fees collected
     */
    function getTotalFees(address token) external view returns (uint256) {
        return collectedFees[token];
    }
}
