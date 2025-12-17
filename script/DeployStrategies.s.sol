// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {AerodromeStrategyWithFees} from "../src/strategies/AerodromeStrategyWithFees.sol";
import {UniswapV3StrategyWithFees} from "../src/strategies/UniswapV3StrategyWithFees.sol";

contract DeployStrategiesScript is Script {
    address constant USDC_BASE_SEPOLIA = 0x036CbD53842c5426634e7929541eC2318f3dCF7e;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        address feeCollector = 0xCd5De20043a8aE46D80a22678b0Eb8B1078829Ce;
        address vault = 0x24ed030F7F62E05Eb5842bF5197c87a82397BDAC;

        console.log("Deploying Strategies...");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy Aerodrome Strategy
        AerodromeStrategyWithFees aeroStrategy = new AerodromeStrategyWithFees(
            vault,
            USDC_BASE_SEPOLIA,
            feeCollector
        );
        console.log("AerodromeStrategy deployed:", address(aeroStrategy));
        console.log("  Performance Fee: 10%");

        // Deploy Uniswap V3 Strategy
        UniswapV3StrategyWithFees uniStrategy = new UniswapV3StrategyWithFees(
            vault,
            USDC_BASE_SEPOLIA,
            feeCollector
        );
        console.log("UniswapV3Strategy deployed:", address(uniStrategy));
        console.log("  Performance Fee: 8%");

        vm.stopBroadcast();
    }
}
