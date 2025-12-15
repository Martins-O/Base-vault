// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CrossChainMessenger
 * @notice Cross-chain messaging for multi-chain vaults
 */
contract CrossChainMessenger {
    event MessageSent(uint256 indexed destChain, bytes message);
    event MessageReceived(uint256 indexed srcChain, bytes message);

    function sendMessage(
        uint256 destChainId,
        address target,
        bytes calldata data
    ) external payable {
        emit MessageSent(destChainId, data);
    }

    function receiveMessage(
        uint256 srcChainId,
        address sender,
        bytes calldata data
    ) external {
        emit MessageReceived(srcChainId, data);
    }
}
