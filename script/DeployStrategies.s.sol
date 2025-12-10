// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {AerodromeStrategyWithFees} from "../src/strategies/AerodromeStrategyWithFees.sol";
import {UniswapV3StrategyWithFees} from "../src/strategies/UniswapV3StrategyWithFees.sol";

contract DeployStrategiesScript is Script {
    address constant USDC_BASE_SEPOLIA = 0x036CbD53842c5426634e7929541eC2318f3dCF7e;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address vault = vm.envAddress("VAULT_ADDRESS");
        address feeCollector = vm.envAddress("FEE_COLLECTOR_ADDRESS");
        
        vm.startBroadcast(deployerPrivateKey);
        
        AerodromeStrategyWithFees aero = new AerodromeStrategyWithFees(
            vault,
            USDC_BASE_SEPOLIA,
            feeCollector
        );
        console.log("Aerodrome Strategy:", address(aero));
        
        UniswapV3StrategyWithFees uni = new UniswapV3StrategyWithFees(
            vault,
            USDC_BASE_SEPOLIA,
            feeCollector
        );
        console.log("Uniswap V3 Strategy:", address(uni));
        
        vm.stopBroadcast();
    }
}
