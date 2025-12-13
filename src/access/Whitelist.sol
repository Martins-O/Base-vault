// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Whitelist
 * @notice Whitelist management for permissioned vaults
 */
contract Whitelist {
    mapping(address => mapping(address => bool)) public isWhitelisted;
    mapping(address => address[]) public whitelistMembers;
    mapping(address => bool) public managers;

    event UserWhitelisted(address indexed vault, address indexed user);
    event UserRemovedFromWhitelist(address indexed vault, address indexed user);
    event ManagerAdded(address indexed manager);

    modifier onlyManager() {
        require(managers[msg.sender], "Not a manager");
        _;
    }

    constructor() {
        managers[msg.sender] = true;
    }

    function addManager(address manager) external onlyManager {
        managers[manager] = true;
        emit ManagerAdded(manager);
    }

    function addToWhitelist(address vault, address user) external onlyManager {
        require(!isWhitelisted[vault][user], "Already whitelisted");

        isWhitelisted[vault][user] = true;
        whitelistMembers[vault].push(user);

        emit UserWhitelisted(vault, user);
    }

    function removeFromWhitelist(address vault, address user) external onlyManager {
        require(isWhitelisted[vault][user], "Not whitelisted");

        isWhitelisted[vault][user] = false;

        // Remove from members array
        address[] storage members = whitelistMembers[vault];
        for (uint256 i = 0; i < members.length; i++) {
            if (members[i] == user) {
                members[i] = members[members.length - 1];
                members.pop();
                break;
            }
        }

        emit UserRemovedFromWhitelist(vault, user);
    }

    function addBatch(address vault, address[] calldata users) external onlyManager {
        for (uint256 i = 0; i < users.length; i++) {
            if (!isWhitelisted[vault][users[i]]) {
                isWhitelisted[vault][users[i]] = true;
                whitelistMembers[vault].push(users[i]);
                emit UserWhitelisted(vault, users[i]);
            }
        }
    }

    function getWhitelistMembers(address vault)
        external
        view
        returns (address[] memory)
    {
        return whitelistMembers[vault];
    }

    function checkWhitelist(address vault, address user) external view returns (bool) {
        return isWhitelisted[vault][user];
    }
}
