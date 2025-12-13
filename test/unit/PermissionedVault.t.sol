// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {PermissionedVault} from "../../src/core/PermissionedVault.sol";
import {Whitelist} from "../../src/access/Whitelist.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PermissionedVaultTest is Test {
    PermissionedVault public vault;
    Whitelist public whitelist;
    ERC20Mock public asset;

    address public whitelisted = address(0x1);
    address public notWhitelisted = address(0x2);

    function setUp() public {
        asset = new ERC20Mock();
        whitelist = new Whitelist();
        vault = new PermissionedVault(
            IERC20(address(asset)),
            "Permissioned Vault",
            "pVault",
            address(whitelist)
        );

        // Whitelist first user
        whitelist.addToWhitelist(address(vault), whitelisted);

        // Fund both users
        asset.mint(whitelisted, 10000e18);
        asset.mint(notWhitelisted, 10000e18);
    }

    function testWhitelistedUserCanDeposit() public {
        uint256 amount = 1000e18;

        vm.startPrank(whitelisted);
        asset.approve(address(vault), amount);
        vault.deposit(amount, whitelisted);
        vm.stopPrank();

        assertEq(vault.balanceOf(whitelisted), amount);
    }

    function testNonWhitelistedUserCannotDeposit() public {
        uint256 amount = 1000e18;

        vm.startPrank(notWhitelisted);
        asset.approve(address(vault), amount);

        vm.expectRevert("Not whitelisted");
        vault.deposit(amount, notWhitelisted);
        vm.stopPrank();
    }

    function testPermissionlessMode() public {
        // Enable permissionless mode
        vault.setPermissionless(true);

        // Now non-whitelisted user can deposit
        uint256 amount = 1000e18;

        vm.startPrank(notWhitelisted);
        asset.approve(address(vault), amount);
        vault.deposit(amount, notWhitelisted);
        vm.stopPrank();

        assertEq(vault.balanceOf(notWhitelisted), amount);
    }

    function testBatchWhitelist() public {
        address[] memory users = new address[](3);
        users[0] = address(0x10);
        users[1] = address(0x11);
        users[2] = address(0x12);

        whitelist.addBatch(address(vault), users);

        for (uint256 i = 0; i < users.length; i++) {
            assertTrue(whitelist.checkWhitelist(address(vault), users[i]));
        }
    }

    function testRemoveFromWhitelist() public {
        // Remove whitelisted user
        whitelist.removeFromWhitelist(address(vault), whitelisted);

        // Should not be able to deposit anymore
        vm.startPrank(whitelisted);
        asset.approve(address(vault), 1000e18);

        vm.expectRevert("Not whitelisted");
        vault.deposit(1000e18, whitelisted);
        vm.stopPrank();
    }
}
