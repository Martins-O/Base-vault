// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {VaultFactoryWithFees} from "../src/core/VaultFactoryWithFees.sol";

contract GenerateFeesScript is Script {
    address constant USDC = 0x036CbD53842c5426634e7929541eC2318f3dCF7e;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        console.log("=== GENERATING FEES FOR LEADERBOARD ===");

        vm.startBroadcast(deployerPrivateKey);

        VaultFactoryWithFees factory = VaultFactoryWithFees(0xd4b5C23ACB221AC6F8671EC3d45141E346ee80d8);

        // Create 10 vaults = 0.01 ETH in fees
        console.log("Creating vaults...");

        address vault1 = factory.createVault{value: 0.001 ether}(USDC, "BV1", "BV1");
        console.log("Vault 1:", vault1);

        address vault2 = factory.createVault{value: 0.001 ether}(USDC, "BV2", "BV2");
        console.log("Vault 2:", vault2);

        address vault3 = factory.createVault{value: 0.001 ether}(USDC, "BV3", "BV3");
        console.log("Vault 3:", vault3);

        address vault4 = factory.createVault{value: 0.001 ether}(USDC, "BV4", "BV4");
        console.log("Vault 4:", vault4);

        address vault5 = factory.createVault{value: 0.001 ether}(USDC, "BV5", "BV5");
        console.log("Vault 5:", vault5);

        address vault6 = factory.createVault{value: 0.001 ether}(USDC, "BV6", "BV6");
        console.log("Vault 6:", vault6);

        address vault7 = factory.createVault{value: 0.001 ether}(USDC, "BV7", "BV7");
        console.log("Vault 7:", vault7);

        address vault8 = factory.createVault{value: 0.001 ether}(USDC, "BV8", "BV8");
        console.log("Vault 8:", vault8);

        address vault9 = factory.createVault{value: 0.001 ether}(USDC, "BV9", "BV9");
        console.log("Vault 9:", vault9);

        address vault10 = factory.createVault{value: 0.001 ether}(USDC, "BV10", "BV10");
        console.log("Vault 10:", vault10);

        vm.stopBroadcast();

        console.log("\n=== FEES GENERATED ===");
        console.log("Creation Fees: 0.01 ETH");
        console.log("Transactions: 10");
        console.log("FeeCollector: 0xCd5De20043a8aE46D80a22678b0Eb8B1078829Ce");
    }
}
