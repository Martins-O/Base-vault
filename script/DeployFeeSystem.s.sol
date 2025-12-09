// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {FeeCollector} from "../src/core/FeeCollector.sol";
import {VaultFactoryWithFees} from "../src/core/VaultFactoryWithFees.sol";

contract DeployFeeSystemScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address treasury = vm.envAddress("TREASURY_ADDRESS");
        
        vm.startBroadcast(deployerPrivateKey);
        
        FeeCollector collector = new FeeCollector(treasury);
        console.log("FeeCollector deployed:", address(collector));
        
        VaultFactoryWithFees factory = new VaultFactoryWithFees(address(collector));
        console.log("VaultFactory deployed:", address(factory));
        
        vm.stopBroadcast();
    }
}
