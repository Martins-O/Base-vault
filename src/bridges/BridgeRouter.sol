// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IBridgeAdapter} from "./IBridgeAdapter.sol";

contract BridgeRouter {
    mapping(uint16 => address) public adapters;

    event AdapterSet(uint16 indexed chainId, address adapter);

    function setAdapter(uint16 chainId, address adapter) external {
        adapters[chainId] = adapter;
        emit AdapterSet(chainId, adapter);
    }

    function bridge(
        uint16 dstChainId,
        address token,
        uint256 amount,
        address recipient
    ) external payable {
        address adapter = adapters[dstChainId];
        require(adapter != address(0), "No adapter for chain");

        IBridgeAdapter(adapter).bridgeAssets{value: msg.value}(
            dstChainId,
            token,
            amount,
            recipient
        );
    }
}
