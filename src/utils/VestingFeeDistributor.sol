// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title VestingFeeDistributor
 * @notice Distributes fees with optional vesting schedule
 */
contract VestingFeeDistributor is ReentrancyGuard {
    using SafeERC20 for IERC20;

    struct Recipient {
        uint256 share; // In basis points
        uint256 vestingDuration; // In seconds, 0 for immediate
        uint256 lastClaim;
        uint256 pending;
    }

    mapping(address => Recipient) public recipients;
    address[] public recipientList;
    uint256 public totalShares;
    uint256 public constant MAX_BPS = 10_000;

    event FeeDistributed(address indexed token, uint256 amount);
    event FeeClaimed(address indexed recipient, address indexed token, uint256 amount);

    constructor(
        address[] memory _recipients,
        uint256[] memory _shares,
        uint256[] memory _vestingDurations
    ) {
        require(_recipients.length == _shares.length, "Length mismatch");
        require(_recipients.length == _vestingDurations.length, "Length mismatch");

        for (uint256 i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0), "Invalid recipient");

            recipients[_recipients[i]] = Recipient({
                share: _shares[i],
                vestingDuration: _vestingDurations[i],
                lastClaim: block.timestamp,
                pending: 0
            });

            recipientList.push(_recipients[i]);
            totalShares += _shares[i];
        }

        require(totalShares == MAX_BPS, "Shares must sum to 100%");
    }

    function distributeFees(address token, uint256 amount) external nonReentrant {
        require(amount > 0, "Zero amount");

        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);

        for (uint256 i = 0; i < recipientList.length; i++) {
            address recipient = recipientList[i];
            Recipient storage rec = recipients[recipient];

            uint256 recipientAmount = (amount * rec.share) / MAX_BPS;

            if (rec.vestingDuration == 0) {
                // Immediate distribution
                IERC20(token).safeTransfer(recipient, recipientAmount);
            } else {
                // Add to pending vesting
                rec.pending += recipientAmount;
            }
        }

        emit FeeDistributed(token, amount);
    }

    function claimVested(address token) external nonReentrant {
        Recipient storage rec = recipients[msg.sender];
        require(rec.share > 0, "Not a recipient");
        require(rec.vestingDuration > 0, "No vesting");

        uint256 elapsed = block.timestamp - rec.lastClaim;
        require(elapsed > 0, "Too soon");

        uint256 vestedAmount;
        if (elapsed >= rec.vestingDuration) {
            vestedAmount = rec.pending;
        } else {
            vestedAmount = (rec.pending * elapsed) / rec.vestingDuration;
        }

        require(vestedAmount > 0, "Nothing to claim");

        rec.pending -= vestedAmount;
        rec.lastClaim = block.timestamp;

        IERC20(token).safeTransfer(msg.sender, vestedAmount);

        emit FeeClaimed(msg.sender, token, vestedAmount);
    }
}
