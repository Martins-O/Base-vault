// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";

/**
 * @title DeployProductionScript
 * @notice Production deployment with all contracts
 */
contract DeployProductionScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        console.log("Starting production deployment...");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy all contracts here

        vm.stopBroadcast();

        console.log("Production deployment complete!");
    }
}
