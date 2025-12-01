// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC4626} from "@openzeppelin/contracts/interfaces/IERC4626.sol";

/**
 * @title IBaseVault
 * @notice Interface for BaseVault - ERC4626 compliant vault with additional features
 */
interface IBaseVault is IERC4626 {
    // Events
    event StrategyAdded(address indexed strategy, uint256 weight);
    event StrategyRemoved(address indexed strategy);
    event Harvested(uint256 profit);
    event FeesUpdated(uint256 performanceFee, uint256 managementFee);

    // Errors
    error InvalidStrategy();
    error StrategyAlreadyExists();
    error ExceedsDepositLimit();
    error WithdrawalFailed();

    // Functions
    function addStrategy(address strategy, uint256 weight) external;
    function removeStrategy(address strategy) external;
    function harvest() external returns (uint256 profit);
    function totalAssets() external view override returns (uint256);
    function getStrategies() external view returns (address[] memory);
}
