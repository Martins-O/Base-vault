// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TalentProtocolRewards {
    mapping(address => uint256) public builderScores;
    mapping(address => uint256) public rewardsEarned;
    
    event RewardDistributed(address indexed builder, uint256 amount);
    
    function updateBuilderScore(address builder, uint256 score) external {
        builderScores[builder] = score;
    }
    
    function distributeReward(address builder, uint256 amount) external {
        rewardsEarned[builder] += amount;
        emit RewardDistributed(builder, amount);
    }
    
    function getBuilderScore(address builder) external view returns (uint256) {
        return builderScores[builder];
    }
}
