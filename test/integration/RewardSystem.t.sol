// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {RewardDistributor} from "../../src/rewards/RewardDistributor.sol";
import {BaseVault} from "../../src/core/BaseVault.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RewardSystemTest is Test {
    RewardDistributor public distributor;
    BaseVault public vault;
    ERC20Mock public asset;
    ERC20Mock public rewardToken;

    address public user1 = address(0x1);
    address public user2 = address(0x2);
    address public rewardSource = address(0x3);

    function setUp() public {
        asset = new ERC20Mock();
        rewardToken = new ERC20Mock();

        vault = new BaseVault(
            IERC20(address(asset)),
            "Test Vault",
            "tvUSDC"
        );

        distributor = new RewardDistributor(address(vault), address(rewardToken));

        // Fund users
        asset.mint(user1, 10000e18);
        asset.mint(user2, 5000e18);

        // Fund reward source
        rewardToken.mint(rewardSource, 100000e18);
    }

    function testAddAndDistributeRewards() public {
        // Users deposit
        vm.startPrank(user1);
        asset.approve(address(vault), 1000e18);
        vault.deposit(1000e18, user1);
        vm.stopPrank();

        vm.startPrank(user2);
        asset.approve(address(vault), 500e18);
        vault.deposit(500e18, user2);
        vm.stopPrank();

        // Add rewards to distributor
        uint256 rewardAmount = 1500e18;

        vm.startPrank(rewardSource);
        rewardToken.approve(address(distributor), rewardAmount);
        distributor.addRewards(rewardAmount);
        vm.stopPrank();

        // Finalize epoch
        uint256 totalShares = vault.totalSupply();
        vm.prank(address(vault));
        distributor.finalizeEpoch(totalShares);

        // User1 claims rewards (should get 2/3 of rewards)
        uint256 user1Shares = vault.balanceOf(user1);
        vm.prank(user1);
        uint256 user1Reward = distributor.claimRewards(0, user1Shares);

        assertGt(user1Reward, 0, "User1 should receive rewards");
        assertEq(rewardToken.balanceOf(user1), user1Reward);
    }

    function testCannotClaimTwice() public {
        // Setup and first claim
        vm.startPrank(user1);
        asset.approve(address(vault), 1000e18);
        vault.deposit(1000e18, user1);
        vm.stopPrank();

        vm.startPrank(rewardSource);
        rewardToken.approve(address(distributor), 1000e18);
        distributor.addRewards(1000e18);
        vm.stopPrank();

        vm.prank(address(vault));
        distributor.finalizeEpoch(vault.totalSupply());

        uint256 user1Shares = vault.balanceOf(user1);
        vm.prank(user1);
        distributor.claimRewards(0, user1Shares);

        // Try to claim again
        vm.prank(user1);
        vm.expectRevert("Already claimed");
        distributor.claimRewards(0, user1Shares);
    }
}
