// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {BatchOperations} from "../../src/utils/BatchOperations.sol";
import {BaseVault} from "../../src/core/BaseVault.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BatchOperationsTest is Test {
    BatchOperations public batchOps;
    BaseVault public vault1;
    BaseVault public vault2;
    ERC20Mock public asset;

    address public user = address(0x1);

    function setUp() public {
        asset = new ERC20Mock();
        batchOps = new BatchOperations();

        vault1 = new BaseVault(IERC20(address(asset)), "Vault 1", "v1");
        vault2 = new BaseVault(IERC20(address(asset)), "Vault 2", "v2");

        asset.mint(user, 10000e18);
    }

    function testBatchDeposit() public {
        BatchOperations.DepositOp[] memory ops = new BatchOperations.DepositOp[](2);

        ops[0] = BatchOperations.DepositOp({
            vault: address(vault1),
            assets: 1000e18,
            receiver: user
        });

        ops[1] = BatchOperations.DepositOp({
            vault: address(vault2),
            assets: 500e18,
            receiver: user
        });

        vm.startPrank(user);
        asset.approve(address(batchOps), 1500e18);
        uint256[] memory shares = batchOps.batchDeposit(ops);
        vm.stopPrank();

        assertEq(shares.length, 2);
        assertGt(shares[0], 0);
        assertGt(shares[1], 0);
    }
}
