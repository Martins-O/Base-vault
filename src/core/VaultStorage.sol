// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VaultStorage {
    struct VaultInfo {
        address asset;
        uint256 totalDeposits;
        uint256 totalWithdrawals;
        uint256 lastHarvest;
    }

    mapping(address => VaultInfo) public vaults;
}
