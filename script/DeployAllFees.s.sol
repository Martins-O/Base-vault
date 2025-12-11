// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {FeeCollector} from "../src/core/FeeCollector.sol";
import {InteractiveVault} from "../src/core/InteractiveVault.sol";
import {VaultFactoryWithFees} from "../src/core/VaultFactoryWithFees.sol";
import {AerodromeStrategyWithFees} from "../src/strategies/AerodromeStrategyWithFees.sol";
import {UniswapV3StrategyWithFees} from "../src/strategies/UniswapV3StrategyWithFees.sol";
import {FeeDistributor} from "../src/utils/FeeDistributor.sol";
import {RevenueTracker} from "../src/utils/RevenueTracker.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployAllFeesScript is Script {
    address constant USDC_BASE_SEPOLIA = 0x036CbD53842c5426634e7929541eC2318f3dCF7e;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        console.log("Deploying all fee-generating contracts...");
        console.log("Deployer:", deployer);

        // 1. Deploy FeeCollector
        FeeCollector collector = new FeeCollector(deployer);
        console.log("FeeCollector deployed:", address(collector));

        // 2. Deploy RevenueTracker
        RevenueTracker tracker = new RevenueTracker();
        console.log("RevenueTracker deployed:", address(tracker));

        // 3. Deploy FeeDistributor
        address[] memory recipients = new address[](2);
        uint256[] memory shares = new uint256[](2);
        recipients[0] = deployer;
        recipients[1] = address(collector);
        shares[0] = 7000; // 70% to deployer
        shares[1] = 3000; // 30% to collector

        FeeDistributor distributor = new FeeDistributor(recipients, shares);
        console.log("FeeDistributor deployed:", address(distributor));

        // 4. Deploy InteractiveVault
        InteractiveVault vault = new InteractiveVault(
            IERC20(USDC_BASE_SEPOLIA),
            "BaseVault Interactive USDC",
            "bvUSDC",
            address(collector)
        );
        console.log("InteractiveVault deployed:", address(vault));

        // 5. Deploy VaultFactory
        VaultFactoryWithFees factory = new VaultFactoryWithFees(address(collector));
        console.log("VaultFactory deployed:", address(factory));

        // 6. Deploy Aerodrome Strategy
        AerodromeStrategyWithFees aeroStrategy = new AerodromeStrategyWithFees(
            address(vault),
            USDC_BASE_SEPOLIA,
            address(collector)
        );
        console.log("AerodromeStrategy deployed:", address(aeroStrategy));

        // 7. Deploy Uniswap V3 Strategy
        UniswapV3StrategyWithFees uniStrategy = new UniswapV3StrategyWithFees(
            address(vault),
            USDC_BASE_SEPOLIA,
            address(collector)
        );
        console.log("UniswapV3Strategy deployed:", address(uniStrategy));

        vm.stopBroadcast();

        console.log("\n=== Deployment Summary ===");
        console.log("FeeCollector:", address(collector));
        console.log("RevenueTracker:", address(tracker));
        console.log("FeeDistributor:", address(distributor));
        console.log("InteractiveVault:", address(vault));
        console.log("VaultFactory:", address(factory));
        console.log("AerodromeStrategy:", address(aeroStrategy));
        console.log("UniswapV3Strategy:", address(uniStrategy));
    }
}
