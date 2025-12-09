// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseVault} from "./BaseVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title PerformanceFeeVault
 * @notice Extended BaseVault with performance fee functionality
 * @dev Charges performance fees on profits and management fees over time
 */
contract PerformanceFeeVault is BaseVault {
    using SafeERC20 for IERC20;

    address public feeCollector;
    uint256 public performanceFeeBps = 200; // 2% default
    uint256 public managementFeeBps = 50;   // 0.5% annual
    uint256 public lastFeeCollection;
    uint256 public highWaterMark;

    event PerformanceFeeCollected(uint256 amount);
    event ManagementFeeCollected(uint256 amount);
    event FeeRatesUpdated(uint256 performanceFee, uint256 managementFee);
    event FeeCollectorUpdated(address indexed newCollector);

    error InvalidFeeRate();

    constructor(
        IERC20 _asset,
        string memory _name,
        string memory _symbol,
        address _feeCollector
    ) BaseVault(_asset, _name, _symbol) {
        feeCollector = _feeCollector;
        lastFeeCollection = block.timestamp;
        highWaterMark = 0;
    }

    /**
     * @notice Collect performance fees on profits
     * @dev Only charges fees if vault value exceeds high water mark
     */
    function collectPerformanceFees() external onlyGovernance returns (uint256) {
        uint256 totalValue = totalAssets();

        if (totalValue <= highWaterMark) {
            return 0; // No profit, no fee
        }

        uint256 profit = totalValue - highWaterMark;
        uint256 feeAmount = (profit * performanceFeeBps) / MAX_BPS;

        if (feeAmount > 0) {
            IERC20(asset()).safeTransfer(feeCollector, feeAmount);
            highWaterMark = totalValue - feeAmount;

            emit PerformanceFeeCollected(feeAmount);
        }

        return feeAmount;
    }

    /**
     * @notice Collect management fees (annual fee pro-rated)
     * @dev Called periodically to collect time-based management fees
     */
    function collectManagementFees() external onlyGovernance returns (uint256) {
        uint256 timeSinceLastCollection = block.timestamp - lastFeeCollection;
        uint256 totalValue = totalAssets();

        // Calculate annual fee pro-rated for time elapsed
        uint256 feeAmount = (totalValue * managementFeeBps * timeSinceLastCollection)
            / (MAX_BPS * 365 days);

        if (feeAmount > 0) {
            IERC20(asset()).safeTransfer(feeCollector, feeAmount);
            lastFeeCollection = block.timestamp;

            emit ManagementFeeCollected(feeAmount);
        }

        return feeAmount;
    }

    /**
     * @notice Update fee rates
     * @param _performanceFeeBps New performance fee in basis points
     * @param _managementFeeBps New management fee in basis points
     */
    function updateFeeRates(
        uint256 _performanceFeeBps,
        uint256 _managementFeeBps
    ) external onlyGovernance {
        if (_performanceFeeBps > 2000 || _managementFeeBps > 200) {
            revert InvalidFeeRate(); // Max 20% performance, 2% management
        }

        performanceFeeBps = _performanceFeeBps;
        managementFeeBps = _managementFeeBps;

        emit FeeRatesUpdated(_performanceFeeBps, _managementFeeBps);
    }

    /**
     * @notice Update fee collector address
     * @param _newCollector New fee collector address
     */
    function updateFeeCollector(address _newCollector) external onlyGovernance {
        if (_newCollector == address(0)) revert ZeroAddress();

        feeCollector = _newCollector;
        emit FeeCollectorUpdated(_newCollector);
    }

    /**
     * @notice Reset high water mark (use with caution)
     */
    function resetHighWaterMark() external onlyGovernance {
        highWaterMark = totalAssets();
    }

    /**
     * @notice Get current fee rates
     */
    function getFeeRates() external view returns (uint256 performance, uint256 management) {
        return (performanceFeeBps, managementFeeBps);
    }
}
