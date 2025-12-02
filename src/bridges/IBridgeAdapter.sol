// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Moved from interfaces/IBridgeAdapter.sol for better organization
interface IBridgeAdapter {
    event AssetsBridged(
        uint16 indexed dstChainId,
        address indexed token,
        uint256 amount,
        address recipient
    );

    function bridgeAssets(
        uint16 dstChainId,
        address token,
        uint256 amount,
        address recipient
    ) external payable;

    function estimateBridgeFee(
        uint16 dstChainId,
        address token,
        uint256 amount
    ) external view returns (uint256 fee);
}
