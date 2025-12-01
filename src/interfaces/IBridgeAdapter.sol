// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IBridgeAdapter
 * @notice Interface for cross-chain bridge adapters
 */
interface IBridgeAdapter {
    event AssetsBridged(
        uint16 indexed dstChainId,
        address indexed token,
        uint256 amount,
        address recipient
    );

    event AssetsReceived(
        uint16 indexed srcChainId,
        address indexed token,
        uint256 amount,
        address recipient
    );

    error BridgeFailed();
    error InvalidChainId();
    error InsufficientGas();

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

    function supportedChains() external view returns (uint16[] memory);
}
