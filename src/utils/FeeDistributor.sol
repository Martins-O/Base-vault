// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title FeeDistributor
 * @notice Distributes collected fees to multiple recipients
 */
contract FeeDistributor is ReentrancyGuard {
    using SafeERC20 for IERC20;

    struct Recipient {
        address addr;
        uint256 share; // In basis points (10000 = 100%)
    }

    Recipient[] public recipients;
    uint256 public constant MAX_BPS = 10_000;

    event FeeDistributed(address indexed token, uint256 totalAmount);
    event RecipientPaid(address indexed recipient, address indexed token, uint256 amount);

    constructor(address[] memory _recipients, uint256[] memory _shares) {
        require(_recipients.length == _shares.length, "Length mismatch");

        uint256 totalShares;
        for (uint256 i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0), "Invalid recipient");
            recipients.push(Recipient({
                addr: _recipients[i],
                share: _shares[i]
            }));
            totalShares += _shares[i];
        }

        require(totalShares == MAX_BPS, "Shares must sum to 100%");
    }

    function distributeFees(address token, uint256 amount) external nonReentrant {
        require(amount > 0, "Zero amount");

        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);

        for (uint256 i = 0; i < recipients.length; i++) {
            uint256 recipientAmount = (amount * recipients[i].share) / MAX_BPS;

            if (recipientAmount > 0) {
                IERC20(token).safeTransfer(recipients[i].addr, recipientAmount);
                emit RecipientPaid(recipients[i].addr, token, recipientAmount);
            }
        }

        emit FeeDistributed(token, amount);
    }

    function getRecipients() external view returns (Recipient[] memory) {
        return recipients;
    }
}
