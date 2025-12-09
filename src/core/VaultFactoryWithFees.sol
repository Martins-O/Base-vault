// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseVault} from "./BaseVault.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VaultFactoryWithFees {
    address[] public allVaults;
    mapping(address => bool) public isVault;
    
    address public feeCollector;
    uint256 public creationFee = 0.001 ether; // Fee to create vault
    
    event VaultCreated(address indexed vault, address indexed asset, address indexed creator);
    event CreationFeeUpdated(uint256 newFee);
    event FeesCollected(uint256 amount);
    
    constructor(address _feeCollector) {
        feeCollector = _feeCollector;
    }
    
    function createVault(
        address asset,
        string memory name,
        string memory symbol
    ) external payable returns (address) {
        require(msg.value >= creationFee, "Insufficient fee");
        
        BaseVault vault = new BaseVault(IERC20(asset), name, symbol);
        allVaults.push(address(vault));
        isVault[address(vault)] = true;
        
        // Collect fee
        if (msg.value > 0) {
            payable(feeCollector).transfer(msg.value);
            emit FeesCollected(msg.value);
        }
        
        emit VaultCreated(address(vault), asset, msg.sender);
        return address(vault);
    }
    
    function vaultCount() external view returns (uint256) {
        return allVaults.length;
    }
    
    function updateCreationFee(uint256 newFee) external {
        creationFee = newFee;
        emit CreationFeeUpdated(newFee);
    }
}
