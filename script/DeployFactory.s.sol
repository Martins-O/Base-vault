// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {VaultFactoryWithFees} from "../src/core/VaultFactoryWithFees.sol";

contract DeployFactoryScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address feeCollector = 0xCd5De20043a8aE46D80a22678b0Eb8B1078829Ce;

        console.log("Deploying VaultFactory...");

        vm.startBroadcast(deployerPrivateKey);

        VaultFactoryWithFees factory = new VaultFactoryWithFees(feeCollector);
        console.log("VaultFactory deployed:", address(factory));
        console.log("Creation Fee: 0.001 ETH");

        vm.stopBroadcast();
    }
}
