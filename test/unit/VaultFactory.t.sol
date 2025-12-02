// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {VaultFactory} from "../../src/core/VaultFactory.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract VaultFactoryTest is Test {
    VaultFactory public factory;
    ERC20Mock public asset;

    function setUp() public {
        factory = new VaultFactory();
        asset = new ERC20Mock();
    }

    function testCreateVault() public {
        address vault = factory.createVault(
            address(asset),
            "Test Vault",
            "tvUSDC"
        );
        assertTrue(factory.isVault(vault));
        assertEq(factory.vaultCount(), 1);
    }
}
