// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DepositFeeVault} from "../../src/core/DepositFeeVault.sol";
import {FeeCollector} from "../../src/core/FeeCollector.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract FeeGenerationTest is Test {
    DepositFeeVault public vault;
    FeeCollector public collector;
    ERC20Mock public asset;
    
    address public user = address(0x1);
    address public treasury = address(0x2);
    
    function setUp() public {
        asset = new ERC20Mock();
        collector = new FeeCollector(treasury);
        vault = new DepositFeeVault(asset, "Fee Vault", "fvUSDC", address(collector));
        
        asset.mint(user, 10000e18);
    }
    
    function testDepositGeneratesFees() public {
        vm.startPrank(user);
        
        uint256 depositAmount = 1000e18;
        uint256 expectedFee = (depositAmount * 50) / 10000; // 0.5%
        
        asset.approve(address(vault), depositAmount);
        vault.deposit(depositAmount, user);
        
        assertEq(collector.collectedFees(address(asset)), expectedFee);
        
        vm.stopPrank();
    }
}
