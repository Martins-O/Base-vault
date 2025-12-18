// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {BaseVault} from "../src/core/BaseVault.sol";
import {DepositFeeVault} from "../src/core/DepositFeeVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MaximizeTransactionsScript is Script {
    address constant USDC = 0x036CbD53842c5426634e7929541eC2318f3dCF7e;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        console.log("=== MAXIMIZING ON-CHAIN ACTIVITY ===");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy 15 vaults directly = 15 transactions + contract deployments
        console.log("Deploying vaults...");

        BaseVault v1 = new BaseVault(IERC20(USDC), "BaseVault 1", "BV1");
        console.log("Vault 1:", address(v1));

        BaseVault v2 = new BaseVault(IERC20(USDC), "BaseVault 2", "BV2");
        console.log("Vault 2:", address(v2));

        BaseVault v3 = new BaseVault(IERC20(USDC), "BaseVault 3", "BV3");
        console.log("Vault 3:", address(v3));

        BaseVault v4 = new BaseVault(IERC20(USDC), "BaseVault 4", "BV4");
        console.log("Vault 4:", address(v4));

        BaseVault v5 = new BaseVault(IERC20(USDC), "BaseVault 5", "BV5");
        console.log("Vault 5:", address(v5));

        BaseVault v6 = new BaseVault(IERC20(USDC), "BaseVault 6", "BV6");
        console.log("Vault 6:", address(v6));

        BaseVault v7 = new BaseVault(IERC20(USDC), "BaseVault 7", "BV7");
        console.log("Vault 7:", address(v7));

        BaseVault v8 = new BaseVault(IERC20(USDC), "BaseVault 8", "BV8");
        console.log("Vault 8:", address(v8));

        BaseVault v9 = new BaseVault(IERC20(USDC), "BaseVault 9", "BV9");
        console.log("Vault 9:", address(v9));

        BaseVault v10 = new BaseVault(IERC20(USDC), "BaseVault 10", "BV10");
        console.log("Vault 10:", address(v10));

        BaseVault v11 = new BaseVault(IERC20(USDC), "BaseVault 11", "BV11");
        console.log("Vault 11:", address(v11));

        BaseVault v12 = new BaseVault(IERC20(USDC), "BaseVault 12", "BV12");
        console.log("Vault 12:", address(v12));

        BaseVault v13 = new BaseVault(IERC20(USDC), "BaseVault 13", "BV13");
        console.log("Vault 13:", address(v13));

        BaseVault v14 = new BaseVault(IERC20(USDC), "BaseVault 14", "BV14");
        console.log("Vault 14:", address(v14));

        BaseVault v15 = new BaseVault(IERC20(USDC), "BaseVault 15", "BV15");
        console.log("Vault 15:", address(v15));

        vm.stopBroadcast();

        console.log("\n=== ACTIVITY GENERATED ===");
        console.log("Total vaults deployed: 15");
        console.log("Total transactions: 15");
        console.log("All vaults are live on Base Sepolia!");
    }
}
