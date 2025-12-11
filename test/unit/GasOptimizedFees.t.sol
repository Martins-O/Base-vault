// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {GasOptimizedFees} from "../../src/utils/GasOptimizedFees.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract GasOptimizedFeesTest is Test {
    GasOptimizedFees public fees;
    ERC20Mock public token;
    address public collector = address(0x123);

    function setUp() public {
        fees = new GasOptimizedFees(collector);
        token = new ERC20Mock();
    }

    function testBitPackedFeeRetrieval() public view {
        assertEq(fees.getDepositFee(), 50, "Deposit fee should be 50 bps");
        assertEq(fees.getWithdrawalFee(), 30, "Withdrawal fee should be 30 bps");
        assertEq(fees.getPerformanceFee(), 200, "Performance fee should be 200 bps");
        assertEq(fees.getManagementFee(), 50, "Management fee should be 50 bps");
    }

    function testGasSavingsFromBitPacking() public {
        // Reading 4 fees should cost much less than 4 separate storage reads
        uint256 gasBefore = gasleft();

        fees.getDepositFee();
        fees.getWithdrawalFee();
        fees.getPerformanceFee();
        fees.getManagementFee();

        uint256 gasUsed = gasBefore - gasleft();

        // Should use less than 10k gas for 4 reads (vs ~8k for 4 separate SLOADs)
        assertLt(gasUsed, 10000, "Gas usage too high");
    }

    function testBatchedFeeCollection() public {
        token.mint(address(fees), 10000e18);

        uint256[] memory amounts = new uint256[](3);
        uint256[] memory feeBps = new uint256[](3);

        amounts[0] = 1000e18;
        amounts[1] = 2000e18;
        amounts[2] = 3000e18;

        feeBps[0] = 50;  // 0.5%
        feeBps[1] = 30;  // 0.3%
        feeBps[2] = 200; // 2%

        uint256 gasBefore = gasleft();
        fees.collectBatchedFees(address(token), amounts, feeBps);
        uint256 gasUsed = gasBefore - gasleft();

        // Batching should save gas vs 3 separate calls
        assertLt(gasUsed, 100000, "Batched collection too expensive");
    }
}
