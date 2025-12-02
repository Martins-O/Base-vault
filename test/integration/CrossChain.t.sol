// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {BridgeRouter} from "../../src/bridges/BridgeRouter.sol";
import {LayerZeroAdapter} from "../../src/bridges/LayerZeroAdapter.sol";

contract CrossChainTest is Test {
    BridgeRouter public router;
    LayerZeroAdapter public adapter;

    function setUp() public {
        adapter = new LayerZeroAdapter(address(0x1));
        router = new BridgeRouter();
        router.setAdapter(1, address(adapter));
    }

    function testBridge() public {
        // Placeholder test
        assertTrue(true);
    }
}
