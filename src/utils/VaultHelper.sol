// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC4626} from "@openzeppelin/contracts/interfaces/IERC4626.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title VaultHelper
 * @notice Helper contract for frontend integrations
 */
contract VaultHelper {
    struct VaultInfo {
        address vault;
        address asset;
        string name;
        string symbol;
        uint256 totalAssets;
        uint256 totalSupply;
        uint256 pricePerShare;
        uint256 apy;
    }

    struct UserPosition {
        uint256 shares;
        uint256 assets;
        uint256 depositedValue;
        uint256 currentValue;
        int256 profitLoss;
        uint256 profitLossPercent;
    }

    function getVaultInfo(address vaultAddress)
        external
        view
        returns (VaultInfo memory info)
    {
        IERC4626 vault = IERC4626(vaultAddress);

        info.vault = vaultAddress;
        info.asset = vault.asset();
        info.totalAssets = vault.totalAssets();
        info.totalSupply = vault.totalSupply();

        if (info.totalSupply > 0) {
            info.pricePerShare = (info.totalAssets * 1e18) / info.totalSupply;
        }

        // Get metadata
        try IERC20(vaultAddress).name() returns (string memory n) {
            info.name = n;
        } catch {}

        try IERC20(vaultAddress).symbol() returns (string memory s) {
            info.symbol = s;
        } catch {}
    }

    function getUserPosition(address vaultAddress, address user)
        external
        view
        returns (UserPosition memory position)
    {
        IERC4626 vault = IERC4626(vaultAddress);

        position.shares = vault.balanceOf(user);
        position.assets = vault.convertToAssets(position.shares);
        position.currentValue = position.assets;

        // P&L calculation would require historical deposit tracking
        // Placeholder for now
        position.depositedValue = position.assets;
        position.profitLoss = 0;
        position.profitLossPercent = 0;
    }

    function getMultipleVaultInfos(address[] calldata vaults)
        external
        view
        returns (VaultInfo[] memory infos)
    {
        infos = new VaultInfo[](vaults.length);

        for (uint256 i = 0; i < vaults.length; i++) {
            infos[i] = this.getVaultInfo(vaults[i]);
        }
    }

    function previewDepositWithFees(
        address vaultAddress,
        uint256 assets,
        uint256 depositFeeBps
    ) external view returns (uint256 sharesAfterFee, uint256 fee) {
        IERC4626 vault = IERC4626(vaultAddress);

        fee = (assets * depositFeeBps) / 10_000;
        uint256 netAssets = assets - fee;

        sharesAfterFee = vault.convertToShares(netAssets);
    }

    function previewWithdrawWithFees(
        address vaultAddress,
        uint256 assets,
        uint256 withdrawFeeBps
    ) external view returns (uint256 assetsAfterFee, uint256 fee) {
        fee = (assets * withdrawFeeBps) / 10_000;
        assetsAfterFee = assets - fee;
    }
}
