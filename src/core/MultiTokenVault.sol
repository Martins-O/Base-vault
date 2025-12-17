// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseVault} from "./BaseVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title MultiTokenVault
 * @notice Vault that accepts multiple asset types and charges fees
 */
contract MultiTokenVault is BaseVault {
    using SafeERC20 for IERC20;

    mapping(address => bool) public supportedAssets;
    address[] public assetList;

    // Asset-specific fee overrides
    mapping(address => uint256) public assetDepositFee;
    mapping(address => uint256) public assetWithdrawalFee;

    uint256 public defaultDepositFee = 50; // 0.5%
    uint256 public defaultWithdrawalFee = 30; // 0.3%

    event AssetAdded(address indexed asset, uint256 depositFee, uint256 withdrawalFee);
    event AssetRemoved(address indexed asset);

    constructor(
        IERC20 _primaryAsset,
        string memory _name,
        string memory _symbol
    ) BaseVault(_primaryAsset, _name, _symbol) {}

    function addSupportedAsset(
        address asset,
        uint256 depositFee,
        uint256 withdrawalFee
    ) external onlyGovernance {
        require(asset != address(0), "Invalid asset");
        require(!supportedAssets[asset], "Already supported");

        supportedAssets[asset] = true;
        assetList.push(asset);
        assetDepositFee[asset] = depositFee;
        assetWithdrawalFee[asset] = withdrawalFee;

        emit AssetAdded(asset, depositFee, withdrawalFee);
    }

    function removeSupportedAsset(address asset) external onlyGovernance {
        require(supportedAssets[asset], "Not supported");

        supportedAssets[asset] = false;

        // Remove from list
        for (uint256 i = 0; i < assetList.length; i++) {
            if (assetList[i] == asset) {
                assetList[i] = assetList[assetList.length - 1];
                assetList.pop();
                break;
            }
        }

        emit AssetRemoved(asset);
    }

    function depositAlternateAsset(
        address asset,
        uint256 amount,
        address receiver
    ) external returns (uint256 shares) {
        require(supportedAssets[asset], "Asset not supported");
        require(amount > 0, "Zero amount");

        uint256 fee = (amount * getAssetDepositFee(asset)) / MAX_BPS;
        uint256 netAmount = amount - fee;

        IERC20(asset).safeTransferFrom(msg.sender, address(this), amount);

        // Fee stays in vault (can be collected separately)
        // if (fee > 0) {
        //     IERC20(asset).safeTransfer(feeCollector, fee);
        // }

        // Convert to primary asset equivalent for share calculation
        shares = netAmount; // Simplified - in production use oracle
        _mint(receiver, shares);

        return shares;
    }

    function getAssetDepositFee(address asset) public view returns (uint256) {
        if (assetDepositFee[asset] > 0) {
            return assetDepositFee[asset];
        }
        return defaultDepositFee;
    }

    function getAssetWithdrawalFee(address asset) public view returns (uint256) {
        if (assetWithdrawalFee[asset] > 0) {
            return assetWithdrawalFee[asset];
        }
        return defaultWithdrawalFee;
    }

    function getSupportedAssets() external view returns (address[] memory) {
        return assetList;
    }
}
