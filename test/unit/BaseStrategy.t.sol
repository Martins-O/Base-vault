// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {MockStrategy} from "../mocks/MockStrategy.sol";
import {MockERC20} from "../mocks/MockERC20.sol";

contract BaseStrategyTest is Test {
    MockStrategy public strategy;
    MockERC20 public asset;
    address public vault = address(0x123);

    function setUp() public {
        asset = new MockERC20();
        strategy = new MockStrategy(vault, address(asset));
    }

    function testEstimatedTotalAssets() public {
        assertEq(strategy.estimatedTotalAssets(), 1000e18);
    }

    function testEstimatedAPY() public {
        assertEq(strategy.estimatedAPY(), 1000); // 10%
    }
}
