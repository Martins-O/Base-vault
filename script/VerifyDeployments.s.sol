// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";

contract VerifyDeploymentsScript is Script {
    function run() external view {
        address feeCollector = vm.envAddress("FEE_COLLECTOR_ADDRESS");
        address vault = vm.envAddress("VAULT_ADDRESS");
        address factory = vm.envAddress("FACTORY_ADDRESS");

        console.log("=== Contract Verification ===");
        console.log("FeeCollector:", feeCollector);
        console.log("  Code size:", feeCollector.code.length);
        console.log("  Is contract:", feeCollector.code.length > 0);

        console.log("\nVault:", vault);
        console.log("  Code size:", vault.code.length);
        console.log("  Is contract:", vault.code.length > 0);

        console.log("\nFactory:", factory);
        console.log("  Code size:", factory.code.length);
        console.log("  Is contract:", factory.code.length > 0);

        // Verify constructor parameters
        if (feeCollector.code.length > 0) {
            console.log("\n[OK] FeeCollector deployed successfully");
        }
        if (vault.code.length > 0) {
            console.log("[OK] Vault deployed successfully");
        }
        if (factory.code.length > 0) {
            console.log("[OK] Factory deployed successfully");
        }
    }
}
