// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC4626} from "@openzeppelin/contracts/interfaces/IERC4626.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title BatchOperations
 * @notice Batch multiple vault operations for gas efficiency
 */
contract BatchOperations {
    using SafeERC20 for IERC20;

    struct DepositOp {
        address vault;
        uint256 assets;
        address receiver;
    }

    struct WithdrawOp {
        address vault;
        uint256 assets;
        address receiver;
        address owner;
    }

    event BatchDeposit(address indexed user, uint256 totalAssets, uint256 vaultCount);
    event BatchWithdraw(address indexed user, uint256 totalAssets, uint256 vaultCount);

    function batchDeposit(DepositOp[] calldata ops) external returns (uint256[] memory shares) {
        shares = new uint256[](ops.length);
        uint256 totalAssets;

        for (uint256 i = 0; i < ops.length; i++) {
            IERC4626 vault = IERC4626(ops[i].vault);
            address asset = vault.asset();

            IERC20(asset).safeTransferFrom(msg.sender, address(this), ops[i].assets);
            IERC20(asset).approve(ops[i].vault, ops[i].assets);

            shares[i] = vault.deposit(ops[i].assets, ops[i].receiver);
            totalAssets += ops[i].assets;
        }

        emit BatchDeposit(msg.sender, totalAssets, ops.length);
    }

    function batchWithdraw(WithdrawOp[] calldata ops) external returns (uint256[] memory assets) {
        assets = new uint256[](ops.length);
        uint256 totalAssets;

        for (uint256 i = 0; i < ops.length; i++) {
            IERC4626 vault = IERC4626(ops[i].vault);

            uint256 withdrawn = vault.withdraw(
                ops[i].assets,
                ops[i].receiver,
                ops[i].owner
            );

            assets[i] = withdrawn;
            totalAssets += withdrawn;
        }

        emit BatchWithdraw(msg.sender, totalAssets, ops.length);
    }

    function batchClaim(address[] calldata vaults) external {
        for (uint256 i = 0; i < vaults.length; i++) {
            // Claim rewards from each vault
            // Implementation depends on vault reward system
        }
    }
}
