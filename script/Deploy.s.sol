// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {BaseVault} from "../src/core/BaseVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployScript is Script {
    // Base Sepolia USDC: 0x036CbD53842c5426634e7929541eC2318f3dCF7e
    address constant USDC_BASE_SEPOLIA = 0x036CbD53842c5426634e7929541eC2318f3dCF7e;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy BaseVault for USDC
        BaseVault vault = new BaseVault(
            IERC20(USDC_BASE_SEPOLIA),
            "BaseVault USDC",
            "bvUSDC"
        );

        console.log("BaseVault deployed at:", address(vault));
        console.log("Governance:", vault.governance());

        vm.stopBroadcast();
    }
}
