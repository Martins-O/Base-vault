// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {InteractiveVault} from "../src/core/InteractiveVault.sol";
import {FeeCollector} from "../src/core/FeeCollector.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployInteractiveScript is Script {
    address constant USDC_BASE_SEPOLIA = 0x036CbD53842c5426634e7929541eC2318f3dCF7e;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy FeeCollector
        FeeCollector collector = new FeeCollector(msg.sender);
        console.log("FeeCollector:", address(collector));
        
        // Deploy InteractiveVault
        InteractiveVault vault = new InteractiveVault(
            IERC20(USDC_BASE_SEPOLIA),
            "Interactive BaseVault USDC",
            "ibvUSDC",
            address(collector)
        );
        console.log("InteractiveVault:", address(vault));
        
        vm.stopBroadcast();
    }
}
