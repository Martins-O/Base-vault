// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {EmergencyVault} from "../../src/core/EmergencyVault.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EmergencyModeTest is Test {
    EmergencyVault public vault;
    ERC20Mock public asset;

    address public guardian = address(0x1);
    address public user1 = address(0x2);
    address public user2 = address(0x3);

    function setUp() public {
        asset = new ERC20Mock();
        vault = new EmergencyVault(
            IERC20(address(asset)),
            "Emergency Test Vault",
            "etvUSDC"
        );

        vault.addGuardian(guardian);

        // Fund users
        asset.mint(user1, 10000e18);
        asset.mint(user2, 10000e18);
    }

    function testNormalOperationsWhenNotEmergency() public {
        uint256 depositAmount = 1000e18;

        vm.startPrank(user1);
        asset.approve(address(vault), depositAmount);
        vault.deposit(depositAmount, user1);
        vm.stopPrank();

        assertEq(vault.balanceOf(user1), depositAmount);
    }

    function testCannotDepositDuringEmergency() public {
        // Activate emergency
        vm.prank(guardian);
        vault.activateEmergency("Test emergency");

        // Try to deposit
        vm.startPrank(user1);
        asset.approve(address(vault), 1000e18);

        vm.expectRevert("Emergency mode active");
        vault.deposit(1000e18, user1);
        vm.stopPrank();
    }

    function testEmergencyWithdrawal() public {
        // Users deposit first
        vm.startPrank(user1);
        asset.approve(address(vault), 1000e18);
        vault.deposit(1000e18, user1);
        vm.stopPrank();

        vm.startPrank(user2);
        asset.approve(address(vault), 500e18);
        vault.deposit(500e18, user2);
        vm.stopPrank();

        // Guardian activates emergency
        vm.prank(guardian);
        vault.activateEmergency("Protocol exploit detected");

        // Users can emergency withdraw
        uint256 user1BalanceBefore = asset.balanceOf(user1);
        vm.prank(user1);
        vault.emergencyWithdraw();

        assertGt(asset.balanceOf(user1), user1BalanceBefore);
        assertEq(vault.balanceOf(user1), 0);
    }

    function testEmergencyWindowExpiration() public {
        // Deposit
        vm.startPrank(user1);
        asset.approve(address(vault), 1000e18);
        vault.deposit(1000e18, user1);
        vm.stopPrank();

        // Activate emergency
        vm.prank(guardian);
        vault.activateEmergency("Test");

        // Fast forward past window (7 days)
        vm.warp(block.timestamp + 8 days);

        // Should fail
        vm.prank(user1);
        vm.expectRevert("Emergency window closed");
        vault.emergencyWithdraw();
    }

    function testOnlyGuardianCanActivate() public {
        vm.prank(user1);
        vm.expectRevert("Not a guardian");
        vault.activateEmergency("Unauthorized attempt");
    }
}
