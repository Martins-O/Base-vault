// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RevenueTracker {
    struct RevenueData {
        uint256 totalFees;
        uint256 depositFees;
        uint256 withdrawalFees;
        uint256 performanceFees;
        uint256 managementFees;
    }
    
    mapping(address => RevenueData) public vaultRevenue;
    
    event RevenueRecorded(
        address indexed vault,
        string feeType,
        uint256 amount
    );
    
    function recordFee(
        address vault,
        string memory feeType,
        uint256 amount
    ) external {
        RevenueData storage data = vaultRevenue[vault];
        data.totalFees += amount;
        
        if (keccak256(bytes(feeType)) == keccak256("deposit")) {
            data.depositFees += amount;
        } else if (keccak256(bytes(feeType)) == keccak256("withdrawal")) {
            data.withdrawalFees += amount;
        } else if (keccak256(bytes(feeType)) == keccak256("performance")) {
            data.performanceFees += amount;
        } else if (keccak256(bytes(feeType)) == keccak256("management")) {
            data.managementFees += amount;
        }
        
        emit RevenueRecorded(vault, feeType, amount);
    }
    
    function getTotalRevenue(address vault) external view returns (uint256) {
        return vaultRevenue[vault].totalFees;
    }
}
