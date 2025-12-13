// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseVault} from "./BaseVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title TimelockedVault
 * @notice Vault with time-locked withdrawals for added security
 */
contract TimelockedVault is BaseVault {
    struct WithdrawalRequest {
        uint256 shares;
        uint256 requestTime;
        bool executed;
    }

    mapping(address => WithdrawalRequest[]) public withdrawalRequests;

    uint256 public withdrawalDelay = 24 hours;
    uint256 public maxWithdrawalDelay = 7 days;

    event WithdrawalRequested(
        address indexed user,
        uint256 indexed requestId,
        uint256 shares,
        uint256 unlockTime
    );
    event WithdrawalExecuted(address indexed user, uint256 indexed requestId, uint256 assets);
    event WithdrawalDelayUpdated(uint256 newDelay);

    constructor(
        IERC20 _asset,
        string memory _name,
        string memory _symbol
    ) BaseVault(_asset, _name, _symbol) {}

    function setWithdrawalDelay(uint256 delay) external onlyGovernance {
        require(delay <= maxWithdrawalDelay, "Delay too long");
        withdrawalDelay = delay;
        emit WithdrawalDelayUpdated(delay);
    }

    function requestWithdrawal(uint256 shares) external returns (uint256 requestId) {
        require(shares > 0, "Zero shares");
        require(balanceOf(msg.sender) >= shares, "Insufficient shares");

        requestId = withdrawalRequests[msg.sender].length;

        withdrawalRequests[msg.sender].push(
            WithdrawalRequest({
                shares: shares,
                requestTime: block.timestamp,
                executed: false
            })
        );

        emit WithdrawalRequested(
            msg.sender,
            requestId,
            shares,
            block.timestamp + withdrawalDelay
        );
    }

    function executeWithdrawal(uint256 requestId) external returns (uint256 assets) {
        WithdrawalRequest storage request = withdrawalRequests[msg.sender][requestId];

        require(!request.executed, "Already executed");
        require(
            block.timestamp >= request.requestTime + withdrawalDelay,
            "Timelock not expired"
        );

        request.executed = true;

        assets = convertToAssets(request.shares);

        _burn(msg.sender, request.shares);
        IERC20(asset()).transfer(msg.sender, assets);

        emit WithdrawalExecuted(msg.sender, requestId, assets);
    }

    function cancelWithdrawalRequest(uint256 requestId) external {
        WithdrawalRequest storage request = withdrawalRequests[msg.sender][requestId];

        require(!request.executed, "Already executed");

        request.executed = true; // Mark as executed to prevent withdrawal
        request.shares = 0;
    }

    function getWithdrawalRequests(address user)
        external
        view
        returns (WithdrawalRequest[] memory)
    {
        return withdrawalRequests[user];
    }

    function getWithdrawalUnlockTime(address user, uint256 requestId)
        external
        view
        returns (uint256)
    {
        return withdrawalRequests[user][requestId].requestTime + withdrawalDelay;
    }
}
