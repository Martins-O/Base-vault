// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {BaseVault} from "../../src/core/BaseVault.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract BaseVaultTest is Test {
    BaseVault public vault;
    ERC20Mock public asset;
    address public user = address(0x1);

    function setUp() public {
        asset = new ERC20Mock();
        vault = new BaseVault(asset, "Test Vault", "tvUSDC");
    }

    function testDeposit() public {
        // Test will be implemented
    }
}
