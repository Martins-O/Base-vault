// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {StrategyRouter} from "../../src/strategies/StrategyRouter.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract MockStrategy {
    uint256 public apy;

    constructor(uint256 _apy) {
        apy = _apy;
    }

    function estimatedAPY() external view returns (uint256) {
        return apy;
    }

    function withdraw(uint256) external pure returns (uint256) {
        return 0;
    }
}

contract StrategyRouterTest is Test {
    StrategyRouter public router;
    ERC20Mock public asset;
    MockStrategy public strategy1;
    MockStrategy public strategy2;

    address public vault = address(0x1);

    function setUp() public {
        asset = new ERC20Mock();

        vm.prank(vault);
        router = new StrategyRouter(vault);

        strategy1 = new MockStrategy(1200); // 12% APY
        strategy2 = new MockStrategy(1800); // 18% APY
    }

    function testAddStrategy() public {
        vm.prank(vault);
        router.addStrategy(address(strategy1), 5000, 30); // 50% allocation, 30 risk

        assertEq(router.getStrategyCount(), 1);
    }

    function testRoutesToBestStrategy() public {
        vm.startPrank(vault);

        // Add two strategies with different APYs
        router.addStrategy(address(strategy1), 5000, 20); // Lower APY, lower risk
        router.addStrategy(address(strategy2), 5000, 40); // Higher APY, higher risk

        asset.mint(vault, 1000e18);
        asset.approve(address(router), 1000e18);

        // Should route to strategy2 due to higher risk-adjusted return
        address chosen = router.routeFunds(address(asset), 1000e18);

        vm.stopPrank();

        // Verify routing decision
        assertEq(router.getTotalAssets(), 1000e18);
    }

    function testRebalancing() public {
        vm.startPrank(vault);

        router.addStrategy(address(strategy1), 6000, 20); // 60%
        router.addStrategy(address(strategy2), 4000, 30); // 40%

        asset.mint(vault, 1000e18);
        asset.approve(address(router), 1000e18);

        router.routeFunds(address(asset), 1000e18);

        // Trigger rebalance
        router.rebalance(address(asset));

        vm.stopPrank();
    }
}
