// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {FeeCollector} from "../../src/core/FeeCollector.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract FeeCollectorTest is Test {
    FeeCollector public collector;
    ERC20Mock public token;
    address public treasury = address(0x123);

    function setUp() public {
        token = new ERC20Mock();
        collector = new FeeCollector(treasury);
        token.mint(address(this), 1000e18);
    }

    function testCollectFee() public {
        token.approve(address(collector), 100e18);
        collector.collectFee(address(token), 100e18);
        assertEq(collector.collectedFees(address(token)), 100e18);
    }
}
