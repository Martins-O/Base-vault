// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract FeeDistributor {
    using SafeERC20 for IERC20;
    
    struct Recipient {
        address addr;
        uint256 share; // In basis points
    }
    
    Recipient[] public recipients;
    uint256 public totalShares;
    
    event FeeDistributed(address indexed token, uint256 totalAmount);
    event RecipientAdded(address indexed recipient, uint256 share);
    
    function addRecipient(address recipient, uint256 share) external {
        recipients.push(Recipient(recipient, share));
        totalShares += share;
        emit RecipientAdded(recipient, share);
    }
    
    function distributeFees(address token, uint256 amount) external {
        require(totalShares > 0, "No recipients");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            uint256 recipientAmount = (amount * recipients[i].share) / totalShares;
            IERC20(token).safeTransfer(recipients[i].addr, recipientAmount);
        }
        
        emit FeeDistributed(token, amount);
    }
}
