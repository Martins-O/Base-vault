// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {FeeCollector} from "../../src/core/FeeCollector.sol";
import {InteractiveVault} from "../../src/core/InteractiveVault.sol";
import {AerodromeStrategyWithFees} from "../../src/strategies/AerodromeStrategyWithFees.sol";
import {RevenueTracker} from "../../src/utils/RevenueTracker.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FullFeeFlowTest is Test {
    FeeCollector public collector;
    InteractiveVault public vault;
    AerodromeStrategyWithFees public strategy;
    RevenueTracker public tracker;
    ERC20Mock public asset;

    address public user1 = address(0x1);
    address public user2 = address(0x2);
    address public treasury = address(0x3);

    function setUp() public {
        // Deploy contracts
        asset = new ERC20Mock();
        collector = new FeeCollector(treasury);
        vault = new InteractiveVault(
            IERC20(address(asset)),
            "Test Vault",
            "tvUSDC",
            address(collector)
        );
        strategy = new AerodromeStrategyWithFees(
            address(vault),
            address(asset),
            address(collector)
        );
        tracker = new RevenueTracker();

        // Mint tokens to users
        asset.mint(user1, 10000e18);
        asset.mint(user2, 5000e18);
    }

    function testFullDepositWithdrawFeeFlow() public {
        uint256 depositAmount = 1000e18;
        uint256 expectedDepositFee = (depositAmount * 50) / 10000; // 0.5%

        // User1 deposits
        vm.startPrank(user1);
        asset.approve(address(vault), depositAmount);
        vault.deposit(depositAmount, user1);
        vm.stopPrank();

        // Check deposit fee collected
        uint256 collectedFees = collector.collectedFees(address(asset));
        assertEq(collectedFees, expectedDepositFee, "Deposit fee not collected");

        // Track revenue
        tracker.recordFee(address(vault), "deposit", expectedDepositFee);
        assertEq(tracker.getTotalRevenue(address(vault)), expectedDepositFee);

        // User1 withdraws half
        uint256 withdrawAmount = 500e18;
        uint256 expectedWithdrawalFee = (withdrawAmount * 30) / 10000; // 0.3%

        vm.startPrank(user1);
        vault.withdraw(withdrawAmount, user1, user1);
        vm.stopPrank();

        // Check total fees
        uint256 totalFees = expectedDepositFee + expectedWithdrawalFee;
        assertEq(collector.collectedFees(address(asset)), totalFees, "Total fees mismatch");
    }

    function testMultipleUsersGenerateFees() public {
        // User1 deposits
        vm.startPrank(user1);
        asset.approve(address(vault), 1000e18);
        vault.deposit(1000e18, user1);
        vm.stopPrank();

        // User2 deposits
        vm.startPrank(user2);
        asset.approve(address(vault), 500e18);
        vault.deposit(500e18, user2);
        vm.stopPrank();

        // Expected fees: (1000 * 0.5%) + (500 * 0.5%) = 5 + 2.5 = 7.5
        uint256 expectedFees = (1000e18 * 50) / 10000 + (500e18 * 50) / 10000;
        assertEq(collector.collectedFees(address(asset)), expectedFees);

        // Check user tracking
        assertEq(vault.totalUsers(), 2, "Should track 2 users");
    }

    function testStrategyHarvestGeneratesFees() public {
        // Deposit to vault
        vm.startPrank(user1);
        asset.approve(address(vault), 1000e18);
        vault.deposit(1000e18, user1);
        vm.stopPrank();

        // Allocate to strategy
        asset.mint(address(strategy), 1000e18);

        // Harvest strategy
        (uint256 profit,) = strategy.harvest();

        // Check performance fee (10% of profit)
        uint256 expectedFee = (profit * 1000) / 10000;
        assertGt(expectedFee, 0, "Should generate harvest fees");
    }
}
