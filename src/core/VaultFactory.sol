// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseVault} from "./BaseVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VaultFactory {
    address[] public allVaults;
    mapping(address => bool) public isVault;

    event VaultCreated(address indexed vault, address indexed asset);

    function createVault(
        address asset,
        string memory name,
        string memory symbol
    ) external returns (address) {
        BaseVault vault = new BaseVault(IERC20(asset), name, symbol);
        allVaults.push(address(vault));
        isVault[address(vault)] = true;
        emit VaultCreated(address(vault), asset);
        return address(vault);
    }

    function vaultCount() external view returns (uint256) {
        return allVaults.length;
    }
}
