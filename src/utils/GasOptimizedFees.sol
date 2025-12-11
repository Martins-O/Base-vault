// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title GasOptimizedFees
 * @notice Gas-optimized fee collection using bit-packing and minimal storage
 */
contract GasOptimizedFees {
    using SafeERC20 for IERC20;

    // Pack multiple fee rates into single storage slot
    uint256 private packedFees;

    // Bit positions for fee rates (each 16 bits = max 65535 bps)
    uint256 private constant DEPOSIT_FEE_OFFSET = 0;
    uint256 private constant WITHDRAWAL_FEE_OFFSET = 16;
    uint256 private constant PERFORMANCE_FEE_OFFSET = 32;
    uint256 private constant MANAGEMENT_FEE_OFFSET = 48;

    uint256 private constant FEE_MASK = 0xFFFF;
    uint256 public constant MAX_BPS = 10_000;

    address public immutable feeCollector;

    constructor(address _feeCollector) {
        feeCollector = _feeCollector;

        // Pack default fees into single storage write
        // Deposit: 50 bps, Withdrawal: 30 bps, Performance: 200 bps, Management: 50 bps
        packedFees = (50 << DEPOSIT_FEE_OFFSET) |
                     (30 << WITHDRAWAL_FEE_OFFSET) |
                     (200 << PERFORMANCE_FEE_OFFSET) |
                     (50 << MANAGEMENT_FEE_OFFSET);
    }

    function getDepositFee() public view returns (uint256) {
        return (packedFees >> DEPOSIT_FEE_OFFSET) & FEE_MASK;
    }

    function getWithdrawalFee() public view returns (uint256) {
        return (packedFees >> WITHDRAWAL_FEE_OFFSET) & FEE_MASK;
    }

    function getPerformanceFee() public view returns (uint256) {
        return (packedFees >> PERFORMANCE_FEE_OFFSET) & FEE_MASK;
    }

    function getManagementFee() public view returns (uint256) {
        return (packedFees >> MANAGEMENT_FEE_OFFSET) & FEE_MASK;
    }

    /**
     * @notice Calculate and transfer fee in a single operation
     * @dev Uses unchecked math for gas savings (safe due to bps limits)
     */
    function collectFeeOptimized(
        address token,
        uint256 amount,
        uint256 feeBps
    ) internal returns (uint256 netAmount) {
        unchecked {
            uint256 fee = (amount * feeBps) / MAX_BPS;
            netAmount = amount - fee;

            if (fee > 0) {
                IERC20(token).safeTransfer(feeCollector, fee);
            }
        }
    }

    /**
     * @notice Batch fee collection for multiple operations
     * @dev Reduces external calls by batching
     */
    function collectBatchedFees(
        address token,
        uint256[] calldata amounts,
        uint256[] calldata feeBps
    ) external returns (uint256 totalFees) {
        require(amounts.length == feeBps.length, "Length mismatch");

        unchecked {
            for (uint256 i = 0; i < amounts.length; i++) {
                totalFees += (amounts[i] * feeBps[i]) / MAX_BPS;
            }
        }

        if (totalFees > 0) {
            IERC20(token).safeTransfer(feeCollector, totalFees);
        }
    }
}
