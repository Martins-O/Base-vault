// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CopyTradingWithFees {
    struct Leader {
        address addr;
        uint256 performanceFee; // Basis points
        uint256 followers;
    }
    
    mapping(address => Leader) public leaders;
    mapping(address => address) public following;
    
    event FollowerAdded(address indexed follower, address indexed leader);
    event PerformanceFeeCharged(address indexed leader, uint256 amount);
    
    function becomeLeader(uint256 performanceFee) external {
        require(performanceFee <= 2000, "Fee too high"); // Max 20%
        leaders[msg.sender] = Leader(msg.sender, performanceFee, 0);
    }
    
    function followLeader(address leader) external {
        require(leaders[leader].addr != address(0), "Not a leader");
        following[msg.sender] = leader;
        leaders[leader].followers++;
        emit FollowerAdded(msg.sender, leader);
    }
    
    function chargePerformanceFee(address leader, uint256 profit) external returns (uint256) {
        uint256 fee = (profit * leaders[leader].performanceFee) / 10000;
        emit PerformanceFeeCharged(leader, fee);
        return fee;
    }
}
