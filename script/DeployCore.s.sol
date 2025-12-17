// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {FeeCollector} from "../src/core/FeeCollector.sol";
import {InteractiveVault} from "../src/core/InteractiveVault.sol";
import {DepositFeeVault} from "../src/core/DepositFeeVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployCoreScript is Script {
    address constant USDC_BASE_SEPOLIA = 0x036CbD53842c5426634e7929541eC2318f3dCF7e;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying core fee-generating contracts...");
        console.log("Deployer:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy FeeCollector
        FeeCollector collector = new FeeCollector(deployer);
        console.log("FeeCollector deployed:", address(collector));

        // Deploy InteractiveVault
        InteractiveVault vault = new InteractiveVault(
            IERC20(USDC_BASE_SEPOLIA),
            "BaseVault Interactive USDC",
            "bvUSDC",
            address(collector)
        );
        console.log("InteractiveVault deployed:", address(vault));

        vm.stopBroadcast();

        console.log("\n=== Deployment Complete ===");
        console.log("Save these addresses:");
        console.log("FEE_COLLECTOR_ADDRESS=", address(collector));
        console.log("VAULT_ADDRESS=", address(vault));
    }
}
